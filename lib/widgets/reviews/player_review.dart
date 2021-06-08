// @dart=2.9

import 'package:agonistica/core/assets/icon_assets.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/common/date_widget.dart';
import 'package:agonistica/widgets/images/svg_image.dart';
import 'package:agonistica/widgets/reviews/base_review.dart';
import 'package:agonistica/widgets/text_styles/base_review_subtitle_text_style.dart';
import 'package:agonistica/widgets/text_styles/base_review_team_text_style.dart';
import 'package:flutter/material.dart';

import '../../core/utils/my_date_utils.dart';

class PlayerReview extends BaseReview{

  final String name, role;
  final DateTime birthDay;

  PlayerReview({
    this.name,
    this.role,
    this.birthDay,
    width,
    minHeight = 50.0,
    onTap,
    onSettingsTap
  }) : assert(name != null),
        assert(role != null),
        assert(birthDay != null),
        super(width: width, minHeight: minHeight, onTap: onTap, onSettingsTap: onSettingsTap);

  @override
  Widget content() {
    return Row(
      children: [
        playerImage(),
        playerData(),
      ],
    );
  }

  Widget playerImage() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(200),
        borderRadius: BorderRadius.circular(32),
      ),
      alignment: Alignment.center,
      child: SvgImage(
        imageAsset: IconAssets.ICON_FOOTBALL_PLAYER,
        width: avatarSize,
        height: avatarSize,
      ),
    );
  }

  Widget playerData() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 5),
        child: Column(
          children: [
            topRow(),
            bottomRow()
          ],
        ),
      ),
    );
  }

  Widget topRow() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              child: Text(
                name,
                textAlign: TextAlign.start,
                style: BaseReviewTeamTextStyle(),
              ),
            ),
          ),
          GestureDetector(
              onTapDown: (tapDetails) => onSettingsTap(tapDetails.globalPosition),
              child: Container(
                  child: Icon(Icons.more_vert, color: blueAgonisticaColor, size: iconsSize,)
              ),
          ),
        ],
      ),
    );
  }

  Widget bottomRow() {
    return Container(
      margin: EdgeInsets.only(top: verticalMargin),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(
                role,
                textAlign: TextAlign.start,
                style: BaseReviewSubtitleTextStyle(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: DateWidget(
                dateTime: birthDay,
                textStyle: BaseReviewSubtitleTextStyle(),
                mainAxisAlignment: MainAxisAlignment.end,
                iconColor: blueAgonisticaColor,
                iconSize: iconsSize,
              )
            ),
          ),
        ],
      ),
    );
  }

}