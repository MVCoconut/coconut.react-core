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
  
  @:state var inner:Int = 0;
  @:state var outer:Int = 0;
  var renderCount = 0;
  function render() 
    return div({}, [
	  span({}, ['Hello Coconut! #${id} ${renderCount++} ${outer}']),
	  coconut.ui.tools.ViewCache.create(
		new TextView(coconut.ui.macros.HXX.merge({ key: this, value: Std.string(inner)}))
	  )
	]);
  
  override function init() {
    var timer = new haxe.Timer(500);
    timer.run = function() {
	  inner++;
	  outer = inner >> 2;
	}
  }
    
}

class TextView extends View<{value:String}> {
  function render() 
    return div({}, [
      span({}, ['TextView #$id - ', value])
    ]);
}