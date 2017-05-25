package coconut.react;

#if react
typedef ReactElement = react.ReactComponent.ReactElement;
#else
typedef ReactElement = {
  var type(default, never):haxe.extern.EitherType<String, Class<Dynamic>>;
  var props(default, never):Dynamic;
  @:optional var key(default, never):haxe.extern.EitherType<Int, String>;
  @:optional var ref(default, never):Dynamic;
}
#end