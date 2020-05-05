package coconut.react;

import coconut.ui.macros.ViewBuilder;

class View {
  static function hxx(_, e)
    return coconut.react.macros.HXX.parse(e);

  static function afterBuild(ctx:ViewInfo) {
    var cls = ctx.target.target;

    for (m in ctx.target)
      if (m.name == 'state')
        m.pos.error('Name `state` is reserved in coconut.react. Consider using `currentState` instead.');

    var self = toComplex(cls);

    var attributes = TAnonymous(ctx.attributes.concat(
      (macro class {
        @:optional var key(default, never):coconut.react.Key;
        @:optional var ref(default, never):coconut.ui.Ref<$self>;
      }).fields
    ));

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

    var added = ctx.target.addMembers(macro class {
      #if react_devtools
      @:keep @:noCompletion var __stateMap:{};
      #end
      static public function fromHxx(attributes:$attributes):coconut.ui.RenderResult {
        return cast react.React.createElement(cast $i{ctx.target.target.name}, attributes);
      }
    });

    parametrize(added[added.length - 1], cls);

    for (f in ctx.target)
      if (f.name == 'forceUpdate')
        f.meta = (switch f.meta {
          case null: [];
          case v: v;
        }).concat([{ name: ':native', params: [macro '_coco_forceUpdate'], pos: (macro null).pos }]);
  }
  static function autoBuild()
    return ViewBuilder.autoBuild({
      renders: macro : coconut.react.RenderResult,
      afterBuild: afterBuild,
    });
}