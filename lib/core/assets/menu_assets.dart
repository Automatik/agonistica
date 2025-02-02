

import 'package:agonistica/core/utils/random_utils.dart';

class MenuAssets {

  static const String MENU_IMAGE1 = "assets/menus/menu1.jpg";
  static const String MENU_IMAGE2 = "assets/menus/menu2.jpg";
  static const String MENU_IMAGE3 = "assets/menus/menu3.jpg";
  static const String MENU_IMAGE4 = "assets/menus/menu4.jpg";
  static const String MENU_IMAGE5 = "assets/menus/menu5.jpg";
  static const String MENU_IMAGE6 = "assets/menus/menu6.jpg";

  static List<String> getImagesArray() {
    return [
      MENU_IMAGE1,
      MENU_IMAGE2,
      MENU_IMAGE3,
      MENU_IMAGE4,
      MENU_IMAGE5,
      MENU_IMAGE6
    ];
  }

  static String getNewImage(List<String> usedMenuImages) {
    List<String> images = getImagesArray();
    images.removeWhere((i) => usedMenuImages.contains(i));
    if(images.isEmpty) {
      // All images are already in use by some menu
      // Get a random image and use an image for more than one menu
      return getRandomImage();
    }
    // Get an image not used yet
    int number = RandomUtils.randomInt(images.length);
    return images[number];
  }

  static String getRandomImage() {
    List<String> images = getImagesArray();
    int number = RandomUtils.randomInt(images.length);
    return images[number];
  }

}