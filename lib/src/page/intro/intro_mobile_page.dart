import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      const ContentConfig(
        title: "Dona Kilometros",
        description: "Puedes donar tus km",
        pathImage: "assets/images/avatar.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Compra Mariposas",
        description: "También puedes comprar mariposas y contribuir",
        pathImage: "assets/images/butterflies.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Patrocinadores",
        description:
            "Visita a nuestros patrocinadores en su sección. "
                "Puedes encender y apagar la musica arriba a la derecha",
        pathImage: "assets/images/sponsor.png",
        // backgroundNetworkImage: "https://firebasestorage.googleapis.com/v0/b/yo-corro-por-el-dravet.appspot.com/o/sponsors%2Fapoyo_dravet.jpeg?alt=media&token=cf6af36a-465b-4cec-9a62-21c69d6af0c4",
        backgroundColor: Color(0xff9932CC),
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
