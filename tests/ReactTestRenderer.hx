import coconut.react.RenderResult;

@:jsRequire('react-test-renderer')
extern class ReactTestRenderer {
  final root:ReactTestRoot;
  static function create(r:RenderResult):ReactTestRenderer;
}

extern class ReactTestRoot {
  function findByProps(props:{}):Dynamic;
}