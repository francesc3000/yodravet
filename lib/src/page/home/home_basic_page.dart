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
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(177, 237, 100, 93),
        // actions: [
        //   IconButton(
        //     icon: Icon(FontAwesomeIcons.userCircle),
        //     tooltip: AppLocalizations.of(context).userTooltip,
        //     onPressed: () {
        //       BlocProvider.of<HomeBloc>(context).add(Navigate2UserPageEvent());
        //     },
        //   ),
        // ],
      );
    } else {
      return AppBar(
        title: Text(title),
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
