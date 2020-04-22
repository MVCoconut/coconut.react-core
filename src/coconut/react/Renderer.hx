package coconut.react;

class Renderer {

  #if !macro
  static public inline function updateAll()
    ViewBase.updateAll();
  #end

  static public macro function hxx(e)
    return coconut.react.macros.HXX.parse(e);
}