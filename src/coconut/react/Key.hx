package coconut.react;

abstract Key(Dynamic) from String from Bool from Float from Int {
  @:from static function ofObj(o:{}):Key
    return untyped haxe.ds.ObjectMap.getId(o) || haxe.ds.ObjectMap.assignId(o);
}