package coconut.react;

@:native('React') extern class React {  
  @:native('createElement') 
  static function createComponent<Props, State>(c:Class<ReactComponent<Props, State>>, props:Props):ReactElement;
  static function createElement(type:String, ?attrs:Dynamic, children:Array<ReactChild>):ReactElement;
}