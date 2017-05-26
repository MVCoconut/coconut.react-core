package coconut.react;

@:build(coconut.react.macros.Setup.tags())
#if react
class ReactComponent<Props, State> extends react.ReactComponent.ReactComponentOfPropsAndState<Props, State> {}
#else
@:native('React.Component')
extern class ReactComponent<Props, State> {
  
  var props(default, null):Props;
  var state(default, null):State;
  
  function new(props:Props):Void;
  function setState(f:State->Props->State, ?cb:Void->Void):Void;
  function render():ReactChild;
}
#end