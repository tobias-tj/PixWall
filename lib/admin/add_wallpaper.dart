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
  final ImagePicker _picker = ImagePicker();

  String? value;
  File? selectedImage;
  bool isUploading = false;
  bool _isMounted = true;

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (!_isMounted) return;

    setState(() {
      if (image != null) {
        selectedImage = File(image.path);
      }
    });
  }

  Future<void> uploadItem() async {
    if (selectedImage == null) {
      showToast("Please select an image first!", Colors.orange);
      return;
    }
    if (value == null) {
      showToast("Please select a category!", Colors.orange);
      return;
    }

    setState(() {
      isUploading = true;
    });

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

        if (!_isMounted) return;

        showToast("Wallpaper has been added successfully!", Colors.green);
        resetForm();
      } else {
        throw Exception('Failed to upload image.');
      }
    } catch (e) {
      if (!_isMounted) return;
      showToast("Failed to upload image: $e", Colors.red);
    } finally {
      if (_isMounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  void resetForm() {
    setState(() {
      selectedImage = null;
      value = null;
    });
  }

  void showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.go('/admin/home'),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: const Color.fromARGB(255, 1, 29, 38),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Wallpaper",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: 'BeVietnamPro',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: getImage,
                child: selectedImage == null
                    ? buildPlaceholder()
                    : buildSelectedImage(),
              ),
              SizedBox(height: 40.0),
              buildDropdown(),
              SizedBox(height: 35.0),
              buildUploadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPlaceholder() {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 250,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildSelectedImage() {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 250,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(
            selectedImage!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                    ),
                  ))
              .toList(),
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
          },
          hint: Text('Select category'),
          value: value,
        ),
      ),
    );
  }

  Widget buildUploadButton() {
    return GestureDetector(
      onTap: isUploading ? null : uploadItem,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isUploading ? Colors.grey : Colors.black,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: isUploading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Guardar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
