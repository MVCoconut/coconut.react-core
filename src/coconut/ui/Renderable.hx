package coconut.ui;

import tink.state.Observable;
import coconut.react.*;

class Renderable {
  var __rendered:Observable<RenderResult>;
  var __wrapper:ReactElement;
  
  public function new(rendered, ?key) {
    __rendered = rendered;
    init();
  }
  
  function init() {}

  public function reactify():RenderResult {
    if (this.__wrapper == null)
      this.__wrapper = Dom.node(Wrapper, {
      key: untyped this.id,
      rendered: __rendered,
    });
    return this.__wrapper;
  }
  
}

@:keep private class Wrapper extends ReactComponent<{ rendered: Observable<RenderResult> }, { view: RenderResult }> { 
  
  function new(props) {
    super(props);
    
    @:privateAccess {
      state = { view: props.rendered.value };
      props.rendered.bind(function(r) setState(function (_, _) return { view: r }));
    }
  }
  
  override function render():ReactElement 
    return this.state.view;
}