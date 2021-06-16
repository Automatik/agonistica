part of login_view;

class _LoginMobile extends StatelessWidget {

  final LoginViewModel viewModel;

  _LoginMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // return ScrollScaffoldWidget(
    //   showAppBar: false,
    //   childBuilder: (childContext, sizingInformation, parentSizingInformation) {
    //     return Container(
    //       constraints: BoxConstraints(
    //         minHeight: parentSizingInformation.localWidgetSize.height,
    //         minWidth: sizingInformation.screenSize.width
    //       ),
    //       child: flutterLogin(childContext),
    //     );
    //   },
    // );
    return flutterLogin(context);
  }

  Widget flutterLogin(BuildContext context) {
    return FlutterLogin(
      title: defaultAppBarTitle.toUpperCase(),
      logo: ImageAssets.IMAGE_IC_LAUNCHER,
      onSignup: (data) => viewModel.signUpUser(data),
      onLogin: (data) => viewModel.loginUser(data),
      onRecoverPassword: (name) => viewModel.recoverPassword(name),
      onSubmitAnimationCompleted: () => viewModel.onSubmitAnimationCompleted(context),
      userValidator: (email) => InputValidation.validateEmail(email!),
      passwordValidator: (psw) => InputValidation.validatePassword(psw!),
      messages: LoginMessages(
        userHint: "Email",
        passwordHint: "Password",
        confirmPasswordHint: "Conferma",
        loginButton: "ACCEDI",
        signupButton: "REGISTRATI",
        forgotPasswordButton: "Password dimenticata?",
        recoverPasswordButton: "RIPRISTINA",
        goBackButton: "INDIETRO",
        confirmPasswordError: "Non uguali!",
        recoverPasswordIntro: "Ripristina qui la tua password",
        recoverPasswordDescription: "Sarà inviata una email contenente un link per il ripristino della password di questo account",
        recoverPasswordSuccess: "Email inviata con successo",
      ),
      theme: LoginTheme(
        primaryColor: blueAgonisticaColor,
        accentColor: blueLightAgonisticaColor,
        titleStyle: TextStyle(
            color: Colors.white
        ),
      ),
    );
  }

}