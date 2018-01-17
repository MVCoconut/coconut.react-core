package coconut.react.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import tink.hxx.*;
using tink.MacroApi;
using tink.CoreApi;

private class Generator extends coconut.ui.macros.Generator {
  override function instantiate(name:StringAt, isClass:Bool, key:Option<Expr>, attr:Expr, children:Option<Expr>)
    return 
      if (isClass) {
        var react = macro @:pos(name.pos) coconut.react.React.createComponent(
          $i{name.value}, $attr
        );
        if (react.typeof().isSuccess()) react;
        else super.instantiate(name, isClass, key, attr, children);
      }
      else super.instantiate(name, isClass, key, attr, children);
}

class Setup {
  
  static var generator = new Generator();
  static function tags() {
    return null;
  }
  static function all() {
    coconut.ui.macros.HXX.generator = generator;
  }
}
#end