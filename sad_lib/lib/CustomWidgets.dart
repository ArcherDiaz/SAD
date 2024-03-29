import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TextView extends StatelessWidget {
  final bool isSelectable;
  final EdgeInsets padding;
  final String text;
  final TextAlign align;
  final List<TextView> textSpan;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final String fontFamily;
  final double letterSpacing;
  final double lineSpacing;
  final TextOverflow textOverflow;
  final int maxLines;
  final List<Shadow> shadows;

  TextView({Key key,
    this.isSelectable = false,
    this.padding = EdgeInsets.zero,
    @required this.text,
    this.align = TextAlign.left,
    this.size = 17.5,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.fontStyle = FontStyle.normal,
    this.fontFamily,
    this.letterSpacing = 0.75,
    this.lineSpacing,
    this.textOverflow = TextOverflow.clip,
    this.maxLines,
    this.shadows,
  }) : this.textSpan = null, super(key: key);

  TextView.rich({Key key,
    this.isSelectable = false,
    this.align = TextAlign.left,
    this.padding = EdgeInsets.zero,
    this.lineSpacing,
    @required this.textSpan,
  }) : this.text = null,
        this.size = null,
        this.color = null,
        this.fontWeight = null,
        this.fontStyle = null,
        this.fontFamily = null,
        this.letterSpacing = null,
        this.textOverflow = null,
        this.maxLines = null,
        this.shadows = null, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: isSelectable == false
          ? _normal()
          : _selectable(),
    );
  }

  Widget _normal(){
    if(text != null){
      return Text(text,
        overflow: textOverflow,
        maxLines: maxLines,
        textAlign: align,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          letterSpacing: letterSpacing,
          height: lineSpacing,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          shadows: shadows,
        ),
      );
    }else{
      return Text.rich(
        TextSpan(children: <InlineSpan>[
            for(var textView in textSpan)
              TextSpan(text: textView.text,
                style: TextStyle(
                  fontSize: textView.size,
                  letterSpacing: textView.letterSpacing,
                  height: textView.lineSpacing,
                  fontWeight: textView.fontWeight,
                  fontStyle: textView.fontStyle,
                  fontFamily: fontFamily,
                  color: textView.color,
                  shadows: shadows,
                ),
              ),
        ],),
        overflow: textOverflow,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          letterSpacing: letterSpacing,
          height: lineSpacing,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          shadows: shadows,
        ),
        maxLines: maxLines,
        textAlign: align,
      );
    }
  }

  Widget _selectable(){
    if(text != null){
      return SelectableText(text,
        showCursor: false,
        onTap: null,
        autofocus: false,
        maxLines: maxLines,
        textAlign: align,
        toolbarOptions: ToolbarOptions(cut: true, selectAll: true, paste: true, copy: true,),
        style: TextStyle(
          fontSize: size,
          letterSpacing: letterSpacing,
          height: lineSpacing,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          shadows: shadows,
        ),
      );
    }else{
      return SelectableText.rich(
        TextSpan(children: <InlineSpan>[
          for(var textView in textSpan)
            TextSpan(text: textView.text,
              style: TextStyle(
                fontSize: textView.size,
                letterSpacing: textView.letterSpacing,
                height: lineSpacing,
                fontFamily: fontFamily,
                fontWeight: textView.fontWeight,
                fontStyle: textView.fontStyle,
                color: textView.color,
                shadows: shadows,
              ),
            ),
        ],),
        showCursor: false,
        onTap: null,
        autofocus: false,
        maxLines: maxLines,
        textAlign: align,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          letterSpacing: letterSpacing,
          height: lineSpacing,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          shadows: shadows,
        ),
        toolbarOptions: ToolbarOptions(cut: true, selectAll: true, paste: true, copy: true,),
      );
    }
  }

}



//------------------------------------------------------------------------------

enum WidthType {fit, stretch}
///fit = make button be normal size to fit content
///stretch = make button be stretch to fit screen width
class ButtonView extends StatefulWidget {

