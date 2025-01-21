import 'package:flutter/material.dart';
import 'package:pix_wall/models/photo_models.dart';
import 'package:pix_wall/pages/full_screen.dart';

Widget searchWidget(List<PhotoModels> listPhotos, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      padding: EdgeInsets.all(4.0),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: (listPhotos.map((PhotoModels photoModels) {
        return GridTile(
            child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FullScreen(imagePath: photoModels.src!.portrait!)));
          },
          child: Hero(
            tag: photoModels.src!.portrait!,
            child: Container(
              color: Colors.blue,
              child: Image.network(
                photoModels.src!.portrait!,
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
            ),
          ),
        ));
      }).toList()),
    ),
  );
}
