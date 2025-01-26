import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pix_wall/pages/full_screen.dart';
import 'package:pix_wall/services/database.dart';

class AllWallpaper extends StatefulWidget {
  final String category;

  AllWallpaper({Key? key, required this.category}) : super(key: key);

  @override
  State<AllWallpaper> createState() => _AllWallpaperState();
}

class _AllWallpaperState extends State<AllWallpaper> {
  Stream? categoryStream;

  getOntheLoad() async {
    categoryStream = await DatabaseMethods().getCategory(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOntheLoad();
  }

  Widget allWallpaper() {
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(), // Indicador de carga
          );
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 6.0,
          ),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                context.push('/fullscreen', extra: ds["Image"]);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  ds["Image"],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child:
                            CircularProgressIndicator(), // Indicador de carga para cada imagen
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Retrocede a la pantalla anterior
          },
        ),
        centerTitle: true,
        title: Text(
          widget.category,
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'BeVietnamPro',
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: allWallpaper(),
      ),
    );
  }
}
