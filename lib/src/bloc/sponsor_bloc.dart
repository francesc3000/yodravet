import 'package:bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/collaborator.dart';

import 'event/sponsor_event.dart';
import 'state/sponsor_state.dart';

class SponsorBloc extends Bloc<SponsorEvent, SponsorState> {
  final FactoryDao factoryDao;
  List<Collaborator>? _sponsors;
  List<Collaborator>? _promoters;

  SponsorBloc(this.factoryDao) : super(SponsorInitState()) {
    on<SponsorInitDataEvent>(_sponsorInitDataEvent);
    on<Navigate2WebsiteEvent>(_navigate2WebsiteEvent);
  }

  void _sponsorInitDataEvent(SponsorInitDataEvent event, Emitter emit) async {
    _sponsors = [];
    _promoters = [];
    List<Collaborator> _collaborators =
        await factoryDao.collaboratorDao.getCollaborators();

    for (var collaborator in _collaborators) {
      if (collaborator.type == CollaboratorType.sponsor) {
        _sponsors!.add(collaborator);
      } else {
        _promoters!.add(collaborator);
      }
    }

    emit(_uploadSponsorFields());
  }

  void _navigate2WebsiteEvent(Navigate2WebsiteEvent event, Emitter emit) {
    try {
      Collaborator sponsor =
          _sponsors!.firstWhere((sponsor) => sponsor.id == event.sponsorId);
      launch(sponsor.website);
    } on StateError catch (_) {}
  }

  SponsorState _uploadSponsorFields() =>
      UploadSponsorFields(sponsors: _sponsors!, promoters: _promoters!);
}
