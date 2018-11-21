package coconut.react;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import tink.domspec.Macro.tags;
using tink.MacroApi;
#else

import js.html.*;
import tink.domspec.EventFrom;
import tink.domspec.ClassName;
import tink.core.Callback;

typedef DomElement<E:js.html.Element> = react.ReactComponent.ReactSingleFragment;

typedef ReactEvents<Target:Element> = {
  @:hxx(onwheel) @:optional var onWheel:Callback<EventFrom<Target, WheelEvent>>;
  
  @:hxx(oncopy) @:optional var onCopy:Callback<EventFrom<Target, ClipboardEvent>>;
  @:hxx(oncut) @:optional var onCut:Callback<EventFrom<Target, ClipboardEvent>>;
  @:hxx(onpaste) @:optional var onPaste:Callback<EventFrom<Target, ClipboardEvent>>;
  
  @:hxx(onabort) @:optional var onAbort:Callback<EventFrom<Target, Event>>;
  @:hxx(onblur) @:optional var onBlur:Callback<EventFrom<Target, Event>>;
  @:hxx(onfocus) @:optional var onFocus:Callback<EventFrom<Target, Event>>;
  
  @:hxx(oncanplay) @:optional var onCanPlay:Callback<EventFrom<Target, Event>>;
  @:hxx(oncanplaythrough) @:optional var onCanPlayThrough:Callback<EventFrom<Target, Event>>;
  
  //TODO: Try warning about onChange being treated as onInput
  @:hxx(onchange) @:optional var onChange:Callback<EventFrom<Target, Event>>;
  
  @:hxx(onclick) @:optional var onClick:Callback<EventFrom<Target, MouseEvent>>;
  @:hxx(oncontextmenu) @:optional var onContextMenu:Callback<EventFrom<Target, MouseEvent>>;
  @:hxx(ondblclick) @:optional var onDoubleClick:Callback<EventFrom<Target, MouseEvent>>;
  
  @:hxx(ondrag) @:optional var onDrag:Callback<EventFrom<Target, DragEvent>>;
  @:hxx(ondragend) @:optional var onDragEnd:Callback<EventFrom<Target, DragEvent>>;
  @:hxx(ondragenter) @:optional var onDragEnter:Callback<EventFrom<Target, DragEvent>>;
  @:hxx(ondragleave) @:optional var onDragLeave:Callback<EventFrom<Target, DragEvent>>;
  @:hxx(ondragover) @:optional var onDragOver:Callback<EventFrom<Target, DragEvent>>;
  @:hxx(ondragstart) @:optional var onDragStart:Callback<EventFrom<Target, DragEvent>>;
  @:hxx(ondrop) @:optional var onDrop:Callback<EventFrom<Target, DragEvent>>;
  
  @:hxx(ondurationchange) @:optional var onDurationChange:Callback<EventFrom<Target, Event>>;
  @:hxx(onemptied) @:optional var onEmptied:Callback<EventFrom<Target, Event>>;
  @:hxx(onended) @:optional var onEnded:Callback<EventFrom<Target, Event>>;
  @:hxx(oninput) @:optional var onInput:Callback<EventFrom<Target, Event>>;
  @:hxx(oninvalid) @:optional var onInvalid:Callback<EventFrom<Target, Event>>;
  
  @:hxx(onkeydown) @:optional var onKeyDown:Callback<EventFrom<Target, KeyboardEvent>>;
  @:hxx(onkeypress) @:optional var onKeyPress:Callback<EventFrom<Target, KeyboardEvent>>;
  @:hxx(onkeyup) @:optional var onKeyUp:Callback<EventFrom<Target, KeyboardEvent>>;
  
  @:hxx(onload) @:optional var onLoad:Callback<EventFrom<Target, Event>>;
  @:hxx(onloadeddata) @:optional var onLoadedData:Callback<EventFrom<Target, Event>>;
  @:hxx(onloadedmetadata) @:optional var onLoadedMetadata:Callback<EventFrom<Target, Event>>;
  @:hxx(onloadstart) @:optional var onLoadStart:Callback<EventFrom<Target, Event>>;
  
  @:hxx(onmousedown) @:optional var onMouseDown:Callback<EventFrom<Target, MouseEvent>>;
  @:hxx(onmouseenter) @:optional var onMouseEnter:Callback<EventFrom<Target, MouseEvent>>;
  @:hxx(onmouseleave) @:optional var onMouseLeave:Callback<EventFrom<Target, MouseEvent>>;
  @:hxx(onmousemove) @:optional var onMouseMove:Callback<EventFrom<Target, MouseEvent>>;
  @:hxx(onmouseout) @:optional var onMouseOut:Callback<EventFrom<Target, MouseEvent>>;
  @:hxx(onmouseover) @:optional var onMouseOver:Callback<EventFrom<Target, MouseEvent>>;
  @:hxx(onmouseup) @:optional var onMouseUp:Callback<EventFrom<Target, MouseEvent>>;
  
  @:hxx(onpause) @:optional var onPause:Callback<EventFrom<Target, Event>>;
  @:hxx(onplay) @:optional var onPlay:Callback<EventFrom<Target, Event>>;
  @:hxx(onplaying) @:optional var onPlaying:Callback<EventFrom<Target, Event>>;
  @:hxx(onprogress) @:optional var onProgress:Callback<EventFrom<Target, Event>>;
  @:hxx(onratechange) @:optional var onRateChange:Callback<EventFrom<Target, Event>>;
  @:hxx(onreset) @:optional var onReset:Callback<EventFrom<Target, Event>>;
  @:hxx(onresize) @:optional var onResize:Callback<EventFrom<Target, Event>>;
  @:hxx(onscroll) @:optional var onScroll:Callback<EventFrom<Target, Event>>;
  @:hxx(onseeked) @:optional var onSeeked:Callback<EventFrom<Target, Event>>;
  @:hxx(onseeking) @:optional var onSeeking:Callback<EventFrom<Target, Event>>;
  @:hxx(onselect) @:optional var onSelect:Callback<EventFrom<Target, Event>>;
  @:hxx(onshow) @:optional var onShow:Callback<EventFrom<Target, Event>>;
  @:hxx(onstalled) @:optional var onStalled:Callback<EventFrom<Target, Event>>;
  @:hxx(onsubmit) @:optional var onSubmit:Callback<EventFrom<Target, Event>>;
  @:hxx(onsuspend) @:optional var onSuspend:Callback<EventFrom<Target, Event>>;
  @:hxx(ontimeupdate) @:optional var onTimeUpdate:Callback<EventFrom<Target, Event>>;
  @:hxx(onvolumechange) @:optional var onVolumeChange:Callback<EventFrom<Target, Event>>;
  @:hxx(onwaiting) @:optional var onWaiting:Callback<EventFrom<Target, Event>>;
  
  @:hxx(onpointercancel) @:optional var onPointerCancel:Callback<EventFrom<Target, PointerEvent>>;
  @:hxx(onpointerdown) @:optional var onPointerDown:Callback<EventFrom<Target, PointerEvent>>;
  @:hxx(onpointerup) @:optional var onPointerUp:Callback<EventFrom<Target, PointerEvent>>;
  @:hxx(onpointermove) @:optional var onPointerMove:Callback<EventFrom<Target, PointerEvent>>;
  @:hxx(onpointerout) @:optional var onPointerOut:Callback<EventFrom<Target, PointerEvent>>;
  @:hxx(onpointerover) @:optional var onPointerOver:Callback<EventFrom<Target, PointerEvent>>;
  @:hxx(onpointerenter) @:optional var onPointerEnter:Callback<EventFrom<Target, PointerEvent>>;
  @:hxx(onpointerleave) @:optional var onPointerLeave:Callback<EventFrom<Target, PointerEvent>>;
  
  @:hxx(ongotpointercapture) @:optional var onGotPointerCapture:Callback<EventFrom<Target, Event>>;
  @:hxx(onlostpointercapture) @:optional var onLostPointerCapture:Callback<EventFrom<Target, Event>>;
  // apparently react doesn't have these two ?
  // @:optional var onFullscreenChange:Callback<EventFrom<Target, Event>>;
  // @:optional var onFullscreenError:Callback<EventFrom<Target, Event>>;
  @:hxx(onpointerlockchange) @:optional var onPointerLockChange:Callback<EventFrom<Target, Event>>;
  @:hxx(onpointerlockerror) @:optional var onPointerLockError:Callback<EventFrom<Target, Event>>;
  
  @:hxx(onerror) @:optional var onError:Callback<EventFrom<Target, ErrorEvent>>;
  
  @:hxx(ontouchstart) @:optional var onTouchStart:Callback<EventFrom<Target, TouchEvent>>;
  @:hxx(ontouchend) @:optional var onTouchEnd:Callback<EventFrom<Target, TouchEvent>>;
  @:hxx(ontouchmove) @:optional var onTouchMove:Callback<EventFrom<Target, TouchEvent>>;
  @:hxx(ontouchcancel) @:optional var onTouchCancel:Callback<EventFrom<Target, TouchEvent>>;
}

