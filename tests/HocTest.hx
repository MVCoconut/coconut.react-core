package;

import haxe.Timer;
import react.React;
import js.Browser.*;
import coconut.Ui.hxx;
import react.ReactType;
import react.ReactComponent;

using coconut.ui.Renderer;

@:asserts
class HocTest {
	public function new() {}
	
	public function test() {
		var div = document.createDivElement();
		document.body.appendChild(div);
		
		var expected = 0;
		
		function done() {
			document.body.removeChild(div);
			asserts.done();
		}
		
		function update(foo:Int) {
			asserts.assert(foo == expected++);
		}
		
		Renderer.mount(div, hxx('<Wrapped onUpdate=${update} onFinish=${done}/>'));
		
		return asserts;
	}
}

@:react.hoc(wrapper)
private class Wrapped extends coconut.ui.View {
	@:attr var onUpdate:(foo:Int)->Void;
	@:attr var onFinish:()->Void;
	
	@:react.injected var foo:Int;
	
	static function wrapper(component:ReactType):ReactType {
		return function(props)
			return React.createElement(Injector, js.Object.assign({component: component}, props));
	}
	
	function render() '<div>$foo</div>';
	
	function viewDidRender() {
		onUpdate(foo);
		if(foo == 5) onFinish();
	}
}

// TODO: marking this as non-private works on 4.0.5 but not nightly
private class Injector extends ReactComponent {
	final timer:Timer;
	
	public function new(props) {
		super(props);
		state = {foo: 0}
		timer = new Timer(123);
		timer.run = function() setState({foo: state.foo + 1});
	}
	override function render() {
		return React.createElement(cast props.component, js.Object.assign({foo: state.foo}, props));
	}
	override function componentWillUnmount() {
		timer.stop();
	}
}