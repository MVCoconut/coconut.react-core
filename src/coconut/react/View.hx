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

class ViewBase extends NativeComponent<{ vtree: RenderResult }, {}, ImplicitContext> {

  @:noCompletion var __rendered:Observable<RenderResult>;
  @:noCompletion var __binding:Binding;
  @:noCompletion var __viewMounted:Void->Void;
  @:noCompletion var __viewUpdated:Void->Void;
  @:noCompletion var __viewUnmounting:Void->Void;

  public function new(
    rendered:Observable<RenderResult>,
    mounted:Void->Void,
    updated:Void->Void,
    unmounting:Void->Void
  ) {
    js.Syntax.code('{0}.call(this)', NativeComponent);
    this.__rendered = rendered;
    this.__react_state = __snap();
    this.__viewMounted = mounted;
    this.__viewUpdated = updated;
    this.__viewUnmounting = unmounting;
  }

  @:noCompletion function __snap():{ vtree: RenderResult }
    return { vtree: Observable.untracked(() -> __rendered.value) };

  @:keep @:noCompletion @:final function componentDidMount() {
    if (__viewMounted != null) __viewMounted();
  }

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

  @:keep @:noCompletion @:final function shouldComponentUpdate(_, next:{ vtree: RenderResult })
    return __react_state.vtree != next.vtree;

  @:keep @:noCompletion @:final @:native('render') function reactRender() {
    if (this.__binding == null) {
      this.__binding = new Binding(this);
    }
    return switch this.__react_state.vtree {
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

private class Binding {

  final target:ViewBase;
  final link:CallbackLink;

  public function new(target) @:privateAccess {
    this.target = target;
    this.link = target.__rendered.bind(_ -> target.__react_setState(target.__snap()));
  }

  public function destroy()
    this.link.cancel();

  #if tink_state.debug
  @:keep function toString():String
    return 'Binding';
  #end
}