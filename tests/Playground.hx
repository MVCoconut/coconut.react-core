package;

import coconut.react.Wrapper;
import coconut.ui.View;
import coconut.react.Dom.*;
import coconut.Ui.hxx;
import js.Browser.*;
import react.React;
import react.ReactDOM;
import react.ReactMacro.jsx;

class Playground {
  static function main() {
    
    ReactDOM.render(jsx('<Wrapper view=${new CoconutView({})}/>'), document.getElementById('app'));
    
  }
}

class CoconutView extends View<{}> {
  
  @:state var counter:Int = 0;
  
  function render() 
    return div({}, [
	  span({}, ['Hello Coconut!']),
	  coconut.ui.tools.ViewCache.create(
		new TextView(coconut.ui.macros.HXX.merge({ key: this, value: Std.string(counter)}))
	  )
	]);
  
  override function init() {
    var timer = new haxe.Timer(500);
    timer.run = function() counter = counter + 1;
  }
    
}

class TextView extends View<{value:String}> {
  function render() 
    return div({}, [
      span({}, ['TextView #$id - ', value])
    ]);
}