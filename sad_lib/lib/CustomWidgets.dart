import 'dart:typed_data';
import 'package:flutter/material.dart';

class TextView extends StatefulWidget {
  final bool isSelectable;
  final EdgeInsets padding;
  final String text;
  final TextAlign align;
  final List<TextView> textSpan;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double letterSpacing;
  final int maxLines;

  TextView({Key key,
    this.isSelectable = false,
    this.padding = EdgeInsets.zero,
    @required this.text,
    this.align = TextAlign.left,
    this.size = 17.5,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.fontStyle = FontStyle.normal,
    this.letterSpacing = 0.75,
    this.maxLines,
  }) : this.textSpan = null, super(key: key);

  TextView.rich({Key key,
    this.isSelectable = false,
    this.align = TextAlign.left,
    this.padding = EdgeInsets.zero,
    @required this.textSpan,
  }) : this.text = null,
        this.size = null,
        this.color = null,
        this.fontWeight = null,
        this.fontStyle = null,
        this.letterSpacing = null,
        this.maxLines = null, super(key: key);

  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding,
        child: widget.isSelectable != true ? _normal()
        : _selectable(),
      );
  }

  Widget _normal(){
    if(widget.text != null){
      return Text(widget.text,
        maxLines: widget.maxLines,
        textAlign: widget.align,
        style: TextStyle(
          fontSize: widget.size,
          letterSpacing: widget.letterSpacing,
          fontWeight: widget.fontWeight,
          fontStyle: widget.fontStyle,
          color: widget.color,
        ),
      );
    }else{
      return Text.rich(
        TextSpan(
          children: <InlineSpan>[
            for(var textView in widget.textSpan)
              TextSpan(text: textView.text,
                style: TextStyle(
                  fontSize: textView.size,
                  letterSpacing: textView.letterSpacing,
                  fontWeight: textView.fontWeight,
                  fontStyle: textView.fontStyle,
                  color: textView.color,
                ),
              ),
          ],
        ),
        maxLines: widget.maxLines,
        textAlign: widget.align,
      );
    }
  }

  Widget _selectable(){
    if(widget.text != null){
      return SelectableText(widget.text,
        showCursor: true,
        autofocus: false,
        maxLines: widget.maxLines,
        textAlign: widget.align,
        toolbarOptions: ToolbarOptions(cut: true, selectAll: true, paste: true, copy: true),
        style: TextStyle(
          fontSize: widget.size,
          letterSpacing: widget.letterSpacing,
          fontWeight: widget.fontWeight,
          fontStyle: widget.fontStyle,
          color: widget.color,
        ),
      );
    }else{
      return SelectableText.rich(
        TextSpan(
          children: <InlineSpan>[
            for(var textView in widget.textSpan)
              TextSpan(text: textView.text,
                style: TextStyle(
                  fontSize: textView.size,
                  letterSpacing: textView.letterSpacing,
                  fontWeight: textView.fontWeight,
                  fontStyle: textView.fontStyle,
                  color: textView.color,
                ),
              ),
          ],
        ),
        showCursor: true,
        maxLines: widget.maxLines,
        textAlign: widget.align,
        toolbarOptions: ToolbarOptions(cut: true, selectAll: true, paste: true, copy: true),
      );
    }
  }

}



//------------------------------------------------------------------------------

enum Width {fit, stretch}
///fit = make button be normal size to fit content
///stretch = make button be stretch to fit screen width
enum Direction {vertical, horizontal}
///fit = make button be normal size to fit content
///stretch = make button be stretch to fit screen width
class ButtonView extends StatelessWidget {

  final EdgeInsets margin;
  final Alignment alignment;
  final Width width;
  final Direction direction;
  final void Function() onPressed;
  final Color color;
  final Gradient gradient;
  final double borderRadius;
  final Border border;
  final EdgeInsets padding;
  final List<BoxShadow> boxShadow;
  final List<Widget> children;

