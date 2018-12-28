package coconut.ui;

import react.*;

abstract Ref<T>(ReactRef<T>) {
  
  public var current(get, never):T;
    inline function get_current():T 
      return this.current;

  public inline function new()
    this = React.createRef();
}

abstract RefSetter<T>(T->Void) from T->Void {
  @:from static inline function ofRef<T>(r:Ref<T>):RefSetter<T>
    return cast r;
}