  final Alignment alignment;
  final EdgeInsets margin;
  final double width;
  final double height;
  final WidthType widthType;
  final Axis direction;
  final void Function() onPressed;
  final void Function() onLongPressed;
  final Color color;
  final Gradient gradient;
  final Color splashColor;
  final Color highlightColor;
  final double borderRadius;
  final BoxShape shape;
  final Border border;
  final EdgeInsets padding;
  final List<BoxShadow> boxShadow;
  final Widget child;
  final List<Widget> children;

  final ContainerChanges onHover;
  final Widget Function(bool isHovering) builder;
  final Duration duration;
  final Curve curve;

  ButtonView({Key key,
    this.alignment,
    this.width,
    this.height,
    this.widthType = WidthType.fit,
    this.direction = Axis.horizontal,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    @required this.onPressed,
    this.onLongPressed,
    this.color = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.gradient,
    this.boxShadow,
    this.border = const Border(),
    this.borderRadius = 7.5,
    this.shape = BoxShape.rectangle,
    this.child,
    this.children,
  }) : duration = null, curve = null, onHover = null, builder = null, super(key: key);

  ButtonView.hover({Key key,
    this.alignment,
    this.width,
    this.height,
    this.widthType = WidthType.fit,
    this.direction = Axis.horizontal,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    @required this.onPressed,
    this.onLongPressed,
    this.color = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.gradient,
    this.boxShadow,
    this.border = const Border(),
    this.borderRadius = 7.5,
    this.shape = BoxShape.rectangle,

    this.child,
    this.children,
    this.builder,

    @required this.onHover,
    this.duration = const Duration(milliseconds: 25,),
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _ButtonViewState createState() => _ButtonViewState();

}

class _ButtonViewState extends State<ButtonView> {

  ContainerChanges _changes;
  bool _isHovering;

  @override
  void initState() {
    _changes = ContainerChanges.nullValue();
    _isHovering = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.alignment == null){
      return _margin();
    }else {
      return Align(
        alignment: widget.alignment,
        child: _margin(),
      );
    }
  }

  Widget _margin(){
    if(widget.curve == null || widget.onHover == null){
      return Padding(
        padding: widget.margin,
        child: _inkWell(),
      );
    }else{
      return AnimatedPadding(
        duration: widget.duration,
        curve: widget.curve,
        padding: _changes.margin == null ? widget.margin : _changes.margin,
        child: _inkWell(),
      );
    }
  }

  Widget _inkWell(){
    return InkWell(
      onTap: widget.onPressed,
      onLongPress: widget.onLongPressed,
      onHover: (flag){
        if(flag == true){ ///if mouse is currently over widget
          setState(() {
            if(widget.onHover != null) {
              _changes = widget.onHover;
            }
            _isHovering = true;
          });
        }else{ ///if mouse is NOT over widget
          setState(() {
            _changes = ContainerChanges.nullValue();
            _isHovering = false;
          });
        }
      },
      borderRadius: BorderRadius.circular(widget.shape == BoxShape.circle
          ? 360.0
          : widget.borderRadius == null ? 0.0 : widget.borderRadius,
      ),
      hoverColor: Colors.transparent,
      highlightColor: widget.highlightColor,
      splashColor: widget.splashColor,
      child: _container(),
    );
  }


  Widget _container(){
    if(widget.curve == null || widget.onHover == null){
      return Container(
        width: widget.width == null
            ? widget.widthType == WidthType.fit
                ? null
                : double.infinity
            : widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: _decoration(),
        child: widget.builder == null
            ? widget.children == null
              ? widget.child
              : _contentView()
            : widget.builder(_isHovering),
      );
    }else{
      return AnimatedContainer(
        duration: widget.duration,
        curve: widget.curve,
        width: widget.width == null
            ? widget.widthType == WidthType.fit
                ? null
                : double.infinity
            : widget.width,
        height: widget.height,
        padding: _changes.padding == null ? widget.padding : _changes.padding,
        decoration: _changes.decoration == null ? _decoration() : _changes.decoration,
        child: widget.builder == null
            ? widget.children == null
              ? widget.child
              : _contentView()
            : widget.builder(_isHovering),
      );
    }
  }
  BoxDecoration _decoration(){
    return BoxDecoration(
      color: widget.color,
      borderRadius: (widget.shape != BoxShape.rectangle || widget.borderRadius == null || widget.borderRadius == 0.0 || !widget.border.isUniform)
          ? null
          : BorderRadius.circular(widget.borderRadius,),
      gradient: widget.gradient,
      border: widget.border,
      shape: widget.shape,
      boxShadow: widget.boxShadow == null ? [] : widget.boxShadow,
    );
  }


  Widget _contentView(){
    if(widget.direction == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: (widget.widthType == WidthType.stretch) ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.children,
      );
    }else{
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: (widget.widthType == WidthType.stretch) ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.children,
      );
    }
  }

}



