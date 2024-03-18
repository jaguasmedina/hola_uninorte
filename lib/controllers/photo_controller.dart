import 'package:get/get.dart';
import 'package:hola_uninorte/models/photo_model.dart';

class PhotoController extends GetxController {
  RxString url = "".obs;
  RxString type = "".obs;
  RxString name = "".obs;

  final Photo picture = Photo(
    url: "",
    type: "",
    name: "",
  );

  void savePhoto(Photo photo) {
    picture.url = photo.url;
    picture.type = photo.type;
    picture.name = photo.name;
  }

  clearPhoto() {
    picture.url = "";
    picture.type = "";
    picture.name = "";
  }
}
