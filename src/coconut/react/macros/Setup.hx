package coconut.react.macros;

#if macro
import coconut.ui.macros.*;
import tink.hxx.*;
import haxe.macro.*;
import haxe.macro.Type;
import haxe.macro.Expr;
using haxe.macro.Tools;
using tink.MacroApi;

class Setup {

  static function toComplex(cls:ClassType)
    return TPath(cls.name.asTypePath([for (p in cls.params) TPType(p.name.asComplexType())]));

  static function parametrize(m:Member, self:ClassType)
    m.getFunction().sure().params = [for (p in self.params) p.toDecl()];

  static function hxxAugment() {
    var cls = Context.getLocalClass().get(),
        fields = Context.getBuildFields();

    switch cls {
      case { name: 'View', pack: ['coconut', 'ui'] }:
        for (f in fields)
          if (f.name == 'forceUpdate')
            f.meta.push({ name: ':native', params: [macro "cocoForceUpdate"], pos: f.pos });
        return fields;
      default:
    }

    for (f in fields)
      if (f.name == 'fromHxx') return null;

    var type = toComplex(cls);

    var children = null,
        childrenOptional = true;//TODO: this flag is actually not evaluated

    var props = switch (macro (null:$type).props).typeof().sure().reduce() {
      case TDynamic(null):
        children = macro : coconut.ui.Children;
        macro : Dynamic;
      case TAnonymous(_.get().fields => fields):

        var ret:Array<Field> = [],
            hasRef = false,
            hasKey = false;

        for (f in fields)
          switch f.name {
            case 'children':

              childrenOptional = f.meta.has(':optional');
              children = f.type.toComplex();

            default:

              if (f.name == 'key')
                hasKey = true;

              if (f.name == 'ref')
                hasRef = true;

              ret.push({
                meta: f.meta.get(),
                kind: FVar(f.type.toComplex()),
                name: f.name,
                pos: f.pos,
              });
          }

        if (!hasRef)
          ret.push((macro class {
            @:optional var ref(default, never):coconut.ui.Ref<$type>;
          }).fields[0]);

        if (!hasKey)
          ret.push((macro class {
            @:optional var key(default, never):coconut.react.Key;
          }).fields[0]);

        TAnonymous(ret);
      case t:
        cls.pos.error('unsupported prop type $t');
    }

    var id = cls.isPrivate ? macro $i{cls.name} : macro $p{'${cls.module}.${cls.name}'.split('.')};
    var add = (
      if (children == null)
        macro class {
          inline static public function fromHxx(props:$props):react.ReactComponent.ReactSingleFragment
            return cast react.React.createElement($id, props);
        }
      else
        macro class {
          inline static public function fromHxx(props:$props, ?children:$children):react.ReactComponent.ReactSingleFragment
            return (cast react.React.createElement).apply(react.React, [($id:react.ReactType), untyped props].concat(untyped children));
        }
    ).fields;

    parametrize(add[0], cls);

    return fields.concat(add);
  }

