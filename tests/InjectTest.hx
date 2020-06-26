package;

import js.html.*;
import js.Browser.*;
import coconut.react.*;
import react.React;
import react.ReactComponent;
import react.ReactType;
import react.ReactMacro.jsx;

using tink.CoreApi;

@:asserts
class InjectTest {
	var div:DivElement;
	
	public function new() {
		div = document.createDivElement();
		document.body.appendChild(div);
	}
	
	public function test() {
		Renderer.mount(div, '<Injected/>');
		
		var e = document.querySelector('div#injected');
		asserts.assert(e.innerHTML == 'bar:1');
		
		Future.delay(200, Noise)
			.next(_ -> {
				asserts.assert(e.innerHTML == 'bar:2');
				Renderer.mount(div, null);
				Noise;
			})
			.handle(asserts.handle);
			
		return asserts;
	}
}


@:react.hoc(InjectTest.Injected.wrap)
class Injected extends View {
	@:react.injected var foo:String;
	function render() '<div id="injected">$foo</div>';
	
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