package coconut.react;

import react.ReactComponent;

abstract ViewFragment<T>(ReactElement) to ReactFragment to ReactSingleFragment {
  public function materialize():T {
    return untyped __js__('new ({0})({1})', this.type, this.props);
  }
}