import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math.dart' as math;

class ShearCommonDialogs {
  static showLoaderDialog2(BuildContext context) {
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Please wait')
                ],
              ),
            ),
          );
        });
  }

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text('تکایە چاوەڕوانبە')),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showMessageDialog(BuildContext context, String message, String titel) {
    AlertDialog alert = AlertDialog(
        title: Text(titel,
            textAlign: TextAlign.right), // To display the title it is optional
        content: Text(message,
            textAlign:
                TextAlign.right), // Message which will be pop up on the screen
        actions: [
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
            // function used to perform after pressing the button
            child: Text('OK'),
          ),
        ]);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showMessageDialogError(
      BuildContext context, String message, String titel) {
    AlertDialog alert = AlertDialog(
        //  title: Text(titel), // To display the title it is optional
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  //  color: Colors.green,
                  width: 32,
                  height: 25,
                  decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.black, width: 4),
                    borderRadius: BorderRadius.circular(5),
                    // color: Colors.green,
                  ),
                  child: Icon(Icons.error_outline_outlined,
                      size: 38, color: Colors.red)),
              Expanded(
                child: Text(
                  //   "Joan Mzuri",
                  titel,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 16),
                ),
              ),

              // SizedBox(width: 5.0),
              /*    GestureDetector(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            )*/
            ],
          ),
        ),
        content: Text(message,
            textAlign:
                TextAlign.right), // Message which will be pop up on the screen
        actions: [
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
            // function used to perform after pressing the button
            child: Text('OK'),
          ),
        ]);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<bool> showMessageDialogYesNo(
      BuildContext context, String message, String titel) async {
    bool result = false;
    AlertDialog alert = AlertDialog(
        title: Text(
          titel,
          textAlign: TextAlign.left,
        ), // To display the title it is optional
        content: Text(
          message,
          textAlign: TextAlign.left,
        ), // Message which will be pop up on the screen
        actions: [
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            // function used to perform after pressing the button
            child: Text('Yes'),
          ),
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            // function used to perform after pressing the button

            child: Text('No'),
          ),
        ]);
    result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return result;
  }

  static Future<bool> showMessageDialogYesNo_Ar(
      BuildContext context, String message, String titel) async {
    bool result = false;
    AlertDialog alert = AlertDialog(
        title: Text(
          titel,
          textAlign: TextAlign.right,
        ), // To display the title it is optional
        content: Text(
          message,
          textAlign: TextAlign.right,
        ), // Message which will be pop up on the screen
        actions: [
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            // function used to perform after pressing the button
            child: Text('بەڵێ'),
          ),
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            // function used to perform after pressing the button

            child: Text('نەخێر'),
          ),
        ]);
    result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return result;
  }

  static Future<bool> showMessageDialogYesNoWarnning(
      BuildContext context, String message, String titel) async {
    bool result = false;
    AlertDialog alert = AlertDialog(
        // title: Text(titel), // To display the title it is optional
        title: Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  //  color: Colors.green,
                  width: 32,
                  height: 25,
                  decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.black, width: 4),
                    borderRadius: BorderRadius.circular(5),
                    // color: Colors.green,
                  ),
                  child: Icon(Icons.error_outline_outlined,
                      size: 38, color: Colors.red)),
              Expanded(
                child: Text(
                  //   "Joan Mzuri",
                  titel,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 16),
                ),
              ),

              // SizedBox(width: 5.0),
              /*    GestureDetector(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            )*/
            ],
          ),
        ),
        /*Container(
           padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
           color: Color.fromARGB(255, 203, 32, 48),
           child: Text(titel,
               style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.right),),
         */

        titlePadding: const EdgeInsets.all(0),
        content: Text(message,
            textAlign:
                TextAlign.right), // Message which will be pop up on the screen
        iconColor: Colors.red,
        // titleTextStyle: TextStyle(),
        // backgroundColor: Color.fromARGB(255, 203, 32, 48),
        actions: [
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,

            onPressed: () {
              Navigator.of(context).pop(false);
            },
            // function used to perform after pressing the button
            child: Text('نەخێر', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              // fixedSize:Size.fromWidth(230) ,
              padding: EdgeInsets.all(0),

              //few more styles
            ),
          ),
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            // function used to perform after pressing the button

            child: Text('بەڵێ'),
          ),
        ]);
    result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return result;
  }

  static Future<bool> showMessageDialogOk(
      BuildContext context, String message, String titel) async {
    bool result = false;
    AlertDialog alert = AlertDialog(
        title: Text(
          titel,
          textAlign: TextAlign.right,
        ), // To display the title it is optional
        content: Text(
          message,
          textAlign: TextAlign.right,
        ), // Message which will be pop up on the screen
        actions: [
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            // function used to perform after pressing the button
            child: Text('Ok'),
          ),

          /*    TextButton( // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () { Navigator.of(context).pop(false);},
            // function used to perform after pressing the button

            child: Text('نەخێر'),
          ),*/
        ]);
    result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return result;
  }

  static showMessageDialog_AutoClose(
      BuildContext context, String message, String titel, int milliseconds) {
    Timer? timer = Timer(Duration(milliseconds: milliseconds), () {
      Navigator.of(context, rootNavigator: true).pop();
    });

    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(titel, textAlign: TextAlign.right),
                content: Text(
                  message,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        }).then((value) {
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });
  }

  static void openCustomDialog(BuildContext context) {
    Timer? timer = Timer(Duration(milliseconds: 1000), () {
      Navigator.of(context, rootNavigator: true).pop();
    });

    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Hello!!'),
                content: Text('How are you?'),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        }).then((value) {
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });

    // });
  }

  static Future<bool> showImageViwerDialogOk(
      BuildContext context, String message, String titel) async {
    bool result = false;
    AlertDialog alert = AlertDialog(
        title: Text(titel), // To display the title it is optional
        content: Text(message), // Message which will be pop up on the screen
        actions: [
          TextButton(
            // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            // function used to perform after pressing the button
            child: Text('Ok'),
          ),

          /*    TextButton( // FlatButton widget is used to make a text to work like a button
            // textColor: Colors.black,
            onPressed: () { Navigator.of(context).pop(false);},
            // function used to perform after pressing the button

            child: Text('نەخێر'),
          ),*/
        ]);
    result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return result;
  }
}
