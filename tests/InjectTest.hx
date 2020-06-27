package;

import js.html.*;
import js.Browser.*;
import coconut.react.*;
import coconut.Ui.*;
import react.React;
import react.ReactComponent;
import react.ReactType;
import react.ReactMacro.jsx;

using tink.CoreApi;

@:asserts
class InjectTest {
	public function new() {}
	
	public function test() {
		var rendered = js.Lib.require('react-test-renderer').create(hxx('<Injected/>'));
		
		var children:Array<String> = rendered.root.findByProps({id: 'injected'}).children;
		asserts.assert(children.length == 1);
		asserts.assert(children[0] == 'bar:1');
		
		Future.delay(200, Noise)
			.next(_ -> {
				var children:Array<String> = rendered.root.findByProps({id: 'injected'}).children;
				asserts.assert(children.length == 1);
				asserts.assert(children[0] == 'bar:2');
				Noise;
			})
			.handle(asserts.handle);
			
		return asserts;
	}
}


@:react.hoc(InjectTest.Injected.wrap)
class Injected extends View {
	@:react.injected var foo:String;
	function render() {
		return React.createElement('div', {id: 'injected'}, foo);
	}
	
	public static function wrap(v:ReactType):ReactType {
		return function(props) return React.createElement(Wrapper, {component: v});
	}
}

class Wrapper extends ReactComponent {
	public function new(props) {
		super(props);
		state = {foo: 1}
	}
	
	override function render() {
		return React.createElement(untyped props.component, {foo: 'bar:' + state.foo});
	}
	
	override function componentDidMount() {
		haxe.Timer.delay(function() setState({foo: state.foo + 1}), 20);
	}
}