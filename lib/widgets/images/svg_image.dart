import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {

  final String imageAsset;
  final double width;
  final double height;

  SvgImage({
    @required this.imageAsset,
    this.width,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: SvgPicture.asset(
        imageAsset,
        width: width,
        height: height,
        excludeFromSemantics: true,
      ),
    );
  }

}