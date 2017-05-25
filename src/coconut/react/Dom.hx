package coconut.react;

@:native('Object')
extern private class ES6Object {
  static function assign(rest:haxe.extern.Rest<Dynamic>):Dynamic;
}

class Dom {
  static function props(attr, children:Array<ReactChild>):Dynamic {
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