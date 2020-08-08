package ;

import coconut.ui.*;
import react.ReactComponent;
import react.ReactType;
import tink.unit.*;
import tink.testrunner.*;
import Issue5;

class RunTests {

  static function main() {
    Runner.run(TestBatch.make([
      new InjectTest()
    ])).handle(Runner.exit);
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