@:coreType abstract CustomAttr from String from Int from Float {
  @:from static function ofBool(b:Bool):CustomAttr
    return if (b != true) js.Lib.undefined else ''; 
}

@:build(coconut.react.Html.build())
#end
class Html {
  #if macro
  static var NAMELESS = '';
  static var reactAttributes = {
    var ret = new Map();
    for (name in 'accept acceptCharset accessKey action allowFullScreen alt async autoComplete autoFocus autoPlay capture cellPadding cellSpacing challenge charSet checked cite classID className colSpan cols content contentEditable contextMenu controls controlsList coords crossOrigin data dateTime default defer dir disabled download draggable encType form formAction formEncType formMethod formNoValidate formTarget frameBorder headers height hidden high href hrefLang htmlFor httpEquiv icon id inputMode integrity is keyParams keyType kind label lang list loop low manifest marginHeight marginWidth max maxLength media mediaGroup method min minLength multiple muted name noValidate nonce open optimum pattern placeholder poster preload profile radioGroup readOnly rel required reversed role rowSpan rows sandbox scope scoped scrolling seamless selected shape size sizes span spellCheck src srcDoc srcLang srcSet start step style summary tabIndex target title type useMap value width wmode wrap accentHeight accumulate additive alignmentBaseline allowReorder alphabetic amplitude arabicForm ascent attributeName attributeType autoReverse azimuth baseFrequency baseProfile baselineShift bbox begin bias by calcMode capHeight clip clipPath clipPathUnits clipRule colorInterpolation colorInterpolationFilters colorProfile colorRendering contentScriptType contentStyleType cursor cx cy d decelerate descent diffuseConstant direction display divisor dominantBaseline dur dx dy edgeMode elevation enableBackground end exponent externalResourcesRequired fill fillOpacity fillRule filter filterRes filterUnits floodColor floodOpacity focusable fontFamily fontSize fontSizeAdjust fontStretch fontStyle fontVariant fontWeight format from fx fy g1 g2 glyphName glyphOrientationHorizontal glyphOrientationVertical glyphRef gradientTransform gradientUnits hanging horizAdvX horizOriginX ideographic imageRendering in in2 intercept k k1 k2 k3 k4 kernelMatrix kernelUnitLength kerning keyPoints keySplines keyTimes lengthAdjust letterSpacing lightingColor limitingConeAngle local markerEnd markerHeight markerMid markerStart markerUnits markerWidth mask maskContentUnits maskUnits mathematical mode numOctaves offset opacity operator order orient orientation origin overflow overlinePosition overlineThickness paintOrder panose1 pathLength patternContentUnits patternTransform patternUnits pointerEvents points pointsAtX pointsAtY pointsAtZ preserveAlpha preserveAspectRatio primitiveUnits r radius refX refY renderingIntent repeatCount repeatDur requiredExtensions requiredFeatures restart result rotate rx ry scale seed shapeRendering slope spacing specularConstant specularExponent speed spreadMethod startOffset stdDeviation stemh stemv stitchTiles stopColor stopOpacity strikethroughPosition strikethroughThickness string stroke strokeDasharray strokeDashoffset strokeLinecap strokeLinejoin strokeMiterlimit strokeOpacity strokeWidth surfaceScale systemLanguage tableValues targetX targetY textAnchor textDecoration textLength textRendering to transform u1 u2 underlinePosition underlineThickness unicode unicodeBidi unicodeRange unitsPerEm vAlphabetic vHanging vIdeographic vMathematical values vectorEffect version vertAdvY vertOriginX vertOriginY viewBox viewTarget visibility widths wordSpacing writingMode x x1 x2 xChannelSelector xHeight xlinkActuate xlinkArcrole xlinkHref xlinkRole xlinkShow xlinkTitle xlinkType xmlns xmlnsXlink xmlBase xmlLang xmlSpace y y1 y2 yChannelSelector z zoomAndPan'.split(' '))
      switch name.toLowerCase() {
        case _ == name => true: 
        case lower: ret[lower] = name;
      }
    ret;
  }

