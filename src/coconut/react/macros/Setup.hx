package coconut.react.macros;

#if macro
import haxe.macro.Context;
using tink.MacroApi;
class Setup {
  
  static var defined = false;
  static function tags() {
    return null;
  }
  static function all() {
    
    #if coconut_ui
    if (!defined) {    
      defined = true;
      coconut.ui.macros.HXX.options = {
        child: macro : coconut.react.ReactChild,
        instantiate: function (cl) {
          
          return 
            if (Context.unify(cl.type, Context.getType('coconut.react.ReactComponent'))) {
              // trace(cl.children);
              // cl.attr.log();
              var props = tink.hxx.Generator.applySpreads(cl.attr, macro tink.hxx.Merge.objects, function (f) {
                switch cl.children {
                  case Some(v):
                    f.push({ field: 'children', expr: v });   
                  default:
                }
              });
              Some(macro @:pos(cl.name.pos) coconut.react.React.createComponent(
                $i{cl.name.value}, $props
              ));
              //cl.name.pos.error('react view');
            }
            else None;          
        }
      };
    }
    #end
  }
}
#end