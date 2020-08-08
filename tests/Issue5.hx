@:keep class Issue5 extends coconut.react.View {
  @:attribute var state:Int;
  @:attribute var props:String;
  function render()
    return 'Yo, $state $props';
}