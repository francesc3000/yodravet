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
  final PreferencesInterfaceImpl _prefs = PreferencesInterfaceImpl();
  await _prefs.initPreferences();
  AppRouterDelegate routeService = AppRouterDelegateImpl();
  FactoryDao _factoryDao = FactoryDao(routeService);
  //ignore: close_sinks
  SessionBloc _sessionBloc = SessionBloc(_factoryDao);
  RaceBloc _raceBloc = RaceBloc(_sessionBloc, _factoryDao);
  AuthBloc _authBloc = AuthBloc(_prefs, _sessionBloc);

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(create: (context) => _authBloc),
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(_sessionBloc, _factoryDao),
    ),
    BlocProvider<UserBloc>(
      create: (context) => UserBloc(_sessionBloc, _factoryDao),
    ),
    BlocProvider<DonorBloc>(
      create: (context) => DonorBloc(_sessionBloc, _factoryDao),
    ),
    BlocProvider<RankingBloc>(
      create: (context) => RankingBloc(_sessionBloc, _factoryDao),
    ),
    BlocProvider<RaceBloc>(
      create: (context) => _raceBloc,
    ),
    BlocProvider<SignupBloc>(
      create: (context) => SignupBloc(_sessionBloc),
    ),
    BlocProvider<SponsorBloc>(
      create: (context) => SponsorBloc(_factoryDao),
    ),
    BlocProvider<FeedBloc>(
      create: (context) => FeedBloc(_factoryDao),
    ),
    BlocProvider<TermsBloc>(
      create: (context) => TermsBloc(_factoryDao, _authBloc),
    ),
    BlocProvider<CollaborateBloc>(
      create: (context) => CollaborateBloc(_factoryDao, _raceBloc, _authBloc),
    ),
  ], child: App(_factoryDao.routeService)));
}
