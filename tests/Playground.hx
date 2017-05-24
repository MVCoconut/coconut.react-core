package;

import coconut.react.Wrapper;
import coconut.ui.View;
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
	
	function render() {
		return {
			"$$typeof": untyped __js__('Symbol.for("react.element")'),
			type: 'div',
			props: {
				children: {
					"$$typeof": untyped __js__('Symbol.for("react.element")'),
					type: 'span',
					props: {
						children: 'Hello, Coconut! ($counter)',
					}
				}
			},
			key: null,
			ref: null,
		}
	}
	
	override function init() {
		var timer = new haxe.Timer(500);
		timer.run = function() counter = counter + 1;
	}
		
}