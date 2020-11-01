import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DialogClass {
  //This class handle dialogs that are used throughout the app
  //and also does a couple of file handling(saves), with the instruction dialog

  BuildContext context;

  Color background;
  Color buttonColor;
  Color buttonTextColor;
  Color textColor;

  DialogClass(this.context, {@required this.background, @required this.buttonColor, @required this.buttonTextColor, @required this.textColor});

  Future<bool> assureDialog({@required String content, @required Color color, bool dismissible = true, String title = "null", bool negativeButton = true, String negative = "CANCEL", String positive = "CONFIRM"}) {
    return showDialog(context: context, barrierDismissible: dismissible, builder: (context) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
              child: Container(color: Colors.transparent,),
            ),
          ),
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
            backgroundColor: background,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0,),
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: SelectableText(content, textAlign: TextAlign.start,
                      showCursor: true,
                      toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.5,
                        color: textColor,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      if(negativeButton) ButtonView(
                        onPressed: (){
                          Navigator.of(context).pop(false);
                        },
                        padding: EdgeInsets.all(10.0),
                        child: TextView(text: negative.toUpperCase(),
                          size: 15.0,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      ButtonView(
                        onPressed: (){
                          Navigator.of(context).pop(true);
                        },
                        padding: EdgeInsets.all(10.0),
                        child: TextView(text: positive.toUpperCase(),
                          size: 15.0,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }


  Future<int> amountDialog({@required Color color, String title = "Enter An Amount", bool dismissible = true, String negative = "CANCEL", String positive = "CONTINUE"}) {
    ValueNotifier<int> amt = ValueNotifier(0);
    return showDialog(context: context, barrierDismissible: dismissible, builder: (context) {
      return Stack(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
              child: Container(color: Colors.transparent,),
            ),
          ),
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
            backgroundColor: background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  child: ListWheelScrollView(
                    itemExtent: 25.0,
                    useMagnifier: true,
                    magnification: 2,
                    diameterRatio: 1,
                    squeeze: 0.5,
                    physics: BouncingScrollPhysics(),
                    onSelectedItemChanged: (i){
                      amt.value = i+1;
                    },
                    children: <Widget>[
                      for(int i = 1; i <= 50; i ++)
                        TextView(text: "$i",
                          padding: EdgeInsets.all(5.0),
                          color: color,
                          size: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ButtonView(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: TextView(text: negative.toUpperCase(),
                        color: color,
                        size: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: amt,
                      builder: (context, number, _){
                        return ButtonView(
                          onPressed: (){
                            if (number > 0) {
                              Navigator.of(context).pop(number);
                            }
                          },
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: TextView(text: "${positive.toUpperCase()} ($number)",
                            color: color,
                            size: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
    );
  }


  //dialog for inputting names, which are short texts
  Future<String> nameDialog({@required Color color, @required String title, @required List<String> compare, int maxLength = 30, bool dismissible = true, String negative = "CANCEL", String positive = "CONTINUE"}) {
    String filename;
    return showDialog(context: context, barrierDismissible: dismissible, builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
                child: Container(color: Colors.transparent,),
              ),
            ),
            Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
              backgroundColor: background,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        autofocus: true,
                        autocorrect: true,
                        textAlignVertical: TextAlignVertical.center,
                        maxLength: maxLength,
                        maxLines: 1,
                        scrollPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        textAlign: TextAlign.center,
                        toolbarOptions: ToolbarOptions(paste: true, selectAll: true, copy: true, cut: true),
                        style: TextStyle(fontSize: 17.5),
                        onChanged: (text) {
                          filename = text;
                        },
                        onSubmitted: (text) {
                          if (text.isNotEmpty && text != ".") {
                            if (compare.contains(text)) {
                              assureDialog(content: "This entry already exists in the list.\nPlease provide a unique entry", color: color, dismissible: true);
                            }else{
                              Navigator.of(context).pop(text);
                            }
                          }
                        },
                        cursorColor: color,
                        decoration: InputDecoration(
                          labelText: title,
                          labelStyle: TextStyle(color: color),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ButtonView(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: TextView(text: negative.toUpperCase(),
                            color: color,
                            size: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ButtonView(
                          onPressed: (){
                            if (filename.isNotEmpty && filename != ".") {
                              if (compare.contains(filename)) {
                                assureDialog(content: "This entry already exists in the list.\nPlease provide a unique entry.", color: color, dismissible: true);
                              }else{
                                Navigator.of(context).pop(filename);
                              }
                            }
                          },
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: TextView(text: positive.toUpperCase(),
                            color: color,
                            size: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        );
    },
    );
  }


  //dialog for inputting long pieces of texts
  Future<String> textInputDialog({@required Color color, @required String title, int maxLength = 256, bool dismissible = true, String negative = "CANCEL", String positive = "CONTINUE"}) {
    String input;
    return showDialog(context: context, barrierDismissible: dismissible, builder: (context) {
      return Stack(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
              child: Container(color: Colors.transparent,),
            ),
          ),
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
            backgroundColor: background,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    autocorrect: true,
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.sentences,
                    enableSuggestions: true,
                    minLines: null,
                    maxLines: null,
                    maxLength: maxLength,
                    scrollPhysics: BouncingScrollPhysics(),
                    scrollPadding: EdgeInsets.symmetric(vertical: 10.0),
                    textAlign: TextAlign.start,
                    toolbarOptions: ToolbarOptions(paste: true, selectAll: true, copy: true, cut: true),
                    style: TextStyle(fontSize: 17.5,),
                    onChanged: (text) {
                      input = text;
                    },
                    onSubmitted: (text) {
                      if (text.isNotEmpty && text != ".") {
                        Navigator.of(context).pop(text);
                      }
                    },
                    cursorColor: color,
                    decoration: InputDecoration(
                      labelText: title,
                      labelStyle: TextStyle(color: color),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ButtonView(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.all(10.0),
                        child: TextView(text: negative.toUpperCase(),
                          color: color,
                          size: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ButtonView(
                        onPressed: (){
                          if (input.isNotEmpty &&  input != ".") {
                            Navigator.of(context).pop(input);
                          }
                        },
                        padding: EdgeInsets.all(10.0),
                        child: TextView(text: positive.toUpperCase(),
                          color: color,
                          size: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
    );
  }


  Future<bool> instructionDialog({@required String title, @required String message, @required String jsonKey, @required Size size, @required Color color, String imagePath = "assets/info.webp", String filename = "instructions.diaz", String button = "OKAY", bool checkBox = true}) {
    ValueNotifier<bool> valueNotifier = ValueNotifier(false);
    return showDialog(context: context, barrierDismissible: true, builder: (context) {
      return Stack(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
              child: Container(color: Colors.transparent,),
            ),
          ),
          Dialog(
            backgroundColor: Colors.transparent,
            child: ClipPath(
              clipper: InstructionShape(),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                scrollDirection: Axis.vertical,
                child: Container(
                  color: background,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90.0),
                          child: Image.asset(imagePath, width: size.width / 5,),
                        ),
                      ),
                      TextView(text: title,
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        color: color,
                        size: 22.5,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                        child: SelectableText(message, textAlign: TextAlign.start,
                          showCursor: true,
                          toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                            color: textColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          checkBox == true ? GestureDetector(
                            onTap: () {
                              valueNotifier.value = !valueNotifier.value;
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ValueListenableBuilder(
                                  valueListenable: valueNotifier,
                                  builder: (context, value, __) {
                                    return Checkbox(
                                      value: value,
                                      activeColor: buttonColor,
                                      onChanged: (flag) {
                                        valueNotifier.value = !valueNotifier.value;
                                      },
                                    );
                                  },
                                ),
                                TextView(text: "Do not show again",
                                  color: buttonTextColor,
                                  size: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          )
                          : Spacer(),
                          ButtonView(
                            onPressed: (){
                              Navigator.of(context).pop(valueNotifier.value);
                            },
                            padding: EdgeInsets.all(10.0),
                            child: TextView(text: button.toUpperCase(),
                              color: color,
                              size: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }


  //view media dialog
  Future<void> showMediaDialog(Uint8List media) {
    return showDialog(context: context, barrierDismissible: true, builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
                  child: Container(color: Colors.transparent,),
                ),
              ),
              Image.memory(media, fit: BoxFit.contain,),
              Align(
                alignment: Alignment.topRight,
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90.0)),
                  color: background,
                  child: IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, size: 30.0, color: buttonColor,),
                    splashColor: buttonColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  //web view Dialog
  Future<void> showWebViewDialog(String url, String linkName, {JavascriptChannel javaScriptChannel}) {
    return showDialog(context: context, barrierDismissible: true, builder: (BuildContext context) {
      JavascriptChannel exitChannel = JavascriptChannel(
          name: "Listener",
          onMessageReceived: (JavascriptMessage message) {
            if(message.message == "paid"){
              Navigator.of(context).pop();
            }
          });
        return Material(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(5.0, 5.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: background,
                        ),
                        child: TextView(text: linkName,
                          padding: EdgeInsets.symmetric(horizontal: 10.0,),
                          color: textColor,
                          size: 17.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      splashColor: buttonColor,
                      icon: Icon(Icons.close,
                        size: 30.0,
                        color: buttonColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
                  gestureNavigationEnabled: false,
                  javascriptChannels: javaScriptChannel == null ? <JavascriptChannel>[].toSet() : <JavascriptChannel>[
                    exitChannel,
                    javaScriptChannel,
                  ].toSet(),
                  navigationDelegate: (NavigationRequest request) {
                    return NavigationDecision.prevent;
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }


  Future<void> staticListDialog({@required List<dynamic> list}) {
    return showDialog(context: context, barrierDismissible: true, builder: (context) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
              child: Container(color: Colors.transparent,),
            ),
          ),
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
            backgroundColor: background,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(bottom: 7.5),
                  decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(7.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5.0,
                          offset: Offset(5.0, 5.0),
                        ),
                      ]
                  ),
                  child: SelectableText("${index + 1}:\t${list[index]}",
                    showCursor: true,
                    toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                    style: TextStyle(
                      fontSize: 17.5,
                      color: textColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    });
  }


  //loading dialog
  Future<dynamic> showLoadingDialog(Color color, Future<dynamic> Function() process) {
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
        process.call().then((map){
          Navigator.of(context).pop(map);
          // map example; {
          //    "result": "successful".
          //    "success": bool
          //    }
        });
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 3.0, sigmaX: 3.0),
                child: Container(color: Colors.transparent,),
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ),
        );
      },
    );
  }

}

class InstructionShape extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.width/9);
    path.lineTo(size.width/10, size.width/10);
    path.quadraticBezierTo(size.width*0.25, 0.0, size.width*.50, 0.0);
    path.quadraticBezierTo(size.width*0.75, 0.0, size.width-(size.width/10), size.width/10);
    path.lineTo(size.width, size.width/9);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}