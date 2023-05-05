import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/state/auth_state.dart';
import 'package:yodravet/src/page/login/login_page.dart';

import '../../route/app_router_delegate.dart';
import 'donor_desktop_page.dart';
import 'donor_mobile_page.dart';

class DonorPage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;

  const DonorPage(this.appRouterDelegate, {Key? key}) : super(key: key);

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
              portrait: (context) => DonorMobilePage('', appRouterDelegate),
            ),
            tablet: (BuildContext context) => OrientationLayoutBuilder(
              portrait: (context) => DonorMobilePage('', appRouterDelegate),
              landscape: (context) => DonorDesktopPage('', appRouterDelegate),
            ),
            desktop: (BuildContext context) => OrientationLayoutBuilder(
              portrait: (context) => DonorMobilePage('', appRouterDelegate),
              landscape: (context) => DonorDesktopPage('', appRouterDelegate),
            ),
            // desktop: UnderConstructionPage(),
          );
        },
      );
}