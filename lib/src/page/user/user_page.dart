import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/state/auth_state.dart';
import 'package:yodravet/src/page/login/login_page.dart';

import '../../route/app_router_delegate.dart';
import 'user_desktop_page.dart';
import 'user_mobile_page.dart';

class UserPage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;

  const UserPage(this.appRouterDelegate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          bool _isLogin = false;
          if (state is LogInSuccessState) {
            _isLogin = true;
          } else if (state is LogOutSuccessState) {
            _isLogin = false;
          }

          if (!_isLogin) {
            return LoginPage(appRouterDelegate);
          }

          return ScreenTypeLayout.builder(
            mobile: (BuildContext context) => OrientationLayoutBuilder(
              portrait: (context) => UserMobilePage('', appRouterDelegate),
            ),
            tablet: (BuildContext context) => OrientationLayoutBuilder(
              portrait: (context) => UserMobilePage('', appRouterDelegate),
              landscape: (context) => UserDesktopPage('', appRouterDelegate),
            ),
            desktop: (BuildContext context) => OrientationLayoutBuilder(
              portrait: (context) => UserMobilePage('', appRouterDelegate),
              landscape: (context) => UserDesktopPage('', appRouterDelegate),
            ),
            // desktop: UnderConstructionPage(),
          );
        },
      );
}