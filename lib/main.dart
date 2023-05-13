import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/bloc/collaborate_bloc.dart';
import 'package:yodravet/src/bloc/donor_bloc.dart';
import 'package:yodravet/src/bloc/feed_bloc.dart';
import 'package:yodravet/src/bloc/ranking_bloc.dart';
import 'package:yodravet/src/bloc/sponsor_bloc.dart';
import 'package:yodravet/src/bloc/terms_bloc.dart';
import 'package:yodravet/src/route/app_router_delegate.dart';
import 'package:yodravet/src/route/app_router_delegate_impl.dart';

// Import the generated file
import 'firebase_options.dart';
import 'src/bloc/auth_bloc.dart';
import 'src/bloc/home_bloc.dart';
import 'src/bloc/race_bloc.dart';
import 'src/bloc/session_bloc.dart';
import 'src/bloc/signup_bloc.dart';
import 'src/bloc/user_bloc.dart';
import 'src/dao/factory_dao.dart';
import 'src/page/app.dart';
import 'src/repository/preferences_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final PreferencesInterfaceImpl prefs = PreferencesInterfaceImpl();
  await prefs.initPreferences();
  AppRouterDelegate routeService = AppRouterDelegateImpl();
  FactoryDao factoryDao = FactoryDao(routeService);
  //ignore: close_sinks
  SessionBloc sessionBloc = SessionBloc(factoryDao);
  RaceBloc raceBloc = RaceBloc(sessionBloc, factoryDao);
  AuthBloc authBloc = AuthBloc(prefs, sessionBloc);

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(create: (context) => authBloc),
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(sessionBloc, factoryDao),
    ),
    BlocProvider<UserBloc>(
      create: (context) => UserBloc(sessionBloc, factoryDao),
    ),
    BlocProvider<DonorBloc>(
      create: (context) => DonorBloc(sessionBloc, factoryDao),
    ),
    BlocProvider<RankingBloc>(
      create: (context) => RankingBloc(sessionBloc, factoryDao),
    ),
    BlocProvider<RaceBloc>(
      create: (context) => raceBloc,
    ),
    BlocProvider<SignupBloc>(
      create: (context) => SignupBloc(sessionBloc),
    ),
    BlocProvider<SponsorBloc>(
      create: (context) => SponsorBloc(factoryDao),
    ),
    BlocProvider<FeedBloc>(
      create: (context) => FeedBloc(factoryDao),
    ),
    BlocProvider<TermsBloc>(
      create: (context) => TermsBloc(factoryDao, authBloc),
    ),
    BlocProvider<CollaborateBloc>(
      create: (context) => CollaborateBloc(factoryDao, raceBloc, authBloc),
    ),
  ], child: App(factoryDao.routeService)));
}