  ButtonView({Key key,
    this.alignment,
    this.width = Width.fit,
    this.direction = Direction.horizontal,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    @required this.onPressed,
    this.color = Colors.transparent,
    this.gradient,
    this.boxShadow,
    this.border = const Border(),
    this.borderRadius = 7.5,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(alignment == null){
      return _buttonView();
    }else {
      return Align(
        alignment: alignment,
        child: _buttonView(),
      );
    }
  }

  Widget _buttonView(){
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: (){
          onPressed.call();
        },
        hoverColor: color.value == Colors.white.value ? Colors.black.withOpacity(0.25) : Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: color.value == Colors.white.value ? Colors.black.withOpacity(0.25) : Colors.white.withOpacity(0.25),
        child: width == Width.fit ? Container(
          padding: padding,
          decoration: borderRadius == 0.0 ? BoxDecoration(
            color: color,
            gradient: gradient,
            border: border,
            boxShadow: boxShadow == null ? [] : boxShadow,
          ) : BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: gradient,
            border: border,
            boxShadow: boxShadow == null ? [] : boxShadow,
          ),
          child: _contentView(),
        )
            : Container(
          padding: padding,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: gradient,
            border: border,
          ),
          child: _contentView(),
        ),
      ),
    );
  }


  Widget _contentView(){
    if(direction == Direction.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: (width == Width.stretch) ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );
    }else{
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: (width == Width.stretch) ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
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

enum ImageType {network, custom}
typedef GetImageCallBack = Uint8List Function(String key); ///This function requires an image, that belongs to the given key
typedef AddImageCallBack = void Function(String key, Uint8List iamge); ///This function provides the key/url and image to the user to store or utilize
typedef ContainsImageCallBack = bool Function(String key); ///This function provides a key to the user tp check their image Map already contains a specific image

class ImageView extends StatelessWidget {

  final ColorFilter colorFilter;
  final double radius;
  final double aspectRatio;
  final EdgeInsets margin;
  final BoxFit fit;
  final double maxSize;

  final String imageKey;
  final ImageType imageType;

  final Future<Uint8List> imageFuture; final Future<Uint8List> Function() getCustomImage;
  final GetImageCallBack getImage;
  final AddImageCallBack addImage;
  final ContainsImageCallBack containsImage;

  final Widget errorView;
  final CustomLoader customLoader;

  ImageView.custom({Key key,
    @required this.imageKey,

    @required this.getCustomImage,
    @required this.getImage,
    @required this.addImage,
    @required this.containsImage,

    this.colorFilter = const ColorFilter.mode(Colors.transparent, BlendMode.dst),
    this.margin = EdgeInsets.zero,
    this.radius = 0.0,
    this.aspectRatio = 1.0,
    this.maxSize = double.infinity,
    this.fit = BoxFit.cover,

    @required this.customLoader,
    this.errorView,
  }) : this.imageType = ImageType.custom, this.imageFuture = getCustomImage.call(), super(key: key);

  ImageView.network({Key key,
    @required this.imageKey,

    this.getImage,
    this.addImage,
    this.containsImage,

    this.colorFilter = const ColorFilter.mode(Colors.transparent, BlendMode.dst),
    this.margin = EdgeInsets.zero,
    this.radius = 0.0,
    this.aspectRatio = 1.0,

    this.maxSize = double.infinity,
    this.fit = BoxFit.cover,
    @required this.customLoader,

    this.errorView,
  }) : this.imageFuture = null, this.getCustomImage = null, this.imageType = ImageType.network, super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColorFiltered(
          colorFilter: colorFilter,
          child: imageType == ImageType.network ? _networkImage() : _customImage(),
        ),
      ),
    );
  }

  Widget _networkImage(){
    return Image.network(imageKey,
      width: maxSize,
      height: maxSize/aspectRatio,
      fit: fit,
      loadingBuilder: (context, widget, chunk){
        if(chunk == null){
          return widget;
        }else {
          return customLoader;
        }
      },
      errorBuilder: (context, object, stackTrace){
        if(errorView == null){
          return TextView(text: "Unable to load image..",);
        }else{
          return errorView;
        }
      },
    );
  }

  Widget _customImage(){
    return FutureBuilder(
      future: imageFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData && snapshot.data != null){
            return Image.memory(snapshot.data, width: maxSize, height: maxSize/aspectRatio, fit: fit,);
          }else{
            return errorView == null ? TextView(text: "Unable to load image..",)
                : errorView;
          }
        }else{
          return Container(
              alignment: Alignment.center,
              width: maxSize,
              height: maxSize/aspectRatio,
              child: customLoader,
          );
        }
      },
    );
  }

}



//------------------------------------------------------------------------------

class CustomCarousel extends StatefulWidget {
  final Color circleColor;
  final double aspectRatio;
  final List<Widget> children;
  CustomCarousel({Key key,
    this.circleColor = Colors.white,
    this.aspectRatio = 2.0,
    @required this.children,
  }) : super(key: key);
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
    _pageController = PageController(initialPage: _index);
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
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            children: widget.children,
            onPageChanged: (i){
              setState(() {
                _index = i;
                _counter = 0.0;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0,),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3,),
              borderRadius: BorderRadius.circular(45.0,),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int i = 0; i < widget.children.length; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5,),
                    child: Icon(Icons.brightness_1_sharp,
                      size: 5.0,
                      color: i == _index ? widget.circleColor : Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _timer(){
    if(_counter >= 5){
      _index = _index + 1;
      if(_index >= widget.children.length){
        _index = 0;
      }
      _pageController.animateToPage(_index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
    Future.delayed(Duration(seconds: 1)).then((useless){
      _counter = _counter + 1;
      _timer();
    });
  }

}


//------------------------------------------------------------------------------

