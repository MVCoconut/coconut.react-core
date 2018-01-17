package coconut.react;

@:pure 
abstract ReactChild(Dynamic) from ReactElement from String from Int from Float from Bool to ReactElement {

  @:from static function ofView(view:coconut.react.Renderable):ReactChild 
    return view.reactify();

  static public inline function flatten(children:Array<ReactChild>):ReactChild
    return cast children;

  #if react_core
  @:to inline function asChild():react.component.props.Props.Child
    return cast this;
  #end
}