package coconut.react;

import coconut.react.internal.NativeComponent;
import coconut.ui.internal.ImplicitContext;
import react.React.createElement as h;

private typedef Attr = { final defaults:ImplicitValues; final children:Children; };

class Implicit extends NativeComponent<{}, Attr, ImplicitContext> {
  @:native('__coco_context') var context:ImplicitContext;

  function new() {
    super();
    this.context = new ImplicitContext(() -> this.__react_context);
  }

  @:keep function render() {
    this.context.update(__react_props.defaults);
    return h(CTX.Provider, { value: this.context }, View.createFragment({}, __react_props.children));
  }

  static final CTX = react.React.createContext(new ImplicitContext());

  static public function fromHxx(attr:Attr)
    return h(cast Implicit, attr);
}