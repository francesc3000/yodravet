import 'package:bloc/bloc.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/user.dart';

import 'event/home_event.dart';
import 'session_bloc.dart';
import 'state/home_state.dart';
import 'state/session_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  int _currentIndex = 0;
  final FactoryDao factoryDao;
  SessionBloc session;
  User _user = User();

  HomeBloc(this.session, this.factoryDao) : super(HomeInitState()) {
    session.stream.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          _user = session.user;
          if (!state.isAutoLogin) {
            add(Navigate2UserPageEvent());
          }
        }
      } else if (state is LogOutState) {
        _user.logout();
        add(HomeLogOutEvent());
      } else if (state is UserChangeState) {
        _user = state.user;
      }
    });

    on<HomeEventEmpty>((event, emit) => emit(HomeInitState()));
    on<ChangeTabEvent>(_changeTabEvent);
    on<Navigate2UserPageEvent>(_navigate2UserPageEvent);
    on<Navigate2LoginSuccessEvent>(_navigate2LoginSuccessEvent);
    on<HomeLogOutEvent>(_homeLogOutEvent);
    on<HomeStaticEvent>(_homeStaticEvent);
  }

  void _changeTabEvent(ChangeTabEvent event, Emitter emit) async {
    try {
      _currentIndex = event.index;
      if (!_user.isLogin) {
        emit(Navigate2LoginState());
      } else {
        emit(_uploadHomeFields(index: _currentIndex));
      }
    } catch (error) {
      emit(error is HomeStateError
          ? HomeStateError(error.message)
          : HomeStateError('Algo fue mal en el AutoLogIn!'));
    }
  }

  void _navigate2UserPageEvent(
      Navigate2UserPageEvent event, Emitter emit) async {
    if (!_user.isLogin) {
      emit(Navigate2LoginState());
    } else {
      emit(Navigate2UserPageState());
    }
  }

  void _navigate2LoginSuccessEvent(
      Navigate2LoginSuccessEvent event, Emitter emit) async {
    emit(Navigate2LoginSuccess());
  }

  void _homeLogOutEvent(HomeLogOutEvent event, Emitter emit) async {
    emit(HomeLogOutState());
  }

  void _homeStaticEvent(HomeStaticEvent event, Emitter emit) async {
    emit(_uploadHomeFields(index: _currentIndex));
  }

  HomeState _uploadHomeFields({required int index}) =>
      UploadHomeFields(index: index);
}