//------------------------------------------------------------------------------

enum IndicatorType {circular, linear}
class CustomLoader extends StatelessWidget {

  final Color color1;
  final Color color2;
  final IndicatorType indicator;
  final Alignment alignment;

  CustomLoader({Key key,
    @required this.color1,
    @required this.color2,
    this.alignment = Alignment.center,
    this.indicator = IndicatorType.circular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: indicator == IndicatorType.linear ? Alignment.topCenter : Alignment.center,
      child: TweenAnimationBuilder<Color>(
        tween: ColorTween(begin: color1, end: color2),
        duration: Duration(seconds: 5),
        builder: (context, value, child){
          if(indicator == IndicatorType.circular) {
            return CircularProgressIndicator(
              backgroundColor: value.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation(value),
            );
          }else{
            return LinearProgressIndicator(
              backgroundColor: value.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation(value.withOpacity(0.75)),
            );
          }
        },
      ),
    );
  }

}



//------------------------------------------------------------------------------

enum ImageType {asset, network, custom}

class ImageView extends StatefulWidget {

  final Color colorFilter;
  final Color imageColor;
  final BlendMode imageColorBlendMode;
  final double radius;
  final double aspectRatio; ///if the [height] parameter is specified, then value is overridden
  final EdgeInsets margin;
  final BoxFit fit;
  final double width;
  final double height; ///the [height] parameter overrides the [aspectRatio] parameter

  final String imageKey;
  final ImageType imageType;

  final Future<Uint8List> imageFuture;

  final Widget errorView;
  final Widget customLoader;
  final Widget child;
  final List<Widget> children; ///the [children] parameter will override the [child] parameter if specified

  final void Function(Uint8List) getImage;
  ///this function will return the data of the image being displayed. Will return a null if the image is still loading

  ImageView.custom({Key key,
    @required this.imageFuture,
    this.getImage,

    this.colorFilter = Colors.transparent,
    this.imageColor,
    this.imageColorBlendMode,
    this.margin = EdgeInsets.zero,
    this.radius = 0.0,
    this.aspectRatio,
    this.width,
    this.height,
    this.fit = BoxFit.cover,

    this.customLoader,
    this.errorView,

    this.child,
    this.children,
  }) : this.imageType = ImageType.custom,
        this.imageKey = null,
        super(key: key);

  ImageView.network({Key key,
    @required this.imageKey,
    this.getImage,

    this.colorFilter = Colors.transparent,
    this.imageColor,
    this.imageColorBlendMode,
    this.margin = EdgeInsets.zero,
    this.radius = 0.0,
    this.aspectRatio,
    this.width,
    this.height,
    this.fit = BoxFit.cover,

    this.customLoader,
    this.errorView,

    this.child,
    this.children,
  }) : this.imageFuture = null, this.imageType = ImageType.network, super(key: key);

