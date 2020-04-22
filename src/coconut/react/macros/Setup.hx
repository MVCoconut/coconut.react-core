package coconut.react.macros;

class Setup {

  static function hxxAugment() {

    var cls = Context.getLocalClass().get(),
        fields = Context.getBuildFields();

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
    var comp = Context.getType('react.ReactComponent').getClass();

    if (!comp.meta.has(':hxxAugmented')) {
      comp.meta.add(':hxxAugmented', [], (macro null).pos);
      comp.meta.add(':autoBuild', [macro coconut.react.macros.Setup.hxxAugment()], (macro null).pos);
    }

    // Context.getType('coconut.ui.View').getFields();//Pretty whacky way to force typing order
  }
}