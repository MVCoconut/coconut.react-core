package;

import coconut.ui.View;
import coconut.react.*;
import coconut.Ui.hxx;
import js.Browser.*;

class Playground {
  static function main() {
    // new CoconutView({}).mountInto(document.getElementById('app'));
  }
  
}

class CoconutView extends View {
  
  @:state var inner:Int = 0;
  @:state var outer:Int = 42;
  var renderCount = 0;

  function render() '
    <div>
      <span>Hello Coconut! {id} {renderCount++}</span>
      <ReactTextView value="Hello React! $outer" />
      <TextView key={this} value={Std.string(inner)} />
    </div>
  ';
  
  override function init() {
    var timer = new haxe.Timer(500);
    timer.run = function() {
      inner++;
      if (inner % 4 == 0)
        outer--;    
    }
  }
    
}

class TextView extends View {
  @:attribute var value:String;
  function render() '
    <div>
      <span>
        TextView #{id} - {value}
        <if {value == "foo"}>
          <div />
        <else>
          <div />
        </if>
      </span>
    </div>
  ';
}

class ReactTextView extends ReactComponent<{ value: String }, {}> {
  override function render() {
    return coconut.react.React.createElement(
      'div', {}, [props.value]
    );
  }
}