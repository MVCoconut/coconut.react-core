package coconut.react;

import coconut.ui.internal.ImplicitContext;
import coconut.react.internal.NativeComponent;
import tink.state.internal.*;
import tink.state.*;
import js.lib.Object;

using tink.CoreApi;

private typedef Render = Lazy<RenderResult>;//without this some part of the react component macro seems to hang

@:build(coconut.ui.macros.ViewBuilder.build((_:coconut.react.RenderResult)))
@:autoBuild(coconut.react.View.autoBuild())
class View extends ViewBase {
  static final TRE = js.Syntax.code("(typeof Symbol === \"function\" && Symbol.for && Symbol.for(\"react.element\")) || 0xeac7");

  macro function hxx(e);

  @:noCompletion static public function createFragment(attr:{}, children:Children):RenderResult
    return (cast react.React.createElement).apply(null, [react.Fragment, attr].concat(cast children));
}

class ViewBase extends NativeComponent<{ vtree: Render }, {}, ImplicitContext> {

  @:noCompletion var __rendered:Observable<RenderResult>;
  @:noCompletion var __link:CallbackLink;
  @:noCompletion var __viewMounted:Void->Void;
  @:noCompletion var __viewUpdated:Void->Void;
  @:noCompletion var __viewUnmounting:Void->Void;
  @:noCompletion var __rewrapped:RenderResult;

  public function new(
    rendered:Observable<RenderResult>,
    mounted:Void->Void,
    updated:Void->Void,
    unmounting:Void->Void
  ) {
    js.Syntax.code('{0}.call(this)', NativeComponent);
    this.__react_state = __snap();

    __rendered = rendered;

    this.__viewMounted = mounted;
    this.__viewUpdated = updated;
    this.__viewUnmounting = unmounting;
  }

  @:noCompletion function __snap():{ vtree: Render }
    return { vtree: function () return __rendered.value };

  @:keep @:noCompletion @:final function componentDidMount() {
    __link = __rendered.bind(function (_) __react_setState(__snap()));//not my most glorious moment ... a better solution would probably be to poll in render and forceUpdate when becameInvalid
    if (__viewMounted != null) __viewMounted();
  }

  @:keep @:noCompletion @:final function componentDidUpdate(_, _)
    if (__viewUpdated != null) __viewUpdated();

  @:keep @:noCompletion @:final function componentWillUnmount() {
    __link.cancel();
    if (__viewUnmounting != null) __viewUnmounting();
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

  @:keep @:noCompletion @:final function shouldComponentUpdate(_, next:{ vtree: Render })
    return __react_state.vtree.get() != next.vtree.get();

  @:keep @:noCompletion @:final @:native('render') function reactRender()
    return switch this.__react_state.vtree.get() {
      case js.Syntax.typeof(_) => 'undefined': null;
      case v: v;
    }
}