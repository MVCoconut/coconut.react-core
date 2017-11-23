package coconut.react;

typedef Props = {
    ?ref:Any->Void,
    ?children:Children,
    ?key:Dynamic,
}

@:coreType abstract Children from Array<ReactChild> from coconut.react.ReactChild {}