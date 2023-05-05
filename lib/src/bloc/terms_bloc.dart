import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yodravet/src/bloc/auth_bloc.dart';
import 'package:yodravet/src/bloc/event/auth_event.dart';
import 'package:yodravet/src/bloc/event/terms_event.dart';
import 'package:yodravet/src/bloc/state/terms_state.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/user.dart' as myUser;

class TermsBloc extends Bloc<TermsEvent, TermsState> {
  final FactoryDao factoryDao;
  final AuthBloc authBloc;

  TermsBloc(this.factoryDao, this.authBloc)
      : super(TermsInitState()) {

    on<StartTermsEvent>(_startTermsEvent);
    on<RejectTermsEvent>(_rejectTermsEvent);
    on<AcceptTermsEvent>(_acceptTermsEvent);
  }

  void _startTermsEvent(StartTermsEvent event, Emitter emit) {
    emit(_uploadTermsFields());
  }

  void _rejectTermsEvent(RejectTermsEvent event, Emitter emit) {
    authBloc.add(TermsRejectedEvent());
  }

  void _acceptTermsEvent(AcceptTermsEvent event, Emitter emit) {
    factoryDao.userDao.acceptUserTerms(_getUser()!.id!);
    authBloc.add(TermsAcceptedEvent());
  }

  myUser.User? _getUser() => authBloc.getUser();

  TermsState _uploadTermsFields() => UploadTermsFields();
}
