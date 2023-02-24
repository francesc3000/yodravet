import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';

import '../../route/app_router_delegate.dart';
import 'intro_basic_page.dart';

class IntroMobilePage extends IntroBasicPage {
  const IntroMobilePage(AppRouterDelegate routerDelegate, {Key? key})
      : super(routerDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    List<ContentConfig> listContentConfig = [];

    listContentConfig.add(
      ContentConfig(
        title: AppLocalizations.of(context)!.introLabel1,
        description: AppLocalizations.of(context)!.introDescription1,
        pathImage: "assets/images/avatar.png",
        backgroundColor: const Color(0xfff5a623),
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title: AppLocalizations.of(context)!.introLabel2,
        description: AppLocalizations.of(context)!.introDescription2,
        pathImage: "assets/images/butterflies.png",
        backgroundColor: const Color(0xff203152),
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title: AppLocalizations.of(context)!.introLabel3,
        description: AppLocalizations.of(context)!.introDescription3,
        pathImage: "assets/images/sponsor.png",
        backgroundColor: const Color(0xff9932CC),
      ),
    );

    return IntroSlider(
      listContentConfig: listContentConfig,
      renderNextBtn: renderNextBtn(),
      renderDoneBtn: renderDoneBtn(),
      onDonePress: () => onDonePress(context),
    );
  }

  void onDonePress(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(HomeEventEmpty());
  }

  Widget renderNextBtn() => const Icon(
        Icons.navigate_next,
        color: Color(0xffF3B4BA),
        size: 35.0,
      );

  Widget renderDoneBtn() => const Icon(
        Icons.done,
        color: Color(0xffF3B4BA),
      );
}
