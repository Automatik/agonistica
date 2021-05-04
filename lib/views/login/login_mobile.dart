part of login_view;

class _LoginMobile extends StatelessWidget {

  final LoginViewModel viewModel;

  _LoginMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: defaultAppBarTitle.toUpperCase(),
      onSignup: (data) => viewModel.signUpUser(data),
      onLogin: (data) => viewModel.loginUser(data),
      onRecoverPassword: (name) => viewModel.recoverPassword(name),
      onSubmitAnimationCompleted: () => viewModel.onSubmitAnimationCompleted(context),
    );
  }



}