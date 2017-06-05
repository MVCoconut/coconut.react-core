package coconut.react;

#if react_native
@:jsRequire('react')
#else
@:native('React') 
#end
extern class React {  
  @:native('createElement') 
  static function createComponent<Props, State>(c:Class<ReactComponent<Props, State>>, props:Props):ReactElement;
  static function createElement(type:String, ?attrs:Dynamic, children:Array<ReactChild>):ReactElement;
}