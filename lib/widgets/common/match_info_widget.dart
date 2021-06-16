import 'package:agonistica/core/assets/image_assets.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/widgets/common/date_widget.dart';
import 'package:agonistica/widgets/images/svg_image.dart';
import 'package:agonistica/widgets/text/custom_rich_text.dart';
import 'package:agonistica/widgets/text/custom_text_field.dart';
import 'package:agonistica/widgets/text_styles/detail_view_subtitle_text_style.dart';
import 'package:agonistica/widgets/text_styles/detail_view_title_text_style.dart';
import 'package:flutter/material.dart';

class MatchInfoWidget extends StatelessWidget {

  static const double MATCH_INFO_HEIGHT = 250;
  static const double MATCH_INFO_LOGO_SIZE = 60;

  final Match match;
  final bool isEditEnabled;
  final double width;
  final Function(BuildContext, bool, Match)? onHomeTeamInserted;
  final Function(BuildContext, bool, Match)? onAwayTeamInserted;
  final Function(DateTime)? onDateInserted;
  final TextEditingController? resultTextEditingController1;
  final TextEditingController? resultTextEditingController2;
  final TextEditingController? leagueMatchTextEditingController;

  MatchInfoWidget({
    required this.match,
    required this.isEditEnabled,
    required this.width,
    this.resultTextEditingController1,
    this.resultTextEditingController2,
    this.leagueMatchTextEditingController,
    this.onHomeTeamInserted,
    this.onAwayTeamInserted,
    this.onDateInserted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 0),
      child: Stack(
        children: [
          matchInfoBackground(),
          matchInfoForeground(context, match, isEditEnabled),
        ],
      ),
    );
  }

  Widget matchInfoBackground() {
    return Container(
      child: ClipRect(
        child: Image.asset(
          ImageAssets.IMAGE_MATCH_DETAIL_BACKGROUND,
          width: width,
          height: MATCH_INFO_HEIGHT,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget matchInfoForeground(BuildContext context, Match matchInfo, bool isEditEnabled) {
    return Container(
      width: width,
      height: MATCH_INFO_HEIGHT,
      child: Column(
        children: [
          matchInfoTopRow(context, matchInfo, isEditEnabled, MATCH_INFO_HEIGHT),
          matchInfoBottomRow(context, matchInfo, isEditEnabled, MATCH_INFO_HEIGHT),
        ],
      ),
    );
  }

  Widget matchInfoTopRow(BuildContext context, Match matchInfo, bool isEditEnabled, double matchInfoHeight) {
    double height = 0.75 * matchInfoHeight;
    double topMargin = 0.24 * matchInfoHeight;
    TextStyle textStyle = DetailViewTitleTextStyle();
    double avatarSize = MATCH_INFO_LOGO_SIZE;
    return Container(
      height: height,
      padding: EdgeInsets.only(top: topMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          homeTeamColumn(context, matchInfo, isEditEnabled, textStyle, avatarSize),
          matchResult(isEditEnabled, textStyle),
          awayTeamColumn(context, matchInfo, isEditEnabled, textStyle, avatarSize),
        ],
      ),
    );
  }

  Widget matchInfoBottomRow(BuildContext context, Match matchInfo, bool isEditEnabled, double matchInfoHeight) {
    double height = 0.25 * matchInfoHeight;
    TextStyle textStyle = DetailViewSubtitleTextStyle();
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leagueMatchWidget(isEditEnabled, textStyle, leagueMatchTextEditingController),
          matchDateWidget(context, matchInfo, isEditEnabled, textStyle),
        ],
      ),
    );
  }

  Widget homeTeamColumn(BuildContext context, Match matchInfo, bool isEditEnabled, TextStyle textStyle, double avatarSize) {
    final widgets = [
      teamImageWidget(matchInfo.getHomeSeasonTeamImage()!, avatarSize),
      CustomRichText(
        onTap: () {
          if(onHomeTeamInserted != null) {
            onHomeTeamInserted!(context, isEditEnabled, matchInfo);
          }
        },
        enabled: isEditEnabled,
        text: matchInfo.getHomeSeasonTeamName()!,
        textAlign: TextAlign.center,
        fontColor: textStyle.color!,
        fontWeight: textStyle.fontWeight!,
        fontSize: textStyle.fontSize!,
      ),
    ];
    return teamColumn(widgets);
  }

  Widget awayTeamColumn(BuildContext context, Match matchInfo, bool isEditEnabled, TextStyle textStyle, double avatarSize) {
    final widgets = [
      teamImageWidget(matchInfo.getAwaySeasonTeamImage()!, avatarSize),
      CustomRichText(
        onTap: () {
          if(onAwayTeamInserted != null) {
            onAwayTeamInserted!(context, isEditEnabled, matchInfo);
          }
        },
        enabled: isEditEnabled,
        text: matchInfo.getAwaySeasonTeamName()!,
        textAlign: TextAlign.center,
        fontColor: textStyle.color!,
        fontWeight: textStyle.fontWeight!,
        fontSize: textStyle.fontSize!,
      ),
    ];
    return teamColumn(widgets);
  }

  Widget teamImageWidget(String imageAsset, double avatarSize) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(100),
        borderRadius: BorderRadius.circular(48),
      ),
      width: avatarSize,
      height: avatarSize,
      child: SvgImage(
        imageAsset: imageAsset,
        width: avatarSize,
        height: avatarSize,
      ),
    );
  }

  Widget teamColumn(List<Widget> children) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget matchResult(bool isEditEnabled, TextStyle textStyle) {
    return Expanded(
      child: Container(
        child: resultWidget(resultTextEditingController1, resultTextEditingController2, textStyle.color!, 32, textStyle.fontWeight!, isEditEnabled),
      ),
    );
  }

  Widget leagueMatchWidget(bool isEditEnabled, TextStyle textStyle, TextEditingController? controller) {
    if(controller == null) {
      controller = TextEditingController();
      controller.text = match.leagueMatch.toString();
    }
    return Expanded(
      flex: 1,
      child: Container(
        // margin: EdgeInsets.only(left: 12, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Giornata',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: textStyle.color,
                fontWeight: textStyle.fontWeight,
                fontSize: textStyle.fontSize,
              ),
            ),
            // SizedBox(width: 2,),
            CustomTextField(
              enabled: isEditEnabled,
              width: 50,
              controller: controller,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.top,
              maxLines: 1,
              textInputType: TextInputType.number,
              textColor: textStyle.color!,
              textFontSize: textStyle.fontSize!,
              textFontWeight: textStyle.fontWeight!,
              bottomBorderPadding: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget matchDateWidget(BuildContext context, Match matchInfo, bool isEditEnabled, TextStyle textStyle) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () async {
          if(isEditEnabled) {
            DateTime curDate = DateTime.now();
            await showDatePicker(
                context: context,
                initialDate: matchInfo.matchDate,
                firstDate: DateTime.utc(2020),
                lastDate: DateTime.utc(curDate.year + 1),
                initialDatePickerMode: DatePickerMode.day,
                helpText: "Seleziona la data della partita"
            ).then((date) {
              if(date != null && onDateInserted != null) {
                matchInfo.matchDate = date;
                onDateInserted!(date);
              }
            });
          }
        },
        child: Container(
          child: DateWidget(
            dateTime: match.matchDate,
            textStyle: textStyle,
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ),
      ),
    );
  }

  Widget resultWidget(TextEditingController? controller1, TextEditingController? controller2, Color fontColor, double fontSize, FontWeight fontWeight, bool enabled) {
    if(controller1 == null) {
      controller1 = TextEditingController();
      controller1.text = match.team1Goals.toString();
    }
    if(controller2 == null) {
      controller2 = TextEditingController();
      controller2.text = match.team2Goals.toString();
    }
    return Row(
      children: [
        CustomTextField(
          enabled: enabled,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          controller: controller1,
          maxLines: 1,
          textInputType: TextInputType.number,
          textColor: fontColor,
          textFontSize: fontSize,
          textFontWeight: fontWeight,
          bottomBorderPadding: 1,
        ),
        Text(
          '-',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        CustomTextField(
          enabled: enabled,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          controller: controller2,
          maxLines: 1,
          textInputType: TextInputType.number,
          textColor: fontColor,
          textFontSize: fontSize,
          textFontWeight: fontWeight,
          bottomBorderPadding: 1,
        ),
      ],
    );
  }

}