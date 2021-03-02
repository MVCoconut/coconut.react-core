import react.ReactComponent;
import tink.pure.*;
import tink.state.*;
import coconut.ui.*;
import coconut.data.*;
import coconut.react.Renderer.*;
import js.Browser.*;

using tink.CoreApi;

@:asserts
class Issue8 {
  static final msgs = [];
  static public function log(v)
    msgs.push(v);

  public function new() {}
  public function test() {
    var rendered = ReactTestRenderer.create(hxx('<Root />'));
    asserts.assert(msgs.length == 2);
    rendered.root.findByType(Div).props.onclick();
    updateAll();
    asserts.assert(msgs.length == 3);
    return asserts.done();
  }
}

class Root extends View {

  @:attr var value:Value<Vector<Obj>, Vector<Obj>> = new Value({
    raw: new State(([{foo: 'bar'}]:Vector<Obj>)),
    parse: Success,
  });

  function render() {
    Issue8.log('render Root ${value.raw.length}');
    return @hxx '
      <>
        <for ${i in 0...value.raw.length}>
          <Sub value=${value.sub(raw -> raw[i], (raw, nu) -> raw.with(i, nu), Success)} onClick=${value.raw = []}/>
        </for>
      </>
    ';
  }
}

typedef Obj = {
  final foo:String;
}

class Sub extends View {
  @:attr var value:Value<Obj, Obj>;
  @:attr var onClick:Void->Void;
  function render() {
    Issue8.log('render Sub ${value.raw}');
    return @hxx '<Div onclick=${onClick}>${value.raw == null ? null : value.raw.foo}</Div>';
  }
}

class Div extends ReactComponent<{ onclick:()->Void, children:String }, {}> {
  override function render() return props.children;
}

class Value<Raw, Result> implements Model {
  @:shared var raw:Raw;
  @:constant var parse:Raw->Outcome<Result, Error>;
  @:computed var parsed:Outcome<Result, Error> = parse(raw);
  public inline function sub<SubRaw, SubResult>(read:Raw->SubRaw, write:(Raw, SubRaw) -> Raw,
      parse:SubRaw->Outcome<SubResult, Error>):Value<SubRaw, SubResult> {
    return new Value({
      raw: observables.raw.transform({read: read, write: v -> write(raw, v)}),
      parse: parse,
    });
  }
}