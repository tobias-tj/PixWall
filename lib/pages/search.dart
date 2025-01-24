import 'package:flutter/material.dart';
import 'package:pix_wall/models/photo_models.dart';
import 'package:pix_wall/services/pexel.dart';
import 'package:pix_wall/widget/search_widget.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<PhotoModels> photos = [];
  TextEditingController searchController = TextEditingController();
  bool search = false;

  final PexelsService pexelsService = PexelsService();

  Future<void> getSearchWallpaper(String query) async {
    photos = await pexelsService.fetchPhotos(query);
    setState(() {
      search = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Search",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BeVietnamPro'),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(220, 205, 205, 205),
                  borderRadius: BorderRadius.circular(8.0)),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        getSearchWallpaper(searchController.text);
                      },
                      child: search
                          ? GestureDetector(
                              onTap: () {
                                photos = [];
                                search = false;
                                setState(() {});
                              },
                              child: Icon(
                                Icons.search_outlined,
                                color: const Color.fromARGB(255, 111, 110, 110),
                              ),
                            )
                          : Icon(
                              Icons.search_outlined,
                              color: const Color.fromARGB(255, 111, 110, 110),
                            ),
                    )),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(child: searchWidget(photos, context))
          ],
        ),
      ),
    );
  }
}
