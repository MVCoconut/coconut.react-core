package coconut.ui;

import tink.state.*;

using tink.CoreApi;

private typedef Render = Lazy<RenderResult>;//without this some part of the react component macro seems to hang

@:ignoreEmptyRender
class Renderer extends react.ReactComponent.ReactComponentOfState<{ vtree: Render }> {// consider *not* deriving this from ReactComponent but instead add `isReactComponent = {}`
  
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

    super();

    this.state = __snap();

    __rendered = rendered;

    this.__viewMounted = mounted;
    this.__viewUpdated = updated;
    this.__viewUnmounting = unmounting;
  }

  @:noCompletion function __snap():{ vtree: Render }
    return { vtree: function () return __rendered.value };

  @:noCompletion @:final override function componentDidMount() {
    __link = __rendered.bind(function (_) setState(__snap()));//not my most glorious moment ... a better solution would probably be to poll in render and forceUpdate when becameInvalid
    if (__viewMounted != null) __viewMounted();
  }
    
  @:noCompletion @:final override function componentDidUpdate(_, _) 
    if (__viewUpdated != null) __viewUpdated();

  @:noCompletion @:final override function componentWillUnmount() {
    __link.dissolve();
    if (__viewUnmounting != null) __viewUnmounting();
  }  

  public function reactify() {
    if (__rewrapped == null)
      __rewrapped = cast react.React.createElement(Rewrapped, { target: this });
    return __rewrapped;
  }

  static function __init__() {
    #if react_devtools
    js.Object.defineProperty(untyped Renderer.prototype, 'state', {
      get: function () return js.Lib.nativeThis.__state,
      set: function (arg:Dynamic) if (arg != null) {
        
        js.Lib.nativeThis.__state = arg;
        
        if (!arg.__subverted) {//Muahaha!
          
          js.Object.defineProperty(arg, '__subverted', {
            enumerable: false,
            value: true
          });

          js.Object.defineProperty(arg, 'vtree', {
            enumerable: false,
            value: arg.vtree
          });

          var states:haxe.DynamicAccess<Void->Dynamic> = js.Lib.nativeThis.__stateMap;

          for (name in states.keys())
            js.Object.defineProperty(arg, name, {
              enumerable: true,
              get: states[name]
            });            
        }
      }
    });
    #end

    js.Object.defineProperty(untyped Renderer.prototype, 'props', {
      get: function () return js.Lib.nativeThis.__props,
      set: function (attr:Dynamic) if (attr != null) {
        js.Lib.nativeThis.__props = attr;
        #if react_devtools
        if (!attr.__cct) {
          
          var actual = Reflect.copy(attr);

          for (f in Reflect.fields(actual)) {
            var o:Observable.ObservableObject<Dynamic> = Reflect.field(actual, f);
            if (!Reflect.isFunction(o.poll)) 
              Reflect.setField(actual, f, Observable.const(o));
          }
          
          js.Object.defineProperty(attr, '__cct', {
            value: actual,
            enumerable: false,
          });

          for (field in Reflect.fields(actual))
            js.Object.defineProperty(attr, field, {
              get: function () return (Reflect.field(actual, field) : Observable<Dynamic>).value,
              enumerable: true,
            });
        }
        attr = attr.__cct;
        #end
        js.Lib.nativeThis.__initAttributes(attr);//TODO: unhardcode __initAtributes identifier
      }
    });
  }

  @:final @:noCompletion override function shouldComponentUpdate(_, next:{ vtree: Render }) 
    return state.vtree.get() != next.vtree.get();

  @:final @:noCompletion @:native('render') function reactRender()
    return this.state.vtree.get();

  static public function mount(target:js.html.Element, vdom:RenderResult)
    react.ReactDOM.render(vdom, target);

  static public function getNative(view:View):Null<js.html.Node>
    return react.ReactDOM.findDOMNode(view);

  static public inline function updateAll()
    Observable.updateAll();    

  @:noCompletion static public function createFragment(attr:{}, children)
    return (cast react.React.createElement).apply(null, [react.Fragment, attr].concat(children));
}

#if (haxe_ver >= 4)
private typedef Object = js.Object;
#else
@:native('Object') extern class Object {
  static function defineProperty(target:{}, name:String, descriptor:{}):Void;//Not very exact, but good enough
}
#end

private class Rewrapped extends react.ReactComponent.ReactComponentOfProps<{ target: Renderer }> {
  override function componentDidMount() 
    props.target.componentDidMount();

  override function componentDidUpdate(_, _) 
    props.target.componentDidUpdate(null, null);

  override function componentWillUnmount() 
    props.target.componentWillUnmount();

  var link:CallbackLink;

  override function render() {
    link.dissolve();
    var ret = @:privateAccess props.target.__rendered.measure();
    link = ret.becameInvalid.handle(function () forceUpdate());
    return ret.value;
  }

}