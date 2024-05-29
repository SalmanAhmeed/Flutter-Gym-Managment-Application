import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vector_math/vector_math.dart' as math;

class ShearCommonImageViewerDialogs {
  static Widget showImageViewerDialogWithZoom(String text, String imageUrl, BuildContext context) {
    final _screen = MediaQuery.of(context).size;

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
                Text(
                  text,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            height: _screen.height * 0.60,
            child: PhotoView(
              backgroundDecoration: BoxDecoration(
                color: Colors.black87,
              ),
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        ],
      ),
    );
  }

  static Widget showImageViewerDialogOk(text, imageData, context) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(10.0),
            width: 200,
            // height: 70,
            height: 400,

            // constraints: BoxConstraints.expand(height: double.infinity,),
            decoration: BoxDecoration(
                color: Colors.white,
                //   shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    image: imageData != null
                        ? MemoryImage(imageFromBase64String2(imageData))
                        : MemoryImage(imageFromBase64String2(
                            '0xFFD8FFE000104A4649460001010101')),
                    //  Image.memory(blankBytes,height: 1,);
                    fit: BoxFit.fill)),
          ),
        ],
      ),
    );
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  static Uint8List imageFromBase64String2(String base64String) {
    //Uint8List _bytes;
    return Base64Decoder().convert(base64String);
  }
}
