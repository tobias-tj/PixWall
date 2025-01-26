import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:saver_gallery/saver_gallery.dart';

class FullScreen extends StatefulWidget {
  String imagePath;
  FullScreen({super.key, required this.imagePath});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  bool _isSaving = false; // Para indicar si se está guardando

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
                      onTap: _isSaving
                          ? null
                          : _save, // Deshabilitar durante guardado
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
                    ),
                    if (_isSaving) // Mostrar indicador de carga
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    context.pop();
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
    setState(() {
      _isSaving = true; // Indicar que la imagen está siendo guardada
    });

    try {
      var response = await Dio().get(widget.imagePath,
          options: Options(responseType: ResponseType.bytes));
      final result = await SaverGallery.saveImage(
          Uint8List.fromList(response.data),
          fileName: '',
          skipIfExists: false);

      setState(() {
        _isSaving = false; // Finalizar el estado de guardado
      });

      Fluttertoast.showToast(
        msg: "Image saved successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      context.pop();
    } catch (e) {
      setState(() {
        _isSaving = false; // Finalizar el estado de guardado
      });

      Fluttertoast.showToast(
        msg: "Failed to save image!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
