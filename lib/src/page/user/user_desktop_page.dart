import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/user_event.dart';
import 'package:yodravet/src/bloc/state/user_state.dart';
import 'package:yodravet/src/bloc/user_bloc.dart';
import 'package:yodravet/src/page/user/widget/strava_switch.dart';
import 'package:yodravet/src/shared/platform_discover.dart';
import 'package:yodravet/src/widget/sliver_appbar_delegate.dart';

import '../../route/app_router_delegate.dart';
import 'user_basic_page.dart';

class UserDesktopPage extends UserBasicPage {
  const UserDesktopPage(String title, final AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context,
          {String? title, bool isMusicOn = false, bool isFirstTime = false}) =>
      null;

  @override
  Widget body(BuildContext context) {
    List<Widget> slivers = [];
    String fullName = '';
    String? photoUrl = '';
    bool _loading = false;
    bool? isStravaLogin = false;
    bool lockStravaLogin = false;

    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, state) {
        if (state is UserInitState) {
          BlocProvider.of<UserBloc>(context).add(LoadInitialDataEvent());
          _loading = true;
        } else if (state is UserLogInState) {
          // BlocProvider.of<UserBloc>(context).add(GetStravaActivitiesEvent());
        } else if (state is UserLogOutState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            routerDelegate.pushPageAndRemoveUntil(name: '/');
          });
        } else if (state is UploadUserFieldsState) {
          isStravaLogin = state.isStravaLogin;
          lockStravaLogin = state.lockStravaLogin;
          fullName = state.fullname;
          photoUrl = state.photo;
          _loading = false;
        }

        if (_loading) {
          return Container(
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: const Center(child: CircularProgressIndicator()));
        }

        slivers.clear();
        slivers = _buildSlivers(context, isStravaLogin!, lockStravaLogin,
            fullName, photoUrl!);

        return Container(
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: CustomScrollView(
            slivers: slivers,
          ),
        );
      },
    );
  }

  List<Widget> _buildSlivers(
      BuildContext context,
      bool isStravaLogin,
      bool lockStravaLogin,
      String fullName,
      String photoUrl) {
    List<Widget> slivers = [];
    Color primaryColor = Theme.of(context).primaryColor;

    //Botón cerrar sesión
    slivers.add(SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 40,
        maxHeight: 40,
        child: Container(
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                color: Colors.white,
                child: photoUrl.isEmpty
                    ? Image.asset(
                        'assets/images/avatar.png',
                        height: 50,
                        width: 50,
                      )
                    : Image.network(
                        photoUrl,
                        loadingBuilder: (context, child, imageEvent) =>
                            Image.asset(
                          'assets/images/avatar.png',
                          height: 75,
                        ),
                      ),
              ),
            ),
            title: Text(fullName),
            trailing: ElevatedButton(
              child: Text(AppLocalizations.of(context)!.logOut),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor)),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
              },
            ),
          ),
        ),
      ),
    ));

    //Switch Strava login
    if (PlatformDiscover.isWeb()) {
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverAppBarDelegate(
            minHeight: 40,
            maxHeight: 50,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                      "Puedes donar tus kilometros a través de nuestra app"),
                  SizedBox(
                    height: 80,
                    width: 130,
                    child: GestureDetector(
                      child: Image.asset("assets/images/stores/android.png"),
                      onTap: () => launchUrl( Uri.parse(
                          "https://play.google.com/store/apps/details?id=es.yocorroporeldravet.yodravet")),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 130,
                    child: GestureDetector(
                      child: Image.asset("assets/images/stores/apple.png"),
                      onTap: () => launchUrl( Uri.parse(
                          "https://apps.apple.com/es/app/yo-dravet/id1564711228")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverAppBarDelegate(
            minHeight: 40,
            maxHeight: 50,
            child: const StravaSwitch(),
          ),
        ),
      );
    }
    return slivers;
  }
}
