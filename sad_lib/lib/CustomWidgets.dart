import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sad_lib/StorageClass.dart';

class TextView extends StatefulWidget {
  final bool isSelectable;
  final EdgeInsets padding;
  final String text;
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
    this.size = 17.5,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.fontStyle = FontStyle.normal,
    this.letterSpacing = 1.0,
    this.maxLines,
  }) : this.textSpan = null, super(key: key);

  TextView.rich({Key key,
    this.isSelectable = false,
    @required this.textSpan,
  }) : this.text = null,
        this.padding = null,
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
        child: widget.text != null ? SelectableText(widget.text,
          showCursor: widget.isSelectable,
          maxLines: widget.maxLines,
          toolbarOptions: widget.isSelectable == true ? ToolbarOptions(cut: true, selectAll: true, paste: true, copy: true)
                               : ToolbarOptions(cut: false, selectAll: false, paste: false, copy: false),
          style: TextStyle(
            fontSize: widget.size,
            letterSpacing: widget.letterSpacing,
            fontWeight: widget.fontWeight,
            fontStyle: widget.fontStyle,
            color: widget.color,
          ),
        )
        : SelectableText.rich(
          showCursor: false,
          maxLines: widget.maxLines,
          toolbarOptions: widget.isSelectable == true ? ToolbarOptions(cut: true, selectAll: true, paste: true, copy: true)
                               : ToolbarOptions(cut: false, selectAll: false, paste: false, copy: false),
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
        ),
      );
  }

}



//------------------------------------------------------------------------------

enum Width {fit, stretch}
///fit = make button be normal size to fit content
///stretch = make button be stretch to fit screen width
class ButtonView extends StatelessWidget {

  final EdgeInsets margin;
  final Alignment alignment;
  final Width width;
  final GestureTapCallback onPressed;
  final Color color;
  final Gradient gradient;
  final double borderRadius;
  final Border border;
  final EdgeInsets padding;
  final Icon icon;
  final Widget child;

  ButtonView({Key key,
    this.alignment = Alignment.center,
    this.width = Width.fit,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    @required this.onPressed,
    this.color = Colors.transparent,
    this.gradient,
    this.border = const Border(),
    this.borderRadius = 7.5,
    this.icon,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
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
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: gradient,
              border: border,
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
      ),
    );
  }

  Widget _contentView(){
    return Row(
      mainAxisAlignment: (width == Width.stretch && icon == null) ? MainAxisAlignment.center : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if(icon != null) icon,
        if(icon != null) SizedBox(width: 5.0,),
        (width == Width.fit || icon == null) ? child : Expanded(child: child),
      ],
    );
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

enum FutureType {file, network, firebaseStorage}
typedef GetImageCallBack = Uint8List Function(String key); ///This function requires an image, that belongs to the given key
typedef AddImageCallBack = void Function(String key, Uint8List iamge); ///This function provides the key/url and image to the user to store or utilize
typedef ContainsImageCallBack = bool Function(String key); ///This function provides a key to the user tp check their image Map already contains a specific image

class ImageView extends StatelessWidget {

  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  final ColorFilter colorFilter;
  final double radius;
  final double aspectRatio;
  final EdgeInsets margin;

  final String imageKey;
  final StorageClass storage;
  final GetImageCallBack getImage;
  final AddImageCallBack addImage;
  final ContainsImageCallBack containsImage;
  final FutureType futureType;
  final BoxFit fit;
  final double maxSize;
  final Widget errorView;

  final CustomLoader customLoader;

  ImageView({Key key,
    @required this.imageKey,
    @required this.storage,

    @required this.getImage,
    @required this.addImage,
    @required this.containsImage,

    this.colorFilter = const ColorFilter.mode(Colors.transparent, BlendMode.dst),
    this.margin = EdgeInsets.zero,
    this.radius = 0.0,
    this.aspectRatio = 1.0,

    this.futureType = FutureType.firebaseStorage,
    this.maxSize = double.infinity,
    this.fit = BoxFit.cover,
    @required this.customLoader,

    this.errorView,
  }) : super(key: key);

  Future<Uint8List> getImageFromFile(String key){
    if(containsImage.call(key) == true){
      // if imageList contains this key, then just get the image
      return Future.value(getImage.call(key));
    }else{
      return storage.readImage("$key.diaz").then((image){
        if(image == null || image.isEmpty){
          print("ImageView | getImageFromFile() Error: no image found at the requested destination; $key");
          return null;
        }else{
          addImage.call(key, image);
          return image;
        }
      });
    }
  }

  Future<Uint8List> getImageFromDB(String key){
    return getImageFromFile(key).then((image){
      if(image != null){
        return image;
      }else{
        if(containsImage.call(key) == true){
          return Future.value(getImage(key));
        }else{
          return _fireStorage.ref().child(key).getData(10000000).then((image){
            addImage.call(key, image);
            return image;
          }).catchError((onError){
            print("ImageView | Firebase Storage Error: ${onError.toString()}");
            return null;
          });
        }
      }
    }).catchError((onError){
      if(containsImage.call(key) == true){
        return Future.value(getImage(key));
      }else{
        return _fireStorage.ref().child(key).getData(10000000).then((image){
          addImage.call(key, image);
          return image;
        }).catchError((onError){
          print("ImageView | Firebase Storage Error: ${onError.toString()}");
          return null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColorFiltered(
          colorFilter: colorFilter,
          child: futureType == FutureType.network ? _networkImage() : _futureBuilder(),
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
    );
  }

  Widget _futureBuilder(){
    return FutureBuilder(
      future: futureType == FutureType.firebaseStorage ? getImageFromDB(imageKey) : getImageFromFile(imageKey),
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
              child: customLoader
          );
        }
      },
    );
  }

}
