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
        website: "https://www.instagram.com/2setpadel",
        type: SponsorType.promoter));

    _sponsors!.add(Sponsor(
        id: "2",
        name: "Apoyo Dravet",
        logoPath: "assets/images/sponsors/apoyo_dravet.jpeg",
        website: "https://www.apoyodravet.eu/"));

    _sponsors!.add(Sponsor(
        id: "3",
        name: "Indre",
        logoPath: "assets/images/sponsors/indre.jpeg",
        website: "https://www.indrenetwork.com/es"));

    _sponsors!.add(Sponsor(
        id: "4",
        name: "Mar Coronado Ilustració",
        logoPath: "assets/images/sponsors/marcoronadoilustracio.jpeg",
        website: "https://www.instagram.com/invites/contact/"
            "?i=et8ngn1nyro9&utm_content=hthwao"));

    _promoters!.add(Sponsor(
        id: "5",
        name: "Gisela Hidalgo",
        logoPath: "assets/images/sponsors/gisela_hidalgo.jpeg",
        website: "",
        type: SponsorType.promoter));

    _promoters!.add(Sponsor(
        id: "6",
        name: "Actitud Dravet Argentina",
        logoPath: "assets/images/sponsors/dravet_argentina.jpeg",
        website: "",
        type: SponsorType.promoter));

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
