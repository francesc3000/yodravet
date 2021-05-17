import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yodravet/src/bloc/event/home_event.dart';
import 'package:yodravet/src/bloc/home_bloc.dart';
import 'package:yodravet/src/locale/locales.dart';

import '../basic_page.dart';

abstract class HomeBasicPage extends BasicPage {
  HomeBasicPage(String title) : super(title);

  @override
  PreferredSizeWidget appBar(BuildContext context, {String title}) {
    // if (Theme.of(context).platform == TargetPlatform.linux || Theme.of(context).platform == TargetPlatform.macOS || Theme.of(context).platform == TargetPlatform.windows) {
    if (kIsWeb) {
      return AppBar(
        title: Container(
          // color: Color.fromRGBO(177, 237, 100, 93),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 58),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(153, 148, 86, 60 ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.userCircle),
            tooltip: AppLocalizations.of(context).userTooltip,
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(Navigate2UserPageEvent());
            },
          ),
        ],
      );
    } else {
      return AppBar(
        leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/race/logoYocorro.png'),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 50,
                width: 50,
              ),
            ),
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.userCircle),
            tooltip: AppLocalizations.of(context).userTooltip,
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(Navigate2UserPageEvent());
            },
          ),
          // RawMaterialButton(
          //   onPressed: () {
          //     BlocProvider.of<HomeBloc>(context).add(Navigate2UserPageEvent());
          //   },
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(100),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           image: AssetImage('assets/race/logoYocorro.png'),
          //         ),
          //         borderRadius: BorderRadius.all(Radius.circular(10)),
          //       ),
          //       height: 50,
          //       width: 50,
          //     ),
          //   ),
          //   shape: CircleBorder(),
          // ),
        ],
      );
    }
  }

  @override
  Widget bottomNavigationBar(BuildContext context) {
    return null;
  }

  @override
  Widget floatingActionButton(BuildContext context) {
    return null;
  }
}