  static function all() {

    Compiler.addGlobalMetadata('coconut.ui.View', '@:ignore_empty_render', false);

    var comp = Context.getType('react.ReactComponent').getClass();

    if (!comp.meta.has(':hxxAugmented')) {//TODO: just move this to haxe-react
      comp.meta.add(':hxxAugmented', [], (macro null).pos);
      comp.meta.add(':autoBuild', [macro coconut.react.macros.Setup.hxxAugment()], (macro null).pos);
    }

    Context.getType('coconut.ui.View').getFields();//Pretty whacky way to force typing order

    coconut.ui.macros.ViewBuilder.afterBuild.whenever(function (ctx) {
      var cls = ctx.target.target;

      for (m in ctx.target)
        if (m.name == 'state')
          m.pos.error('Name `state` is reserved in coconut.react. Consider using `currentState` instead.');

      var self = toComplex(cls);

      var attributeFields = ctx.attributes.concat(
        (macro class {
          @:optional var key(default, never):coconut.react.Key;
          @:optional var ref(default, never):coconut.ui.Ref<$self>;
        }).fields
      );
      var attributes = TAnonymous(attributeFields);

      {
        var render = ctx.target.memberByName('render').sure();
        render.addMeta(':native', [macro 'coconutRender']);
        var ctor = ctx.target.getConstructor();
        @:privateAccess switch ctor.meta { //TODO: this is rather horrible
          case null:
            ctor.meta = [{ name: ':keep', params: [], pos: ctor.pos }];
          case meta: 
            meta.push({ name: ':keep', params: [], pos: ctor.pos });
        }
      }

      var states = [];
      var stateMap = EObjectDecl(states).at();
      for (s in ctx.states) {
        var s = s.name;
        states.push({
          field: s,
          expr: macro function () return this.$s,
        });
      }

      #if react_devtools
      ctx.target.getConstructor().addStatement(macro this.__stateMap = $stateMap);
      #end
      
      var reactType = macro cast $i{ctx.target.target.name};
      
      // HOC wrap
      switch cls.meta.extract(':react.hoc') {
        case []:
          // do nothing
        case wraps:
          var wrapped = macro cast $i{ctx.target.target.name};
          
          for(i in 0...wraps.length) { // loop in reverse, so that the first meta will become the outermost wrap
            switch wraps[wraps.length - i - 1] {
              case {params: [wrapper]}:
                wrapped = macro $wrapper($wrapped);
              case {params: [wrapper, e = macro (_:$ct)]}: // https://github.com/HaxeFoundation/haxe-evolution/pull/44
                switch ct.toType() {
                  case Success(_.reduce().toComplex() => TAnonymous(fields)):
                    for(field in fields) {
                      switch field.kind {
                        case FVar(ct, e): field.kind = FVar(macro:coconut.data.Value<$ct>, e);
                        case FProp(get, set, ct, e): field.kind = FProp(get, set, macro:coconut.data.Value<$ct>, e);
                        case _: // TODO:
                      }
                      attributeFields.push(field);
                    }
                  case _:
                    e.pos.error('Expected anonymous structure type');
                }
                wrapped = macro $wrapper($wrapped);
              case {params: [wrapper, _], pos: pos}:
                pos.error('Second parameter of @:wrap should be a ETypeCheck expr');
              case {pos: pos}:
                pos.error('@:wrap must have one or two parameters');
            }
          }
          
          ctx.target.addMembers(macro class {
            @:keep static var __hoc:react.ReactType = $wrapped;
          });
          
          reactType = macro $reactType.__hoc;
      }
      
      // injected props
      var init = 
        switch ctx.target.memberByName('__initAttributes') {
          case Success({kind: FFun(f)}): f;
          case _: throw 'unreachable';
        }
      
      for(member in ctx.target)
        switch [member.kind, member.meta.filter(function(meta) return meta.name == ':react.injected')] {
          case [_, []]:
            // skip
          case [FFun(_), _]:
            member.pos.error('@:react.injected does not work on functions');
          case [FVar(ct, e) | FProp(_, _, ct, e), [meta = {params: params}]]:
            if(e != null) e.pos.error('Field with @:react.injected cannot have an initializer');
            var name = switch params {
              case []:
                member.name;
              case [macro $v{(name:String)}]:
                name;
              case _:
                meta.pos.error('@:react.injected should have at most one parameter');
            }
            var internal = '__coco_${member.name}';
            var getter = 'get_${member.name}';
            
            member.kind = FProp('get', 'never', ct, null);
            ctx.target.addMembers(macro class {
              @:noCompletion private var $internal:tink.state.Observable<$ct> =
                new tink.state.State(null);
              inline function $getter() return $i{internal}.value;
            });
            
            init.expr = init.expr.concat(macro {
              var value:Dynamic = (cast $i{init.args[0].name}).$name;
              if(($i{internal}:Dynamic) != value) {
                if(Std.is(value, tink.state.Observable.ObservableObject))
                  $i{internal} = value; // TODO: this is so hacky, fix me please
                else
                  (cast $i{internal}:tink.state.State<$ct>).set(value);
              }
            });
            
          case _:
            member.pos.error('Multiple @:react.injected is not supported');
        }
      
      var added = ctx.target.addMembers(macro class {
        #if react_devtools
        @:keep @:noCompletion var __stateMap:{};
        #end
        static public function fromHxx(attributes:$attributes):coconut.ui.RenderResult {
          return cast react.React.createElement($reactType, attributes);
        }
      });
      parametrize(added[added.length - 1], cls);
    });
  }
}
#end
