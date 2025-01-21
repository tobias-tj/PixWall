import 'package:flutter/material.dart';
import 'package:pix_wall/pages/all_wallpaper.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Categories",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeVietnamPro'),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AllWallpaper(category: "Ocean")));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          "images/wallpaper1.jpg",
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            "Ocean",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'BeVietnamPro',
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AllWallpaper(category: "Mountains")));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          "images/wallpaper3.jpg",
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            "Mountains",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'BeVietnamPro',
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AllWallpaper(category: "Animals")));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          "images/categoryAnimal.jpg",
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            "Animals",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'BeVietnamPro',
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AllWallpaper(category: "Travels")));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          "images/categoryTravels.jpg",
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            "Travels",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'BeVietnamPro',
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
