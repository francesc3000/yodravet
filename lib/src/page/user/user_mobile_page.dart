import 'package:flash/flash_helper.dart';
import 'package:flutter/gestures.dart';
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

class UserMobilePage extends UserBasicPage {
  const UserMobilePage(String title, AppRouterDelegate appRouterDelegate,
      {Key? key})
      : super(title, appRouterDelegate, key: key);

  @override
  Widget body(BuildContext context) {
    List<Widget> slivers = [];
    String fullName = '';
    String? photoUrl = '';
    String appVersion = '';
    bool loading = false;

    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, state) {
        if (state is UserInitState) {
          BlocProvider.of<UserBloc>(context).add(LoadInitialDataEvent());
          loading = true;
        } else if (state is UserLogInState) {
          // BlocProvider.of<UserBloc>(context).add(GetStravaActivitiesEvent());
          BlocProvider.of<UserBloc>(context).add(LoadInitialDataEvent());
        } else if (state is UserLogOutState) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            routerDelegate.pushPageAndRemoveUntil(name: '/');
          });
        } else if (state is UploadUserFieldsState) {
          fullName = state.fullname;
          photoUrl = state.photo;
          appVersion = state.appVersion;
          loading = false;
          // _churro = state.usuarios;
        } else if (state is UserStateError) {
          loading = false;
          //TODO: Mostrar errores en Pages
          // CustomSnackBar
        }

        if (loading) {
          return Container(
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: const Center(child: CircularProgressIndicator()));
        }

        slivers.clear();
        slivers = _buildSlivers(context, fullName, photoUrl!, appVersion);

        return Container(
          color: const Color.fromRGBO(153, 148, 86, 1),
          child: CustomScrollView(
            slivers: slivers,
          ),
        );
      },
    );
  }

  List<Widget> _buildSlivers(BuildContext context, String fullName,
      String photoUrl, String appVersion) {
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
                child: photoUrl.isEmpty
                    ? Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/avatar.webp',
                          height: 50,
                          width: 50,
                        ),
                      )
                    : Image.network(photoUrl)),
            title: Text(fullName),
            trailing: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor)),
              onPressed: () {
                context.showFlash(
                  barrierColor: Colors.black54,
                  barrierDismissible: true,
                  builder: (context, controller) => FadeTransition(
                    opacity: controller.controller,
                    child: AlertDialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        side: BorderSide(),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 24.0, top: 16.0, right: 24.0, bottom: 16.0),
                      title: Text(
                          AppLocalizations.of(context)!.dataCollectionTitle),
                      content: Text(
                          AppLocalizations.of(context)!.dataCollectionBody),
                      actions: [
                        TextButton(
                          onPressed: () {
                            controller.dismiss();
                            BlocProvider.of<AuthBloc>(context)
                                .add(LogOutEvent());
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor)),
                          child: Text(
                            AppLocalizations.of(context)!.dataCollectionSave,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.dismiss();
                            BlocProvider.of<AuthBloc>(context)
                                .add(LogOutEvent());
                          },
                          child: Text(
                            AppLocalizations.of(context)!.dataCollectionDiscard,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.logOut),
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
            minHeight: 115,
            maxHeight: 115,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: const Color.fromRGBO(153, 148, 86, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      "Puedes subir tus kilometros a través de nuestra app"),
                  Row(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 130,
                        child: GestureDetector(
                          child:
                              Image.asset("assets/images/stores/android.webp"),
                          onTap: () => launchUrl(Uri.parse(
                              "https://play.google.com/store/apps/details?id=es.yocorroporeldravet.yodravet")),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: 130,
                        child: GestureDetector(
                          child: Image.asset("assets/images/stores/apple.webp"),
                          onTap: () => launchUrl(Uri.parse(
                              "https://apps.apple.com/es/app/yo-dravet/id1564711228")),
                        ),
                      ),
                    ],
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

      slivers.add(
        SliverPersistentHeader(
          pinned: false,
          delegate: SliverAppBarDelegate(
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height - 530,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  RichText(
                    text: TextSpan(text: "", children: [
                      const TextSpan(
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 18),
                        text: "INSTRUCCIONES\n",
                      ),
                      const TextSpan(
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14),
                          text: "1. CONECTAR CON STRAVA\n"),
                      const TextSpan(
                          text:
                              "Debes pulsar el botón situado aquí arriba con el título. A continuación navegarás a la página de enlace de tu cuenta Strava con nuestra aplicación. Si aún no estás dado de alta desde esta página podrás crear tu cuenta y enlazarla."),
                      const TextSpan(
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 14),
                        text:
                            "\n\n2. TUTORIAL STRAVA PARA REGISTRAR ACTIVIDADES\n",
                      ),
                      const TextSpan(
                          text:
                              "A través del siguiente enlace podemos navegar a las instrucciones de Strava para registrar actividades en su aplicación."),
                      TextSpan(
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                'https://support.strava.com/hc/es-es/articles/216917397-Registrar-una-actividad#:~:text=Para%20ir%20a%20la%20pantalla,encima%20del%20bot%C3%B3n%20de%20inicio'));
                          },
                        text: " Tutorial",
                      ),
                      const TextSpan(
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 14),
                        text: "\n\n3. SUBE ACTIVIDADES POR EL DRAVET\n",
                      ),
                      const TextSpan(
                          text:
                              "Debes hacer clic en el botón central de la barra inferior (icono del corredor "),
                      const WidgetSpan(
                        child: Icon(
                          FontAwesomeIcons.personRunning,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(
                          text:
                              " ). Aquí, si has enlazado tu cuenta de Strava aparecerán tus actividades registradas en Strava en los días de la carrera.")
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if (PlatformDiscover.isIOs(context)) {
        slivers.add(
          SliverPersistentHeader(
            pinned: false,
            delegate: SliverAppBarDelegate(
              minHeight: 100,
              maxHeight: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(primaryColor)),
                      onPressed: () {
                        context.showFlash(
                          barrierColor: Colors.black54,
                          barrierDismissible: true,
                          builder: (context, controller) => FadeTransition(
                            opacity: controller.controller,
                            child: AlertDialog(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 24.0,
                                  top: 16.0,
                                  right: 24.0,
                                  bottom: 16.0),
                              title: Text(AppLocalizations.of(context)!
                                  .deleteAccountTitle),
                              content: Text(AppLocalizations.of(context)!
                                  .deleteAccountBody),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    controller.dismiss();
                                    BlocProvider.of<UserBloc>(context)
                                        .add(DeleteAccountEvent());
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          primaryColor)),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .deleteAccountOk,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: controller.dismiss,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .deleteAccountDiscard,
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.deleteAccount,
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    // slivers.add(
    //   SliverPersistentHeader(
    //     pinned: true,
    //     delegate: SliverAppBarDelegate(
    //       minHeight: 40,
    //       maxHeight: 50,
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text("Version: $appVersion"),
    //       ),
    //     ),
    //   ),
    // );
    return slivers;
  }
}
