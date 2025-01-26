import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix_wall/services/database.dart';
import 'package:random_string/random_string.dart';
import 'package:uploadthing/uploadthing.dart';

class AddWallpaper extends StatefulWidget {
  const AddWallpaper({super.key});

  @override
  State<AddWallpaper> createState() => _AddWallpaperState();
}

class _AddWallpaperState extends State<AddWallpaper> {
  final uploadThing = UploadThing(dotenv.env['UPLOADTHING_SECRET']!);
  final List<String> categoryItems = [
    'Ocean',
    'Mountains',
    'Animals',
    'Travels'
  ];
  String? value;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  bool _isMounted = true; // Variable para verificar si el widget sigue montado

  @override
  void dispose() {
    _isMounted = false; // Marca el widget como no montado
    super.dispose();
  }

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (!_isMounted) return; // Verifica si el widget sigue montado

    setState(() {
      if (image != null) {
        selectedImage = File(image.path);
      }
    });
  }

  Future<void> uploadItem() async {
    if (selectedImage != null) {
      try {
        await uploadThing.uploadFiles([selectedImage!]);

        if (uploadThing.uploadedFilesData.isNotEmpty) {
          final String downloadUrl =
              uploadThing.uploadedFilesData.first['url'] as String;
          String addId = randomAlphaNumeric(10);

          Map<String, dynamic> addItem = {
            "Image": downloadUrl,
            "Id": addId,
          };

          await DatabaseMethods().addWallpaper(addItem, addId, value!);

          if (!_isMounted) return; // Verifica si el widget sigue montado
          Fluttertoast.showToast(
            msg: "Wallpaper has been added successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          throw Exception('Failed to upload image.');
        }
      } catch (e) {
        if (!_isMounted) return; // Verifica si el widget sigue montado
        Fluttertoast.showToast(
          msg: "Failed to upload image: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      if (!_isMounted) return; // Verifica si el widget sigue montado
      Fluttertoast.showToast(
        msg: "Please select an image first!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.go('/admin/home');
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: const Color.fromARGB(255, 1, 29, 38),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Wallpaper",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontFamily: 'BeVietnamPro'),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            selectedImage == null
                ? GestureDetector(
                    onTap: getImage, // Se llama directamente a getImage
                    child: Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 250,
                          height: 300,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 250,
                        height: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 40.0),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 236),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                items: categoryItems
                    .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        )))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
                hint: Text('Select category'),
                value: value,
              )),
            ),
            SizedBox(height: 35.0),
            GestureDetector(
              onTap: uploadItem,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Center(
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
