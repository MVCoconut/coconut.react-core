package coconut.react;

abstract Key(Dynamic) from String from Bool from Float from Int {
  @:keep @:from static function ofObj(o:{}):Key untyped {
    var id = haxe.ds.ObjectMap.getId(o) || haxe.ds.ObjectMap.assignId(o);
    return id;
  }
}