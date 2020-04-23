package coconut.react.macros;

#if macro
import tink.hxx.*;

class HXX {

  static public var defaults(default, never) = new tink.priority.Queue<Lazy<Array<Named<Expr.Position->Tag>>>>();

  static public var generator = new Generator(function ()
    return [for (group in defaults) for (tag in group.get()) tag]
  );

  static public function parse(e)
    return coconut.ui.macros.Helpers.parse(e, generator, 'coconut.react.View.createFragment');
}
#end