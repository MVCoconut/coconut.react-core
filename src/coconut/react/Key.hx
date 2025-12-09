package coconut.react;

abstract Key(Dynamic) from String from Bool from Float from Int #if genes from {} #end {
  #if !genes
    @:keep @:from static function ofObj(o:{}):Key {
      var id =
        #if (js_es >= 6)
          (cast o)[cast ID] ??= counter++;
        #else
          @:privateAccess (haxe.ds.ObjectMap.getId(o) || haxe.ds.ObjectMap.assignId(o));
        #end
      return id;
    }
    #if (js_es >= 6)
      static var counter = 0;
      static final ID = new js.lib.Symbol();
    #end
  #end
}
