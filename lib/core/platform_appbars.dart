import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformAppBars {

  static const double actionIconsMargin = 12;

  static PlatformAppBar getPlatformAppBar(String title) {
    return PlatformAppBar(
        backgroundColor: appBarBackgroundColor,
        title: Text(
          title,
          style: TextStyle(
            color: blueAgonisticaColor,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          leading: Icon(Icons.menu,color: blueAgonisticaColor,),
        )
    );
  }

  static PlatformAppBar getPlatformAppBarWithAddAction(String title, Function onActionAddPressed) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(
          leading: Icon(Icons.menu,color: blueAgonisticaColor,),
          actions: [
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionAddPressed,
                child: Icon(
                  Icons.add,
                  color: blueAgonisticaColor,
                ),
              ),
            )
          ]
      ),
    );
  }

  static PlatformAppBar getPlatformAppBarForRosterViewInViewMode(String title, Function onActionBack, Function onActionEditPress, Function onActionNotesPress) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(
          leading: GestureDetector(
              onTap: onActionBack,
              child: Icon(Icons.arrow_back, color: blueAgonisticaColor,)
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionEditPress,
                child: Icon(
                  Icons.edit,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionNotesPress,
                child: Icon(
                  Icons.assignment_rounded,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
          ]
      ),
    );
  }

  static PlatformAppBar getPlatformAppBarForRosterViewInEditMode(String title, Function onActionBack, Function onActionCancel, Function onActionConfirm) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(
          leading: GestureDetector(
              onTap: onActionBack,
              child: Icon(Icons.arrow_back, color: blueAgonisticaColor,)
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionCancel,
                child: Icon(
                  Icons.close,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionConfirm,
                child: Icon(
                  Icons.done,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
          ]
      ),
    );
  }

  static PlatformAppBar getPlatformAppBarForMatchesViewInViewMode(String title, Function onActionBack, Function onActionEditPress, Function onActionAddPress) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(
          leading: GestureDetector(
              onTap: onActionBack,
              child: Icon(Icons.arrow_back, color: blueAgonisticaColor,)
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionEditPress,
                child: Icon(
                  Icons.edit,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionAddPress,
                child: Icon(
                  Icons.add,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
          ]
      ),
    );
  }

  static PlatformAppBar getPlatformAppBarForMatchesViewInEditMode(String title, Function onActionBack, Function onActionCancel, Function onActionConfirm) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(
          leading: GestureDetector(
              onTap: onActionBack,
              child: Icon(Icons.arrow_back, color: blueAgonisticaColor,)
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionCancel,
                child: Icon(
                  Icons.close,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionConfirm,
                child: Icon(
                  Icons.done,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
          ]
      ),
    );
  }

  static PlatformAppBar getPlatformAppBarForPlayerMatchesView(String title, Function onActionBack) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(
          leading: GestureDetector(
              onTap: onActionBack,
              child: Icon(Icons.arrow_back, color: blueAgonisticaColor,)
          ),
      ),
    );
  }

  static PlatformAppBar getPlatformAppBarForNotesViewInViewMode(String title, Function onActionBack, Function onActionEditPress) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(
          leading: GestureDetector(
              onTap: onActionBack,
              child: Icon(Icons.arrow_back, color: blueAgonisticaColor,)
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionEditPress,
                child: Icon(
                  Icons.edit,
                  color: blueAgonisticaColor,
                ),
              ),
            )
          ]
      ),
    );
  }

  static PlatformAppBar getPlatformAppBarForNotesViewInEditMode(String title, Function onActionBack, Function onActionCancel, Function onActionConfirm) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(
          leading: GestureDetector(
              onTap: onActionBack,
              child: Icon(Icons.arrow_back, color: blueAgonisticaColor,)
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionCancel,
                child: Icon(
                  Icons.close,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: actionIconsMargin),
              child: GestureDetector(
                onTap: onActionConfirm,
                child: Icon(
                  Icons.done,
                  color: blueAgonisticaColor,
                ),
              ),
            ),
          ]
      ),
    );
  }

}