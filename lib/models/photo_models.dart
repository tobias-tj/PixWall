class PhotoModels {
  String? url;
  SrcModel? src;

  PhotoModels({this.url, this.src});

  factory PhotoModels.fromMap(Map<String, dynamic> parsedJSON) {
    return PhotoModels(
        url: parsedJSON["url"], src: SrcModel.fromMap(parsedJSON["src"]));
  }
}

class SrcModel {
  String? portrait;
  String? large;
  String? landscape;
  String? medium;

  SrcModel({this.landscape, this.large, this.medium, this.portrait});

  factory SrcModel.fromMap(Map<String, dynamic> srcJson) {
    return SrcModel(
      portrait: srcJson["portrait"],
      large: srcJson["large"],
      landscape: srcJson["landscape"],
      medium: srcJson["medium"],
    );
  }
}
