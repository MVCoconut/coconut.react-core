package coconut.react;

abstract ReactChild(Dynamic) from ReactElement from String from Int from Float from Bool to ReactElement {

  @:from static function ofView(view:coconut.ui.BaseView):ReactChild 
    return view.reactify();

}