  ImageView.asset({Key key,
    @required this.imageKey,
    this.getImage,

    this.colorFilter = Colors.transparent,
    this.imageColor,
    this.imageColorBlendMode,
    this.margin = EdgeInsets.zero,
    this.radius = 0.0,
    this.aspectRatio,
    this.width,
    this.height,
    this.fit = BoxFit.cover,

    this.customLoader,
    this.errorView,

    this.child,
    this.children,
  }) : this.imageFuture = null, this.imageType = ImageType.asset, super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: SizedBox(
          width: widget.width,
          height: widget.height == null
              ? (widget.width == null || widget.aspectRatio == null)
                  ? null
                  : widget.width / widget.aspectRatio
              : widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.imageType == ImageType.asset
                  ? _assetImage()
                  : widget.imageType == ImageType.network
                    ? _networkImage()
                    : _customImage(),
              Container(
                color: widget.colorFilter,
              ),

              if(widget.children != null)
                for(int i = 0; i < widget.children.length; i++)
                  widget.children[i],

              if(widget.child != null)
                widget.child
            ],
          ),
        ),
      ),
    );
  }

  Widget _assetImage(){
    return Image.asset(widget.imageKey,
      width: widget.width,
      height: widget.height == null
          ? (widget.width == null || widget.aspectRatio == null)
              ? null
              : widget.width / widget.aspectRatio
          : widget.height,
      fit: widget.fit,
      color: widget.imageColor,
      colorBlendMode: widget.imageColorBlendMode,
      errorBuilder: (context, object, stackTrace) {
        if (widget.errorView == null) {
          return TextView(text: "Unable to load image..",
            align: TextAlign.center,
            size: 15.0,
          );
        } else {
          print("stacktrace: ${stackTrace.toString()}");
          return widget.errorView;
        }
      },
    );
  }

  Widget _networkImage(){
    return Image.network(widget.imageKey,
      width: widget.width,
      height: widget.height == null
          ? (widget.width == null || widget.aspectRatio == null)
              ? null
              : widget.width / widget.aspectRatio
          : widget.height,
      fit: widget.fit,
      color: widget.imageColor,
      colorBlendMode: widget.imageColorBlendMode,
      loadingBuilder: (context, widget, chunk) {
        if(chunk == null) {
          return widget;
        }else{
          if(super.widget.customLoader == null) {
            return Container();
          }else{
            return super.widget.customLoader;
          }
        }
      },
      errorBuilder: (context, object, stackTrace) {
        if (widget.errorView == null) {
          return TextView(text: "Unable to load image..",
            align: TextAlign.center,
            size: 15.0,
          );
        } else {
          print("stacktrace: ${stackTrace.toString()}");
          return widget.errorView;
        }
      },
    );
  }

  Widget _customImage(){
    return FutureBuilder(
      future: widget.imageFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData && snapshot.data != null){
            return Image.memory(snapshot.data,
              width: widget.width,
              height: widget.height == null
                  ? (widget.width == null || widget.aspectRatio == null)
                    ? null
                    : widget.width / widget.aspectRatio
                  : widget.height,
              fit: widget.fit,
              color: widget.imageColor,
              colorBlendMode: widget.imageColorBlendMode,
            );
          }else{
            if(widget.errorView == null){
              return TextView(text: "Unable to load image..",
                align: TextAlign.center,
                size: 15.0,
              );
            }else{
              return widget.errorView;
            }
          }
        }else{
          if(super.widget.customLoader == null) {
            return Container();
          }else{
            return super.widget.customLoader;
          }
        }
      },
    );
  }

}



//------------------------------------------------------------------------------

class CustomCarousel extends StatefulWidget {
  final bool showPageIndicator;
  final Color indicatorColor;
  final int secondsToSwap;
  final double aspectRatio;
  final double viewportFraction;

  final List<Widget> children;

  final int childrenLength;
  final Widget Function(BuildContext context, int index, bool isCurrentSlide, void Function() previous, void Function() next) childrenBuilder;

  CustomCarousel({Key key,
    this.showPageIndicator = true,
    this.indicatorColor = Colors.white,
    this.secondsToSwap = 5,
    this.aspectRatio = 1.0,
    this.viewportFraction = 1.0,
    @required this.children,
  }) : this.childrenLength = children.length,  this.childrenBuilder = null, super(key: key);