  static function build() {
    var ret = Context.getBuildFields();
    for (name in tags.keys()) {
      
      var tag = tags[name];
      var et = tag.dom.toComplex();

      #if xDOM
      et = macro : xdom.Wrapped<$et>;
      #end
      ret.push({
        name: name,
        pos: tag.pos,
        access: [AStatic, APublic, AInline],
        meta: [{ name: ':${tag.kind}Tag', params: [], pos: tag.pos }],
        kind: FFun({
          var fields = (macro class { 
            @:optional var key(default, never):coconut.react.Key; 
            @:optional var ref(default, never):$et->Void;
            @:hxxCustomAttributes(~/^(aria-(selected|label))|(data-.*)$/)
            @:optional var $NAMELESS(default, never):CustomAttr;
          }).fields;

          for (f in tag.attr.toType().sure().getFields().sure()) {
            var reactName = switch reactAttributes[f.name] {
              case null: null;
              case _ == f.name => true: null;
              case v: v;
            }

            fields.push({
              name: if (reactName == null) f.name else reactName,
              pos: f.pos,
              meta: {
                var meta = f.meta.get();
                if (reactName != null)
                  meta.push({
                    name: ':hxx',
                    pos: f.pos,
                    params: [macro @:pos(f.pos) $i{f.name}],
                  });
                meta;
              },
              kind: FProp('default', 'never', f.type.toComplex()),
            });
          }
          
          var args = [{
            name: 'attributes',
            type: TExtend(['ReactEvents'.asTypePath([TPType(et)])], fields),
            opt: false
          }];
          var callArgs = [macro $v{name}, macro attributes];
          if (tag.kind != VOID) {
            args.push({
              name: 'children',
              type: macro : coconut.ui.Children,
              opt: true
            });
            callArgs.push(macro children);
          }
          {
            args: args,
            expr: macro return h($a{callArgs}),
            ret: macro : DomElement<$et>,
          }
        })
      });
    }
    return ret;
  }
  #else
  
  static public function raw(attr:RawAttr)
    return h(switch attr.tag { case null: 'span'; case v: v; }, { className: attr.className, dangerouslySetInnerHTML: { __html: attr.content } });

  static function h(tag:String, attr:Dynamic, ?children:Dynamic):react.ReactComponent.ReactSingleFragment
    return 
      if (children == null) cast react.React.createElement(tag, attr);
      else (cast react.React.createElement).apply(null, [tag, attr].concat(children));
  #end
}

#if !macro
typedef RawAttr = {
  var content:String;
  @:optional var tag:String;
  @:optional var className:ClassName;
}
#end