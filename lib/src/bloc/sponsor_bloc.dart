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
  List<Collaborator>? _clubs;

  SponsorBloc(this.factoryDao) : super(SponsorInitState()) {
    on<SponsorInitDataEvent>(_sponsorInitDataEvent);
    on<Navigate2SponsorWebsiteEvent>(_navigate2SponsorWebsiteEvent);
    on<Navigate2PromoterWebsiteEvent>(_navigate2PromoterWebsiteEvent);
    on<Navigate2ClubWebsiteEvent>(_navigate2ClubWebsiteEvent);
  }

  void _sponsorInitDataEvent(SponsorInitDataEvent event, Emitter emit) async {
    _sponsors = [];
    _promoters = [];
    _clubs = [];
    List<Collaborator> collaborators =
        await factoryDao.collaboratorDao.getCollaborators();

    for (var collaborator in collaborators) {
      if (collaborator.type == CollaboratorType.sponsor) {
        _sponsors!.add(collaborator);
      } else if (collaborator.type == CollaboratorType.promoter) {
        _promoters!.add(collaborator);
      } else {
        _clubs!.add(collaborator);
      }
    }

    emit(_uploadSponsorFields());
  }

  void _navigate2SponsorWebsiteEvent(
      Navigate2SponsorWebsiteEvent event, Emitter emit) {
    try {
      Collaborator sponsor =
          _sponsors!.firstWhere((sponsor) => sponsor.id == event.sponsorId);
      if (sponsor.website.isNotEmpty) {
        launchUrl(Uri.parse(sponsor.website));
      }
    } on StateError catch (_) {}
  }

  void _navigate2PromoterWebsiteEvent(
      Navigate2PromoterWebsiteEvent event, Emitter emit) {
    try {
      Collaborator promoter =
          _promoters!.firstWhere((promoter) => promoter.id == event.promoterId);
      if (promoter.website.isNotEmpty) {
        launchUrl(Uri.parse(promoter.website));
      }
    } on StateError catch (_) {}
  }

  void _navigate2ClubWebsiteEvent(
      Navigate2ClubWebsiteEvent event, Emitter emit) {
    try {
      Collaborator club = _clubs!.firstWhere((club) => club.id == event.clubId);
      if (club.website.isNotEmpty) {
        launchUrl(Uri.parse(club.website));
      }
    } on StateError catch (_) {}
  }

  SponsorState _uploadSponsorFields() => UploadSponsorFields(
      sponsors: _sponsors!, promoters: _promoters!, clubs: _clubs!);
}
