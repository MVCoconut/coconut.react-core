package ;

import coconut.ui.*;
import react.ReactComponent;
import react.ReactType;

class RunTests {

  static function main() {
    travix.Logger.println('it works');
    travix.Logger.exit(0); // make sure we exit properly, which is necessary on some targets, e.g. flash & (phantom)js
  }

}

@:keep class Foo extends View {
  static final native:ReactTypeOf<{ foo:Int, bar: String }> = null;
  function render() '
    <>
      Hello, world!
      <Native key="1" foo={5} bar="bar" />
      <native foo={5} bar="bar" />
    </>
  ';
}

extern class Native extends react.ReactComponent.ReactComponentOfProps<{ foo:Int, bar: String }> {}