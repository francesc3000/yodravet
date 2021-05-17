import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/bloc/auth_bloc.dart';
import 'src/bloc/home_bloc.dart';
import 'src/bloc/race_bloc.dart';
import 'src/bloc/session_bloc.dart';
import 'src/bloc/signup_bloc.dart';
import 'src/bloc/user_bloc.dart';
import 'src/dao/factory_dao.dart';
import 'src/page/app.dart';
import 'src/repository/preferences_impl.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final PreferencesInterfaceImpl _prefs = PreferencesInterfaceImpl();
  await _prefs.initPreferences();
  FactoryDao _factoryDao = FactoryDao();
  //ignore: close_sinks
  SessionBloc _sessionBloc = SessionBloc(_factoryDao);

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) {
          return AuthBloc(_prefs, _sessionBloc);
        }),
        BlocProvider<HomeBloc>(
          create: (context) =>
              HomeBloc(_sessionBloc, _factoryDao),
        ),
        BlocProvider<UserBloc>(
          create: (context) =>
              UserBloc(_sessionBloc, _factoryDao),
        ),
        BlocProvider<RaceBloc>(
          create: (context) =>
              RaceBloc(_factoryDao),
        ),
        BlocProvider<SignupBloc>(
          create: (context) =>
              SignupBloc(_sessionBloc),
        ),
      ],

      child: App(_factoryDao.navigationService)));
}
