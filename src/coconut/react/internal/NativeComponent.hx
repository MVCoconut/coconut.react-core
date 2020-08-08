package coconut.react.internal;

#if (!react_global)
@:jsRequire("react", "Component") // TODO: this duplication with haxe-react should be minimized
#end
@:native('React.Component')
extern class NativeComponent<State, Props, Context> {
  @:noCompletion @:native('props') var __react_props(default, null):Props;
  @:noCompletion @:native('state') var __react_state(default, null):State;
  @:noCompletion @:native('context') var __react_context(default, null):Context;
  @:noCompletion @:native('setState') function __react_setState(state:State):Void;
  function new():Void;
  @:noCompletion @:native('forceUpdate') function __react_forceUpdate():Void;
}