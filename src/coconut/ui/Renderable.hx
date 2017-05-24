package coconut.ui;

import tink.state.Observable;
import react.ReactComponent;

class Renderable {
	var __rendered:Observable<ReactElement>;
	
	public function new(rendered, ?key) {
		__rendered = rendered;
		init();
	}
	
	function init() {}
}