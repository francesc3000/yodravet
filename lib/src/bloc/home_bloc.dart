import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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

  HomeBloc(this.session, this.factoryDao) {
    this.session.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          this._user = this.session.user;
          if (!state.isAutoLogin) {
            this.add(Navigate2UserPageEvent());
          }
        }
      } else if (state is LogOutState) {
        this._user.logout();
        this.add(HomeLogOutEvent());
      } else if (state is UserChangeState) {
        this._user = state.user;
      }
    });
  }

  @override
  HomeState get initialState => HomeInitState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeEventEmpty) {
      yield HomeInitState();
    } else if (event is ChangeTabEvent) {
      try {
        _currentIndex = event.index;
        if (!this._user.isLogin) {
          yield Navigate2LoginState();
        } else {
          yield _uploadHomeFields(index: _currentIndex);
        }
      } catch (error) {
        yield error is HomeStateError
            ? HomeStateError(error.message)
            : HomeStateError('Algo fue mal en el AutoLogIn!');
      }
    } else if (event is Navigate2UserPageEvent) {
      if (!this._user.isLogin) {
        yield Navigate2LoginState();
      } else {
        yield Navigate2UserPageState();
      }
    } else if (event is Navigate2LoginSuccessEvent) {
      yield Navigate2LoginSuccess();
    } else if (event is HomeLogOutEvent) {
      yield HomeLogOutState();
    } else if (event is HomeStaticEvent) {
      yield _uploadHomeFields(index: _currentIndex);
    }
  }

  HomeState _uploadHomeFields({@required int index}) {
    return UploadHomeFields(index: index);
  }
}
