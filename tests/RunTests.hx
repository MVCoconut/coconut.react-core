package ;

import coconut.ui.*;

class RunTests {

  static function main() {
    travix.Logger.println('it works');
    travix.Logger.exit(0); // make sure we exit properly, which is necessary on some targets, e.g. flash & (phantom)js
  }
  
}

class Foo extends View {
  function render() ' 
    <Isolated>Hello, world!</Isolated>
  ';
}
