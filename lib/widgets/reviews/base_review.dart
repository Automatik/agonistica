import 'package:flutter/material.dart';

abstract class BaseReview extends StatelessWidget {

  final double iconsSize = 24;
  final double avatarSize = 40;
  final double topMargin = 10;
  final double bottomMargin = 10;

  final double width;
  final double minHeight;
  final Function onTap, onSettingsTap;

  BaseReview({
    @required this.width,
    this.minHeight = 50,
    this.onTap,
    this.onSettingsTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          maxWidth: width,
          minHeight: minHeight,
        ),
        child: content(),
      ),
    );
  }

  Widget content();

}