import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pix_wall/models/photo_models.dart';

class PexelsService {
  final Dio dio = Dio();
  final String? apiKey = dotenv.env['API_KEY_PIXEL'];

  Future<List<PhotoModels>> fetchPhotos(String query) async {
    List<PhotoModels> photos = [];
    try {
      Response response = await dio.get(
        'https://api.pexels.com/v1/search?query=$query&per_page=30',
        options: Options(headers: {HttpHeaders.authorizationHeader: apiKey}),
      );

      // Parsear los datos de la respuesta a modelos de fotos
      Map<String, dynamic> jsonData = response.data;
      jsonData["photos"].forEach((element) {
        photos.add(PhotoModels.fromMap(element));
      });
    } catch (e) {
      print('Error fetching wallpapers: $e');
    }
    return photos;
  }

  Future<List<PhotoModels>> fetchRandomPhotos() async {
    List<PhotoModels> photos = [];
    try {
      // Llama al endpoint de fotos populares
      Response response = await dio.get(
        'https://api.pexels.com/v1/curated?per_page=50',
        options: Options(headers: {HttpHeaders.authorizationHeader: apiKey}),
      );

      // Parsear los datos de la respuesta a modelos de fotos
      Map<String, dynamic> jsonData = response.data;
      jsonData["photos"].forEach((element) {
        photos.add(PhotoModels.fromMap(element));
      });

      // Seleccionar aleatoriamente un subconjunto de fotos
      photos.shuffle(); // Mezcla la lista
      return photos.take(5).toList(); // Devuelve 5 fotos aleatorias
    } catch (e) {
      print('Error fetching random photos: $e');
    }
    return photos;
  }
}
