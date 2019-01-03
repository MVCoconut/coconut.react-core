package;

import coconut.ui.View;
import react.*;
import react.ReactComponent;
import js.Browser.*;

class Playground {
  static function main() {
    // var d:Dynamic<String> = {
    //   'foo-bar': 5
    // };
    ReactDOM.render(
      coconut.Ui.hxx('<CoconutView />'),
      cast document.body.appendChild(document.createDivElement())
    );       

    ReactDOM.render(
      coconut.Ui.hxx('<ReactView />'),
      cast document.body.appendChild(document.createDivElement())
    );    
  }
  
}

class CoconutView extends View {
  
  @:state var a:Int = 0;
  @:tracked @:state var b:Int = 0;
  @:state var c:Int = 0;
  @:ref var counter:CoconutCounter;
  function inca() a++;
  function incb() b++;

  static function getDerivedStateFromAttributes()
    return { c: previous.c + 1 }; 
    
  function render() '
    <div>
      <h3>Coconut React</h3>
      <CoconutCounter ref=$counter count=${a} onclick=${inca} />
      <CoconutCounter count=${b} onclick=${incb} />
      <button onClick=${c++}>${c}</button>
    </div>
  ';

  function viewDidMount()
    trace(counter.current);
}

class CoconutCounter extends View {
  @:attribute var count:Int;
  @:attribute function onclick():Void;

  function render() '
    <button data-selected=${count > 2} onclick=${onclick}>${count}</button>
  ';

}

class ReactView extends ReactComponentOfState<{ ?a:Int, ?b: Int, ?c:Int }> {
  public function new(props) {
    super(props);
    this.state = { a: 0, b: 0, c: 0 };
  }

  function inca() setState({ a: state.a + 1 });
  function incb() setState({ b: state.b + 1 });

  override function render() return coconut.Ui.hxx('
    <div>
      <h3>Pure React</h3>
      <ReactCounter count=${state.a} onclick=${inca} />
      <ReactCounter count=${state.b} onclick=${incb} />
      <button onclick=${setState({ c: state.c + 1})}>${state.c}</button>
    </div>
  ');
}

class ReactCounter extends ReactComponentOfProps<{ var count:Int; function onclick():Void; }> {
  
  override function render() return coconut.Ui.hxx('
    <button onclick=${props.onclick()}>${props.count}</button>
  ');
}