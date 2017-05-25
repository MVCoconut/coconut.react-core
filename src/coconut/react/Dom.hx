package coconut.react;

import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;
import react.React;

abstract Child(Dynamic) from ReactElement from String from Int from Float from Bool {

  @:from static function ofView(view:coconut.ui.BaseView):Child {
    return jsx('<Wrapper key=${view.id} view=${view} />');
  }

}

@:native('Object')
extern class ES6Object {
  static function assign(rest:haxe.extern.Rest<Dynamic>):Dynamic;
}

class Dom {
  static function props(attr, children:Array<Child>):Dynamic {
    var ret:Dynamic = ES6Object.assign(
      attr, 
      if (children != null) { children: children } else null
    );
    untyped __js__('delete')(ret.key);
    return ret;
  }

  static public function node(type:CreateElementType, attr:Dynamic, children:Array<Child>):ReactElement
    return {
      "$$typeof": untyped __js__("$$tre"), // defined in ReactComponent
      type: type,
      key: attr.key,
      props: props(attr, children),
    }

  static public inline function div(attr:Dynamic, ?children)
    return node('div', attr, children);

  static public inline function span(attr:Dynamic, ?children)
    return node('span', attr, children);
}