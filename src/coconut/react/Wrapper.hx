package coconut.react;

import react.ReactComponent;
import coconut.ui.BaseView;

class Wrapper extends ReactComponent { 
  
  function new(props: { view: BaseView }) {
    super(props);
    
    @:privateAccess {
      state = {view: props.view.__rendered.value};
      props.view.__rendered.bind(function(r) setState({view: r}));
    }
  }
  
  override function render():ReactElement 
     return this.state.view;
}