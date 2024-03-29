import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/bloc/state/home_state.dart';

import '../../route/app_router_delegate.dart';
import 'home_desktop_page.dart';
import 'home_mobile_page.dart';

class HomePage extends StatelessWidget {
  final AppRouterDelegate appRouterDelegate;
  const HomePage(this.appRouterDelegate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          bool isMusicOn = false;
          bool isFirstTime = false;
          if (state is UploadHomeFields) {
            isMusicOn = state.isMusicOn;
            isFirstTime = state.isFirstTime;
          }
          return ScreenTypeLayout.builder(
            mobile: (BuildContext context) => OrientationLayoutBuilder(
              portrait: (context) => HomeMobilePage(
                  AppLocalizations.of(context)!.title,
                  appRouterDelegate,
                  isMusicOn,
                  isFirstTime),
            ),
            tablet: (BuildContext context) => OrientationLayoutBuilder(
              portrait: (context) => HomeMobilePage(
                  AppLocalizations.of(context)!.title,
                  appRouterDelegate,
                  isMusicOn,
                  isFirstTime),
            ),
            desktop: (BuildContext context) => OrientationLayoutBuilder(
              portrait: (context) => HomeDesktopPage(
                  AppLocalizations.of(context)!.title,
                  appRouterDelegate,
                  isMusicOn,
                  isFirstTime),
            ),
          );
        },
      );
}
