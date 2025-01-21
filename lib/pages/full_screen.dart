import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class FullScreen extends StatefulWidget {
  String imagePath;
  FullScreen({super.key, required this.imagePath});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
              tag: widget.imagePath,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              )),
          Container(
            margin: EdgeInsets.only(bottom: 50.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _save();
                      },
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width / 1.7,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [
                              Color(0x36ffffff),
                              Color(0x0fffffff)
                            ])),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Set Wallpaper",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontFamily: 'BeVietnamPro'),
                            ),
                            Text(
                              "Image Will be saved in a gallery",
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "BeVietnamPro",
                        color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    var response = await Dio().get(widget.imagePath,
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

    print(result);
    Navigator.pop(context);
  }
}
