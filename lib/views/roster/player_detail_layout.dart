import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/custom_rich_text.dart';
import 'package:agonistica/core/shared/custom_text_field.dart';
import 'package:agonistica/core/shared/edit_detail_button.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayerDetailLayout extends StatefulWidget {

  final bool isNewPlayer;
  final Player player;
  final double maxWidth;

  PlayerDetailLayout({
    @required this.isNewPlayer,
    @required this.player,
    this.maxWidth
  }) : assert(player != null);

  @override
  State<StatefulWidget> createState() => _PlayerDetailLayoutState();

}

class _PlayerDetailLayoutState extends State<PlayerDetailLayout> {

  bool editEnabled;

  Player tempPlayer;

  TextEditingController nameTextController, surnameTextController,
      heightTextController, weightTextController;

  @override
  void initState() {
    super.initState();
    // if it's a new player enable already edit mode, otherwise start in view mode
    editEnabled = widget.isNewPlayer;

    tempPlayer = Player.clone(widget.player);

    nameTextController = TextEditingController();
    surnameTextController = TextEditingController();
    heightTextController = TextEditingController();
    weightTextController = TextEditingController();
    nameTextController.text = tempPlayer.name;
    surnameTextController.text = tempPlayer.surname;
    heightTextController.text = tempPlayer.height.toString();
    weightTextController.text = tempPlayer.weight.toString();

  }

  void saveState() {
    setState(() {
      editEnabled = !editEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: widget.maxWidth,
        child: Column(
          children: [
            playerInfo(editEnabled, tempPlayer, nameTextController, surnameTextController, heightTextController, weightTextController),
          ],
        ),
      ),
    );
  }

  Widget playerInfo(bool isEditEnabled, Player playerInfo, TextEditingController nameTextController,
      TextEditingController surnameTextController, TextEditingController heightTextController,
      TextEditingController weightTextController) {

    final Color playerNameTextColor = blueAgonisticaColor;
    final double playerNameTextSize = 20;
    final FontWeight playerNameTextWeight = FontWeight.bold;

    final Color playerTeamTextColor = Colors.black;
    final double playerTeamTextSize = 18;
    final FontWeight playerTeamTextWeight = FontWeight.normal;

    final Color playerCategoryTextColor = Colors.black;
    final double playerCategoryTextSize = 16;
    final FontWeight playerCategoryTextWeight = FontWeight.normal;

    final Color playerHeightTextColor = Colors.black;
    final double playerHeightTextSize = 14;
    final FontWeight playerHeightTextWeight = FontWeight.normal;

    final double heightWidth = 40;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          height: 90,
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: SvgPicture.asset(
                      'assets/images/male.svg',
                      height: 50,
                      width: 50,
                      color: blueAgonisticaColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isEditEnabled ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextField(
                              enabled: isEditEnabled,
                              controller: nameTextController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              textInputType: TextInputType.text,
                              textColor: playerNameTextColor,
                              textFontSize: playerNameTextSize,
                              textFontWeight: playerNameTextWeight,
                            ),
                            SizedBox(width: 5,),
                            CustomTextField(
                              enabled: isEditEnabled,
                              controller: surnameTextController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              textInputType: TextInputType.text,
                              textColor: playerNameTextColor,
                              textFontSize: playerNameTextSize,
                              textFontWeight: playerNameTextWeight,
                            ),
                          ],
                        )
                        : Text(
                          "${nameTextController.text} ${surnameTextController.text}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: playerNameTextColor,
                            fontWeight: playerNameTextWeight,
                            fontSize: playerNameTextSize,
                          ),
                        ),
                        CustomRichText(
                          onTap: () {
                            print("TODO");
                          },
                          enabled: isEditEnabled,
                          text: playerInfo.teamName,
                          textAlign: TextAlign.start,
                          fontColor: playerTeamTextColor,
                          fontSize: playerTeamTextSize,
                          fontWeight: playerTeamTextWeight,
                        ),
                        CustomRichText(
                          onTap: () {
                            print("TODO");
                          },
                          enabled: isEditEnabled,
                          text: playerInfo.categoryName,
                          textAlign: TextAlign.start,
                          fontColor: playerCategoryTextColor,
                          fontSize: playerCategoryTextSize,
                          fontWeight: playerCategoryTextWeight,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () async {
                                if (isEditEnabled) {
                                  DateTime curDate = DateTime.now();
                                  await showDatePicker(
                                      context: context,
                                      initialDate: playerInfo.birthDay,
                                      firstDate: DateTime.utc(
                                          curDate.year - 50),
                                      lastDate: DateTime.utc(
                                          curDate.year + 1),
                                      initialDatePickerMode: DatePickerMode
                                          .day,
                                      helpText: "Seleziona la data di nascita"
                                  ).then((date) {
                                    if (date != null)
                                      setState(() {
                                        playerInfo.birthDay = date;
                                      });
                                  });
                                }
                              },
                              child: Text(
                                "${playerInfo.birthDay.day} ${Utils
                                    .monthToString(
                                    playerInfo.birthDay.month).substring(
                                    0, 3)} ${playerInfo.birthDay.year}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: playerHeightTextColor,
                                  fontSize: playerHeightTextSize,
                                  fontWeight: playerHeightTextWeight,
                                ),
                              ),
                            ),
                          ),
                        Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomTextField(
                                  width: heightWidth,
                                  enabled: isEditEnabled,
                                  controller: heightTextController,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  textInputType: TextInputType.number,
                                  textColor: playerHeightTextColor,
                                  textFontSize: playerHeightTextSize,
                                  textFontWeight: playerHeightTextWeight,
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  "cm",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: playerHeightTextColor,
                                    fontSize: playerHeightTextSize,
                                    fontWeight: playerHeightTextWeight,
                                  ),
                                )
                              ],
                            ),
                          ),
                        Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomTextField(
                                  width: heightWidth,
                                  enabled: isEditEnabled,
                                  controller: weightTextController,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  textInputType: TextInputType.number,
                                  textColor: playerHeightTextColor,
                                  textFontSize: playerHeightTextSize,
                                  textFontWeight: playerHeightTextWeight,
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  "kg",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: playerHeightTextColor,
                                    fontSize: playerHeightTextSize,
                                    fontWeight: playerHeightTextWeight,
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        EditDetailButton(
          isEditEnabled: isEditEnabled,
          onTap: () => saveState(),
        ),
      ],
    );
  }

}