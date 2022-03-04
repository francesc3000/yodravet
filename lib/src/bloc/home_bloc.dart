import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:yodravet/src/dao/factory_dao.dart';

import 'event/home_event.dart';
import 'session_bloc.dart';
import 'state/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  int _currentIndex = 0;
  final FactoryDao factoryDao;
  SessionBloc session;
  // User _user = User();
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  bool _isMusicOn = true;

  HomeBloc(this.session, this.factoryDao) : super(HomeInitState()) {
    // session.stream.listen((state) {
    //   if (state is LogInState) {
    //     if (state.isSignedIn) {
    //       _user = session.user;
    //     }
    //   } else if (state is UserChangeState) {
    //     _user = state.user;
    //   }
    // });

    on<HomeEventEmpty>((event, emit) => emit(HomeInitState()));
    on<ChangeTabEvent>(_changeTabEvent);
    on<Navigate2UserPageEvent>(_navigate2UserPageEvent);
    on<HomeStaticEvent>(_homeStaticEvent);
    on<HomeInitDataEvent>(_homeInitDataEvent);
    on<ChangeMuteOptionEvent>(_changeMuteOptionEvent);
  }

  void _changeTabEvent(ChangeTabEvent event, Emitter emit) async {
    try {
      _currentIndex = event.index;
      emit(_uploadHomeFields());
    } catch (error) {
      emit(error is HomeStateError
          ? HomeStateError(error.message)
          : HomeStateError('Algo fue mal en el AutoLogIn!'));
    }
  }

  void _navigate2UserPageEvent(
      Navigate2UserPageEvent event, Emitter emit) async {
    emit(Navigate2UserPageState());
  }

  void _homeStaticEvent(HomeStaticEvent event, Emitter emit) async {
    emit(_uploadHomeFields());
  }

  void _homeInitDataEvent(HomeInitDataEvent event, Emitter emit) async {
    _assetsAudioPlayer.open(
      Audio("assets/music/gisela_hidalgo.mp3"),
      showNotification: false,
    );

    _assetsAudioPlayer.setLoopMode(LoopMode.single);

    _assetsAudioPlayer.loopMode.listen((loopMode){
      //listen to loop
    });

    _assetsAudioPlayer.play();

    emit(_uploadHomeFields());
  }

  void _changeMuteOptionEvent(ChangeMuteOptionEvent event, Emitter emit) {
    if(_isMusicOn) {
      _assetsAudioPlayer.pause();
    } else {
      _assetsAudioPlayer.play();
    }
    _isMusicOn = !_isMusicOn;

    emit(_uploadHomeFields());
  }

  HomeState _uploadHomeFields() =>
      UploadHomeFields(index: _currentIndex, isMusicOn: _isMusicOn);
}
