package ;

import coconut.ui.*;
import tink.testrunner.*;
import tink.unit.*;

class RunTests {

  static function main() {
    Runner.run(TestBatch.make([
      new HocTest(),
    ])).handle(Runner.exit);
  }
  
}

class Foo extends View {
  function render() ' 
    <Isolated>Hello, world!</Isolated>
  ';
}
