import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/collaborate_event.dart';
import 'package:yodravet/src/bloc/race_bloc.dart';
import 'package:yodravet/src/bloc/state/collaborate_state.dart';
import 'package:yodravet/src/bloc/state/race_state.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/race.dart';

class CollaborateBloc extends Bloc<CollaborateEvent, CollaborateState> {
  final FactoryDao factoryDao;
  final RaceBloc raceBloc;
  final AuthBloc authBloc;
  StreamSubscription? _raceSubscription;
  Race? _race;

  CollaborateBloc(this.factoryDao, this.raceBloc, this.authBloc)
      : super(CollaborateInitState()) {

    _raceSubscription = raceBloc.stream.listen((state) {
      if (state is RaceDateLoadedState) {
        _race = state.race;
      }
    });

    on<StartCollaborateEvent>(_startCollaborateEvent);
    on<MaybeLaterEvent>(_maybeLaterEvent);
    on<ICollaborateEvent>(_iCollaborateEvent);
  }

  // void _collaborateInitState(CollaborateInitState event, Emitter emit) {
  //   emit(_uploadCollaborateFields());
  // }

  void _startCollaborateEvent(StartCollaborateEvent event, Emitter emit) {
    emit(_uploadCollaborateFields());
  }

  void _maybeLaterEvent(MaybeLaterEvent event, Emitter emit) {
    authBloc.add(CollaborateMaybeLaterEvent());
  }

  void _iCollaborateEvent(ICollaborateEvent event, Emitter emit) {
    if (_getRace()!=null) {
      launchUrl(Uri.parse(_race!.purchaseButterfliesSite));
    }
    authBloc.add(CollaborateFinishEvent());
  }

  Race? _getRace() {
    _race ??= raceBloc.getRace();

    return _race;
  }

  CollaborateState _uploadCollaborateFields() => UploadCollaborateFields();

  @override
  Future<void> close() {
    _raceSubscription?.cancel();
    return super.close();
  }
}
