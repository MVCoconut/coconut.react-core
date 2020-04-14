package coconut.ui;

class Renderer {

  #if !macro
  static public inline function updateAll()
    ViewBase.updateAll();
  #end

  static public macro function hxx(e)
    return coconut.ui.macros.HXX.parse(e, 'coconut.react.View.createFragment');
}