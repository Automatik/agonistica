import 'dart:math';

class RandomUtils {

  static int randomInt(int max) {
    final random = Random();
    return random.nextInt(max);
  }

}