import 'package:flutter/material.dart';

class ImageMenuCard extends StatelessWidget {

  final String imageAsset;
  final String title;
  final Function onTap;
  final double width;
  final double height;
  final bool useWhiteBackground;

  ImageMenuCard({
    @required this.imageAsset,
    @required this.title,
    @required this.width,
    @required this.height,
    this.onTap,
    this.useWhiteBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        // width: width,
        // height: height,
        // alignment: Alignment.center,
        child: Stack(
          children: [
            imageBackground(),
            titleForeground(),
          ],
        ),
      ),
    );
  }

  Widget imageBackground() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: ClipRect(
          child: Image.asset(imageAsset, width: width, height: height, fit: BoxFit.fitWidth, )
      ),
    );
  }

  Widget titleForeground() {
    Widget titleWidget = useWhiteBackground ? titleForegroundWithBackground() : titleForegroundWithoutBackground();
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      child: titleWidget,
    );
  }

  Widget titleForegroundWithoutBackground() {
    return titleText(Colors.white, 32);
  }

  Widget titleForegroundWithBackground() {
    Color backgroundColor = Colors.black.withAlpha(128);
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(32),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: titleText(Colors.white, 28)
    );
  }

  Widget titleText(Color textColor, double fontSize) {
    return Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

}