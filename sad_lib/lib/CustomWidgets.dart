import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sad_lib/StorageClass.dart';

enum Font {s12, s15, s17, s20, s22, s40} // font sizes
// s12 = 12.0        s15 = 15.0          s17 = 17.5
// s20 = 20.0        s22 = 22.5          s40 = 40.0

class TextView extends StatelessWidget {

  final Alignment alignment;
  final EdgeInsets padding;
  final String text;
  final Font size;
  final Color color;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double letterSpacing;

  TextView({Key key,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    @required this.text,
    this.size = Font.s17,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.fontStyle = FontStyle.normal,
    this.letterSpacing = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(text,
        style: TextStyle(
          fontSize: size == Font.s12 ? 12.0
              : size == Font.s15 ? 15.0
              : size == Font.s17 ? 17.5
              : size == Font.s20 ? 20.0
              : size == Font.s22 ? 22.5
              : 40.0,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }

}

//------------------------------------------------------------------------------

enum Width {fit, stretch}
// fit = make button be normal size to fit content
// stretch = make button be stretch to fit screen width

class ButtonView extends StatelessWidget {

  final EdgeInsets margin;
  final Alignment alignment;
  final Width width;
  final GestureTapCallback onPressed;
  final Color color;
  final Gradient gradient;
  final double borderRadius;
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
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: color == Colors.white ? Colors.black.withOpacity(0.25) : Colors.white.withOpacity(0.25),
          child: width == Width.fit ? Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: gradient,
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

enum FutureType {file, database}
typedef GetImageCallBack = Uint8List Function(String key);
typedef AddImageCallBack = void Function(String key, Uint8List iamge);
typedef ContainsImageCallBack = bool Function(String key);

class ImageView extends StatelessWidget {

  FirebaseStorage _fireStorage = FirebaseStorage.instance;

  final ColorFilter colorFilter;
  final double radius;
  final EdgeInsets padding;

  final StorageClass storage;
  final String imageKey;
  final GetImageCallBack getImage;
  final AddImageCallBack addImage;
  final ContainsImageCallBack containsImage;
  final FutureType futureType;
  final BoxFit fit;
  final bool assignToWidth;
  final double maxSize;
  final Widget errorView;

  final IndicatorType indicator;

  ImageView({Key key,
    @required this.imageKey,
    @required this.storage,

    this.getImage,
    this.addImage,
    this.containsImage,

    this.colorFilter = const ColorFilter.mode(Colors.transparent, BlendMode.dst),
    this.padding = EdgeInsets.zero,
    this.radius = 0.0,

    this.futureType = FutureType.database,
    this.maxSize = double.infinity,
    this.assignToWidth = true,
    this.fit = BoxFit.cover,
    this.indicator = IndicatorType.circular,

    this.errorView,
  }) : super(key: key);

  Future<Uint8List> getImageFromFile(String key){ //key examples: profile Photo or profile Wallpaper
    if(containsImage.call(key) == true){
      // if imageList contains this key, then just get the image
      return Future.value(getImage.call(key));
    }else{
      return storage.readImage(key).then((image){
        if(image == null || image.isEmpty){
          return getImageFromDB(key).then((dbImage){
            addImage.call(key, dbImage);
            return storage.saveImage("userProfileImages.diaz", dbImage).then((value){
              return image;
            });
          });
        }else{
          addImage.call(key, image);
          return image;
        }
      });
    }
  }

  Future<Uint8List> getImageFromDB(String key){
    if(containsImage.call(key) == true){
      return Future.value(getImage(key));
    }else{
      return _fireStorage.ref().child(key).getData(10000000).then((image){
        addImage.call(key, image);
        return image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColorFiltered(
        colorFilter: colorFilter,
        child: Padding(
          padding: padding,
          child: FutureBuilder(
            future: futureType == FutureType.database ? getImageFromDB(imageKey) : getImageFromFile(imageKey),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  if(assignToWidth == true){
                    return Image.memory(snapshot.data, width: maxSize, fit: fit,);
                  }else {
                    return Image.memory(snapshot.data, height: maxSize, fit: fit,);
                  }
                }else{
                  return errorView == null ? Image.asset("assets/soca_logo.png", width: maxSize,
                    color: Colors.red, fit: fit,) : errorView;
                }
              }else{
                return Container(
                  alignment: Alignment.centerLeft,
                  width: maxSize,
                  child: CustomLoader(
                    indicator: IndicatorType.circular,
                    color1: Colors.blue,
                    color2: Colors.green,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

}
