import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pix_wall/go_router.dart';
import 'package:pix_wall/models/photo_models.dart';
import 'package:pix_wall/pages/full_screen.dart';
import 'package:pix_wall/services/pexel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> wallpaperImage = [];
  int activeIndex = 0;
  bool isLoading = true; // Estado de carga
  final PexelsService pexelsService = PexelsService();

  @override
  void initState() {
    super.initState();
    fetchWallpapers();
  }

  Future<void> fetchWallpapers() async {
    try {
      List<PhotoModels> photos = await pexelsService.fetchRandomPhotos();
      setState(() {
        wallpaperImage =
            photos.map((photo) => photo.src?.large ?? '').take(5).toList();
        isLoading = false; // Termina la carga
      });
    } catch (e) {
      print('Error fetching wallpapers: $e');
      setState(() {
        isLoading =
            false; // Finaliza el estado de carga incluso en caso de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(), // Indicador de carga
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(60),
                        child: GestureDetector(
                          onTap: () async {
                            // Mostrar cuadro de diálogo de confirmación
                            final shouldLogout = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmación"),
                                    content: const Text(
                                        "¿Estás seguro de que deseas cerrar sesión?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(false); // Cancelar
                                        },
                                        child: const Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(true); // Confirmar
                                        },
                                        child: const Text("Cerrar sesión"),
                                      ),
                                    ],
                                  );
                                });
                            // Si el usuario confirmó, ejecutar logout
                            if (shouldLogout == true) {
                              await authService.logout();
                              context.go('/login');
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset(
                              "images/closeSession.png",
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 80),
                      const Text(
                        "Wallify",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BeVietnamPro'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  // Mostrar CarouselSlider con las imágenes cargadas
                  CarouselSlider.builder(
                    itemCount: wallpaperImage.length,
                    itemBuilder: (context, index, realIndex) {
                      final res = wallpaperImage[index];
                      return buildImage(res);
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      height: MediaQuery.of(context).size.height / 1.5,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: buildIndicator(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: wallpaperImage.length,
        effect: const JumpingDotEffect(
          dotWidth: 15,
          dotHeight: 15,
          activeDotColor: Colors.blue,
        ),
      );

  Widget buildImage(String urlImage) => Container(
        margin: const EdgeInsets.only(right: 10.0),
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreen(imagePath: urlImage),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image.network(
              urlImage,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child:
                      CircularProgressIndicator(), // Indicador de carga individual
                );
              },
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image,
                size: 100,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );
}