  CustomCarousel.builder({Key key,
    this.showPageIndicator = true,
    this.indicatorColor = Colors.white,
    this.secondsToSwap = 5,
    this.aspectRatio = 1.0,
    this.viewportFraction = 1.0,
    @required this.childrenLength,
    @required this.childrenBuilder,
  }) : this.children = null, super(key: key);

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {

  PageController _pageController;
  double _counter;
  int _index;

  @override
  void initState() {
    _index = 0;
    _counter = 0;
    _pageController = PageController(initialPage: _index, viewportFraction: widget.viewportFraction,);
    super.initState();
    _timer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.aspectRatio == null){
      return _stack();
    }else{
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _stack(),
      );
    }
  }

  Widget _stack(){
    if(widget.showPageIndicator == true){
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            children: widget.children == null ? [
              for(int i = 0; i < widget.childrenLength; i++)
                widget.childrenBuilder(context, i, i == _index, previous, next,),
            ] : widget.children,
            onPageChanged: (i){
              setState(() {
                _index = i;
                _counter = 0.0;
              });
            },
          ),

          Padding(
            padding: EdgeInsets.all(10.0,),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int i = 0; i < widget.childrenLength; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5,),
                    child: Icon(Icons.brightness_1_sharp,
                      size: 5.0,
                      color: i == _index ? widget.indicatorColor : Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }else{
      return PageView(
        controller: _pageController,
        pageSnapping: true,
        scrollDirection: Axis.horizontal,
        children: widget.children == null ? [
          for(int i = 0; i < widget.childrenLength; i++)
            widget.childrenBuilder(context, i, i == _index, previous, next,),
        ] : widget.children,
        onPageChanged: (i){
          setState(() {
            _index = i;
            _counter = 0.0;
          });
        },
      );
    }
  }


  void next(){
    _counter = 0;
    _index = _index + 1;
    if(_index >= widget.childrenLength){
      _index = 0;
    }
    _pageController.animateToPage(_index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void previous(){
    _counter = 0;
    _index = _index - 1;
    if(_index < 0){
      _index = widget.childrenLength;
    }
    _pageController.animateToPage(_index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void _timer(){
    Timer.periodic(Duration(seconds: 1,), (timer) {
      _counter = _counter + 1;
      if(_counter >= widget.secondsToSwap){
        _index = _index + 1;
        if(_index >= widget.childrenLength){
          _index = 0;
        }
        if(widget.childrenLength != null && widget.childrenLength > 0) {
          if(_pageController.hasClients) {
            _pageController.animateToPage(_index, duration: Duration(milliseconds: 500), curve: Curves.ease,);
          }
        }
      }
    });
  }

}



//------------------------------------------------------------------------------

class HoverWidget extends StatefulWidget {
  final ContainerChanges onHover;
  final ContainerChanges idle;
  final Widget Function(bool isHovering) builder;

  final Duration duration;
  final Curve curve;
  final double width;
  final double height;
  final Widget child;
  HoverWidget({Key key,
    this.idle,
    this.onHover,
    this.builder,
    this.duration = const Duration(milliseconds: 25,),
    this.curve = Curves.linear,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);
  @override
  _HoverWidgetState createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {

  ContainerChanges _container;
  ContainerChanges _changes;
  bool _isHovering;

  @override
  void initState() {
    _container = widget.idle;
    _changes = ContainerChanges.nullValue();
    _isHovering = false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HoverWidget oldWidget) {
    _container = widget.idle;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      width: widget.width,
      height: widget.height,
      alignment: _changes.alignment == null ? _container.alignment : _changes.alignment,
      padding: _changes.padding == null ? _container.padding : _changes.padding,
      margin: _changes.margin == null ? _container.margin : _changes.margin,
      decoration: _changes.decoration == null ? _container.decoration : _changes.decoration,
      child: MouseRegion(
        onEnter: (pointerEnterEvent){ ///if mouse is currently over widget
          setState(() {
            _changes = widget.onHover;
            _isHovering = true;
          });
        },
        onExit: (pointerExitEvent){ ///if mouse NOT is currently over widget
          setState(() {
            _changes = ContainerChanges.nullValue();
            _isHovering = false;
          });
        },
        cursor: MouseCursor.defer,
        child: widget.child == null
            ? widget.builder(_isHovering,)
            : widget.child,
      ),
    );
  }

}

class ContainerChanges{
  final AlignmentGeometry alignment;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Decoration decoration;

  ContainerChanges({
    this.alignment,
    this.margin,
    this.padding,
    this.decoration,
  });

  ContainerChanges.nullValue() :
        this.alignment = null,
        this.margin = null,
        this.padding = null,
        this.decoration = null;
}



//------------------------------------------------------------------------------

