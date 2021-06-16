library login_view;

import 'package:agonistica/core/assets/image_assets.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'login_view_model.dart';

part 'login_mobile.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onModelReady: (viewModel) {
          // Do something once your viewModel is initialized
        },
        builder: (context, viewModel, child) {
          return ScreenTypeLayout(
            mobile: _LoginMobile(viewModel),
            tablet: _LoginMobile(viewModel),
          );
        }
    );
  }
}