import 'package:bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/sponsor.dart';

import 'event/sponsor_event.dart';
import 'state/sponsor_state.dart';

class SponsorBloc extends Bloc<SponsorEvent, SponsorState> {
  final FactoryDao factoryDao;
  List<Sponsor>? _sponsors;
  List<Sponsor>? _promoters;

  SponsorBloc(this.factoryDao) : super(SponsorInitState()) {
    on<SponsorInitDataEvent>(_sponsorInitDataEvent);
    on<Navigate2WebsiteEvent>(_navigate2WebsiteEvent);
  }

  void _sponsorInitDataEvent(SponsorInitDataEvent event, Emitter emit) async {
    _sponsors = [];
    _promoters = [];
    _promoters!.add(Sponsor(
        id: "1",
        name: "2 Set",
        logoPath: "assets/images/sponsors/2set.jpeg",
        website: "https://2set.com",
        type: SponsorType.promoter));

    _sponsors!.add(Sponsor(
        id: "2",
        name: "Apoyo Dravet",
        logoPath: "assets/images/sponsors/apoyo_dravet.jpeg",
        website: "https://apoyodravet.com"));

    _sponsors!.add(Sponsor(
        id: "3",
        name: "Indre",
        logoPath: "assets/images/sponsors/indre.jpeg",
        website: "https://indre.com"));

    emit(_uploadSponsorFields());
  }

  void _navigate2WebsiteEvent(Navigate2WebsiteEvent event, Emitter emit) {
    try {
      Sponsor sponsor =
          _sponsors!.firstWhere((sponsor) => sponsor.id == event.sponsorId);
      launch(sponsor.website);
    } on StateError catch (_) {}
  }

  SponsorState _uploadSponsorFields() =>
      UploadSponsorFields(sponsors: _sponsors!, promoters: _promoters!);
}
