package coconut.react;

import coconut.ui.RenderResult;
import tink.state.Observable;
import js.html.Element;
import coconut.react.*;

using tink.CoreApi;

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
      this.__wrapper = React.createComponent(Wrapper, untyped {
        key: this.id,
        rendered: __rendered,
      });
    return this.__wrapper;
  }

  // inline function __make(tag:CreateElementType, attr:Dynamic, ?children:Array<ReactChild>)
    // return React.createElement(tag, attr, children);

  function div(attr:{}, ?children)//TODO: this does not belong here at all
    return React.createElement('div', attr, children);

  function span(attr:{ ?key: Dynamic }, ?children)
    return React.createElement('span', attr, children);

  #if !react_native
  public function mountInto(container:Element): { function unmount():Bool; } {
    ReactDom.render(
      reactify(), 
      container
    );
    return {
      unmount: function () return ReactDom.unmountComponentAtNode(container),
    }
  }
  #end
}

#if !react_native
#if react
private typedef ReactDom = react.ReactDOM;
#else

@:native('ReactDOM')
private extern class ReactDom {
  static function render(element:ReactElement, container:Element, ?callback:Void -> Void):ReactElement;
  static function unmountComponentAtNode(container:Element):Bool;
}
#end
#end

private class Wrapper extends ReactComponent<
  { rendered: Observable<RenderResult> }, 
  { view: RenderResult }
> { 
  
  var link:CallbackLink;
  
  function new(props) {
    super(props);
    
    state = { view: @:privateAccess props.rendered.value };
  }
  
  override function componentWillMount()
      link = @:privateAccess props.rendered.bind(function(r) setState(function (_, _) return { view: r }));
  
  override function componentWillUnmount()
      if(link != null) {
        link.dissolve();
        link = null;
      }
  
  override function render():ReactElement 
    return this.state.view;
}