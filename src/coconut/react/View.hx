package coconut.react;

import coconut.ui.internal.ImplicitContext;
import coconut.react.internal.NativeComponent;
import tink.state.internal.*;
import tink.state.*;
import js.lib.Object;

using tink.CoreApi;

@:build(coconut.ui.macros.ViewBuilder.build((_:coconut.react.RenderResult)))
@:autoBuild(coconut.react.View.autoBuild())
class View extends ViewBase {
  static final TRE = js.Syntax.code("(typeof Symbol === \"function\" && Symbol.for && Symbol.for(\"react.element\")) || 0xeac7");

  macro function hxx(e);

  @:noCompletion static public function createFragment(attr:{}, children:Children):RenderResult
    return (cast react.React.createElement).apply(null, [react.Fragment, attr].concat(cast children));
}

class ViewBase extends NativeComponent<{ revision: Int }, {}, ImplicitContext> {

  @:noCompletion var __rendered:Observable<RenderResult>;
  @:noCompletion var __binding:Binding;
  @:noCompletion var __viewMounted:Void->Void;
  @:noCompletion var __viewUpdated:Void->Void;
  @:noCompletion var __viewUnmounting:Void->Void;
  @:noCompletion var __last:RenderResult;

  public function new(
    rendered:Observable<RenderResult>,
    mounted:Void->Void,
    updated:Void->Void,
    unmounting:Void->Void
    #if tink_state.debug
      , ?toString:()->String
    #end
  ) {
    js.Syntax.code('{0}.call(this)', NativeComponent);
    this.__react_state = { revision: 0 };
    this.__rendered = rendered;
    this.__viewMounted = mounted;
    this.__viewUpdated = updated;
    this.__viewUnmounting = unmounting;
  }


  @:keep @:noCompletion @:final function componentDidMount()
    if (__viewMounted != null) __viewMounted();

  @:keep @:noCompletion @:final function componentDidUpdate(_, _)
    if (__viewUpdated != null) __viewUpdated();

  @:keep @:noCompletion @:final function componentWillUnmount() {
    switch __binding {
      case null:
      case v:
        __binding = null;
        v.destroy();
    }
    if (__viewUnmounting != null) __viewUnmounting();
  }

  function __getRender()
    return Observable.untracked(() -> (__rendered:ObservableObject<RenderResult>).getValue());

  @:keep @:noCompletion @:final function shouldComponentUpdate(_, _)
    return __last != __getRender();

  @:keep @:noCompletion @:final @:native('render') function reactRender() {
    /*
      Creating the binding in render is meh ...
      Before, this was done in componentDidMount, but that means that children bind before parents which leads to
      weird rendering order https://github.com/MVCoconut/coconut.react-dom/issues/8

      Another seemingly good place would be the constructor,
      but there are two issues with that:

      1. Apparently the React Context is not yet available
      2. I remember coming across a section in the React docs suggesting that React may well instantiate a view and yet
         choose not to mount it (because concurrent mode can do wondrous things).

      So all in all, this is the least troublesome place to wire up things (╯°□°)╯︵ ┻━┻

      So long as the constructor of Binding doesn't mess with the state, it should actually be safe to do.
    */
    if (this.__binding == null)
      this.__binding = new Binding(this);

    return switch __last = __getRender() {
      case js.Syntax.typeof(_) => 'undefined': null;
      case v: v;
    }
  }

  static function __init__() {
    #if react_devtools
    Object.defineProperty(untyped ViewBase.prototype, 'state', {
      get: function () return js.Lib.nativeThis.__state,
      set: function (arg:Dynamic) if (arg != null) {

        js.Lib.nativeThis.__state = arg;

        if (!arg.__subverted) {//Muahaha!

          Object.defineProperty(arg, '__subverted', {
            enumerable: false,
            value: true
          });

          Object.defineProperty(arg, 'vtree', {
            enumerable: false,
            value: arg.vtree
          });

          var states:haxe.DynamicAccess<Void->Dynamic> = js.Lib.nativeThis.__stateMap;

          for (name in states.keys())
            Object.defineProperty(arg, name, {
              enumerable: true,
              get: states[name]
            });
        }
      }
    });
    #end

    Object.defineProperty(untyped ViewBase.prototype, 'props', {
      get: function () return js.Lib.nativeThis.__props,
      set: function (attr:Dynamic) if (attr != null) {
        js.Lib.nativeThis.__props = attr;
        #if react_devtools
        if (!attr.__cct) {

          var actual = Reflect.copy(attr);

          for (f in Reflect.fields(actual)) {
            var o:Observable.ObservableObject<Dynamic> = Reflect.field(actual, f);
            if (!Reflect.isFunction(o.getValue))
              Reflect.setField(actual, f, Observable.const(o));
          }

          Object.defineProperty(attr, '__cct', {
            value: actual,
            enumerable: false,
          });

          for (field in Reflect.fields(actual))
            Object.defineProperty(attr, field, {
              get: function () return (Reflect.field(actual, field) : Observable<Dynamic>).value,
              enumerable: true,
            });
        }
        attr = attr.__cct;
        #end
        if(js.Lib.nativeThis.__initAttributes) // analyzer could have removed empty function
          js.Lib.nativeThis.__initAttributes(attr);//TODO: unhardcode __initAtributes identifier
      }
    });
  }
}

private class Binding {//TODO: try to make this an Invalidatable and use the actual Revision ... the last attempt led to infinite recursion though ¯\_(ツ)_/¯

  final target:ViewBase;
  final link:CallbackLink;

  public function new(target) @:privateAccess {
    this.target = target;
    var first = true;
    this.link = target.__rendered.bind(_ -> if (first) first = false else target.__react_setState({ revision: target.__react_state.revision + 1 }));
  }

  public function destroy()
    this.link.cancel();

  #if tink_state.debug
  @:keep function toString():String
    return 'Binding';
  #end
}