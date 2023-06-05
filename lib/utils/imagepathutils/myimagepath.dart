import 'package:sbi_sahay_1_0/utils/Utils.dart';

class MyImagePath {
  String imagebaseurl;

  MyImagePath({required this.imagebaseurl});

  //circular animation lottie
  String getImageUrl(String path) {
    return this.imagebaseurl + path;
  }

}
