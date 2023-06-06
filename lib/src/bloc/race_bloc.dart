import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yodravet/src/bloc/interface/session_interface.dart';
import 'package:yodravet/src/bloc/state/session_state.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/race_spot.dart';
import 'package:yodravet/src/model/researcher.dart';
import 'package:yodravet/src/model/spot.dart';
import 'package:yodravet/src/model/user.dart';
import 'package:yodravet/src/shared/edition.dart';
import 'package:yodravet/src/shared/race_map_factory.dart';

import 'event/race_event.dart';
import 'state/race_state.dart';

class RaceBloc extends Bloc<RaceEvent, RaceState> {
  Race? _race;
  double _stageDayLeft = 0;
  final FactoryDao factoryDao;
  final Session session;
  StreamSubscription? _sessionSubscription;
  StreamSubscription? _raceInfoSubscription;
  StreamSubscription? _buyersSubscription;
  StreamSubscription? _raceSpotSubscription;
  StreamSubscription? _spotVotesSubscription;
  final List<Buyer> _buyers = [];
  final List<RaceSpot> _raceSpots = [];
  late List<String> _spotVotes;
  final RaceMapFactory _raceMapFactory = RaceMapFactory();
  User? _user;
  Spot? _currentSpot;
  Spot? _currentMouseSpot;
  bool _canVote = false;
  bool _hasVote = false;
  bool _isSpainMapSelected = true;
  final List<Spot> _spainStagesBuilding = [
    Spot('Stage1', 'C.I. Príncipe Felipe', 'C.I. Príncipe Felipe',
        'assets/images/race/stages/centrofelipe.webp', 0.47, 0.57, 190, 340, [
      Researcher(
          'Máximo Ibo Galindo',
          'Medicina de precisión mediante la utilización de modelo Drosophila.',
          'assets/images/race/stages/researchers/maximoibogalindo.webp',
          'https://www.indrenetwork.com/es/proyectos/medicina-precision-sindrome-dravet'),
      Researcher(
          'Isabel del Pino',
          'Mecanismos de excitabilidad neuronal intrínseca y actividad espontánea subyacentes a las alteraciones de la corteza cerebral.',
          'assets/images/race/stages/researchers/isabelpino.webp',
          'https://www.indrenetwork.com/es/proyectos/mecanismos-excitabilidad-neuronal-intrinseca-actividad-espontanea-subyacentes-alteraciones-corteza-cerebral-deficiencia-nr2f1-coup-tf1'),
    ]),
    Spot(
      'Stage2',
      'Centro Andaluz de Biologia Molecular y Medicina Regenerativa',
      'CABIMER',
      'assets/images/race/stages/cabimer.webp',
      0.74,
      0.12,
      310,
      100,
      [
        Researcher(
            'Manuel Álvarez Dolado',
            'Terapia Celular Mediante Precursores Neuronales Gabaérgicos para Encefalopatías Epilépticas Infantiles (S. Dravet, S. West y S. Stxbp1).',
            'assets/images/race/stages/researchers/manuelalvarezdolado.webp',
            'https://www.indrenetwork.com/es/proyectos/terapia-celular-mediante-precursores-neuronales-gabaergicos-encefalopatias-epilepticas-infantiles-sdravet-swest-sstxbp1'),
      ],
    ),
    Spot(
      'Stage4.1',
      'Facultad Medicina Madrid',
      'Facultad Medicina Madrid',
      'assets/images/race/stages/fmedicinamadrid.webp',
      0.41,
      0.37,
      160,
      230,
      [
        Researcher(
            'Onintza Sagredo',
            'Estudio del sistema cannbinoideo en el Síndrome de Dravet.',
            'assets/images/race/stages/researchers/onintzasagredo.webp',
            'https://www.indrenetwork.com/es/proyectos/estudio-sistema-cannabinoide-sindrome-dravet'),
      ],
    ),
    Spot(
      'Stage4.2',
      'Hospital Ruber Internacional Madrid',
      'H.Ruber',
      'assets/images/race/stages/rubermadrid.webp',
      0.34,
      0.27,
      130,
      190,
      [
        Researcher(
            'Antonio Gil-Nagel Rein',
            'Ensayos clínicos. Investigación clínica. Estudios de imagen.',
            'assets/images/race/stages/researchers/antoniogilnagelrein.webp',
            'https://www.indrenetwork.com/es/grupos-investigacion/unidad-epilepsia-hospital-ruber-internacional'),
      ],
    ),
    Spot(
      'Stage4.3',
      'Universidad Nebrija',
      'U.Nebrija',
      'assets/images/race/stages/universidadnebrija.webp',
      0.24,
      0.38,
      110,
      235,
      [
        Researcher(
            'Jon Andoni Duñabeitia',
            'Caracterización del desarrollo cognitivo en el Síndrome de Dravet.',
            'assets/images/race/stages/researchers/jonandonidunabeitia.webp',
            'https://www.indrenetwork.com/es/grupos-investigacion/centro-ciencia-cognitiva-c3'),
        Researcher(
            'Rafael Salom Borras',
            'Especializado en Psicología General de la Salud, ha desempeñado diversas funciones en la investigación.',
            'assets/images/race/stages/researchers/rafaelsalom.webp',
            'https://www.indrenetwork.com/es/grupos-investigacion/centro-ciencia-cognitiva-c3'),
      ],
    ),
    Spot(
      'Stage5',
      'Facultad de Ciencias de la Salud Campus Oza Universidad A Coruña',
      'Uni. A Coruña',
      'assets/images/race/stages/universidadacoruna.webp',
      0.06,
      0.00,
      17,
      0.00,
      [
        Researcher(
            'Juan Casto Rivadulla',
            'Efecto de campos magnéticos estáticos de intensidad moderada en modelos de epilepsia y síndrome de Dravet.',
            'assets/images/race/stages/researchers/juancastorivadulla.webp',
            'https://www.indrenetwork.com/es/proyectos/efecto-campos-magneticos-estaticos-intensidad-moderada-modelos-epilepsia-sindrome-dravet'),
      ],
    ),
    Spot(
      'Stage6.1',
      'Biocruces Health Research Institute',
      'Biocruces',
      'assets/images/race/stages/biocruces.webp',
      0.03,
      0.24,
      10,
      180,
      [
        Researcher(
            'Paolo Bonifazi',
            'Neuroimagen computacional.',
            'assets/images/race/stages/researchers/paolobonifazi.webp',
            'https://www.indrenetwork.com/es/grupos-investigacion/computational-neuroimaging-lab'),
      ],
    ),
    Spot(
      'Stage6.2',
      'Achucarro Basque Center for Neuroscience',
      'Achucarro',
      'assets/images/race/stages/achucarro.webp',
      0.08,
      0.38,
      23,
      228,
      [
        Researcher(
            'Juan Manuel Encinas',
            'Neurogénesis y Gliogénesis Reactiva en un Modelo de Síndrome de Dravet.',
            'assets/images/race/stages/researchers/juanmanuelencinas.webp',
            'https://www.indrenetwork.com/es/proyectos/neurogenesis-gliogenesis-reactiva-modelo-sindrome-dravet'),
        Researcher(
          'Jan Tonnesen',
          'Investigación de la epilepsia mediante imágenes de súper resolución de las sinapsis y del espacio extracelular en tejido cerebral vivo.',
          'assets/images/race/stages/researchers/jantonnensen.webp',
          'https://www.indrenetwork.com/es/proyectos/investigacion-epilepsia-mediante-imagenes-super-resolucion-sinapsis-espacio-extracelular-tejido-cerebral-vivo',
        ),
      ],
    ),
    Spot(
      'Stage7',
      'Sede ApoyoDravet',
      'Sede ApoyoDravet',
      'assets/images/race/stages/apoyodravet.webp',
      0.07,
      0.51,
      19,
      278,
      [
        Researcher(
            'Antonio Villalón',
            'Nuevo director general de ApoyoDravet. Padre de afectada de síndrome de Dravet. Actual vicepresidente de la Federación Española de Epilepsia. Delegado de ApoyoDravet en Andalucía. Sin duda, su perfil profesional orientado a la administración en el mundo empresarial y su implicación en el tercer sector constituyen una garantía de éxito para el liderazgo de ApoyoDravet.',
            'assets/images/race/stages/researchers/antoniovillalon.webp',
            'https://www.apoyodravet.eu/'),
      ],
    ),
    Spot(
      'Stage8.1',
      'Universitat de Barcelona',
      'U.B.',
      'assets/images/race/stages/ub.webp',
      0.29,
      0.74,
      100,
      440,
      [
        Researcher(
            'Sandra Acosta',
            'Organoides cerebrales en encefalopatías epilépticas. Neurogenética funcional.',
            'assets/images/race/stages/researchers/sandraacosta.webp',
            'https://www.indrenetwork.com/es/grupos-investigacion/neurogenetica-funcional'),
      ],
    ),
    Spot(
      'Stage8.2',
      "Vall d'Hebron",
      "Vall d'Hebron",
      'assets/images/race/stages/vallhebron.webp',
      0.12,
      0.76,
      50,
      440,
      [
        Researcher(
            'Victor Puntes',
            'Nanopartículas anti-oxidantes y anti-inflamatorias para proteger contra la hiper-actividad y mitigar el daño post-crisis.',
            'assets/images/race/stages/researchers/victorpuntes.webp',
            'https://www.indrenetwork.com/es/proyectos/nanoparticulas-anti-oxidantes-anti-inflamatorias-proteger-contra-hiper-actividad-mitigar-dano-post-crisis'),
      ],
    ),
    Spot(
      'Stage9',
      'Ajuntament de Sant Feliu de Llobregat',
      'Ajuntament Sant Feliu',
      'assets/images/race/stages/ajsantfeliu.webp',
      0.25,
      0.6,
      90,
      379,
      [
        Researcher(
          'Asociació Esportiva Yo Corro por el Dravet',
          'Ciudad de la sede de la Asociación Esportiva yo corro por el Dravet y punto de salida de la cursa virtual Dravet Tour y de llegada el día 23 junio día internacional del sindrome de Dravet.',
          'assets/images/race/logoYoCorro.webp',
          // 'assets/images/race/stages/researchers/victorpuntes.webp',
          '',
        )
      ],
    ),
  ];

  final List<Spot> _argentinaStagesBuilding = [
    Spot(
        'Stage3',
        'Universidad De la Plata. Laboratorio de investigación y desarrollo de bioactivos (LIDeB)',
        'Uni. De la Plata',
        'assets/images/race/stages/uni_plata.webp',
        0.29,
        0.49,
        100,
        220, [
      Researcher(
          'Alan Talevi',
          'Diseño de bloqueantes altamente selectivos de canales NaV1.2 y NaV1.6 (sin efecto sobre canales NaV1.1). La idea es diseñar nuevos fármacos específicamente concebidos para tratar Dravet, que no interactúen con el canal de sodio cuya mutación usualmente está asociada a la enfermedad. Servicio de monitoreo de fármacos anticonvulsivantes usualmente utilizados en la terapéutica del síndrome de Dravet, el cual será accesible a la comunidad Dravet Argentina con la posibilidad de envío de muestras por correo postal.',
          'assets/images/race/stages/researchers/alantalevi.webp',
          ''),
    ]),
    Spot(
        'Stage4',
        'Universidad De Playa Ancha',
        'Uni. De Playa Ancha',
        'assets/images/race/stages/universidadchile.webp',
        0.17,
        0.17,
        85,
        140, [
      Researcher(
          'Alejandro Martin',
          'La síntesis de análogos de Estiripentol y Cannabidiol para mejorar sus propiedades y reducir efectos adversos. Se utilizan sustratos naturales y reacciones de química orgánica asistida por ultrasonido o microondas. Los análogos se evaluan por separado en condiciones in vitro y los más potentes se utilizan en modelos in vivo.',
          'assets/images/race/stages/researchers/alejandromadrid.webp',
          ''),
    ]),
  ];

  RaceBloc(this.session, this.factoryDao) : super(RaceInitState()) {
    _sessionSubscription = session.stream.listen((state) {
      if (state is LogInState) {
        if (state.isSignedIn) {
          _user = session.user;
          _canVote = true;

          add(StreamRaceVotesEvent());
        }
      } else if (state is LogOutState) {
        _user = null;
        _canVote = false;
      } else if (state is UserChangeState) {
        _user = session.user;
      } else if (state is StravaLogInSuccessState) {}
    });

    _user = session.user;
    _spotVotes = [];
    _canVote = true;

    on<InitRaceFieldsEvent>(_initRaceFieldsEvent);
    on<UpdateRaceFieldsEvent>(_updateRaceFieldsEvent);
    on<ClickOnMapEvent>(_clickOnMapEvent);
    on<BackClickOnMapEvent>(_backClickOnMapEvent);
    on<MouseOnEnterEvent>(_mouseOnEnterEvent);
    on<MouseOnExitEvent>(_mouseOnExitEvent);
    on<ChangeMapSelectedEvent>(_changeMapSelectedEvent);
    on<AutoMapChange4ArgentinaEvent>(_autoMapChange4ArgentinaEvent);
    on<AutoMapChange4SpainEvent>(_autoMapChange4SpainEvent);
    on<PurchaseButterfliesEvent>(_purchaseButterfliesEvent);
    on<PurchaseSongEvent>(_purchaseSongEvent);
    on<StreamRaceVotesEvent>(_streamRaceVotesEvent);
    on<SpotVoteThumbUpEvent>(_spotVoteThumbUpEvent);
    on<SpotVoteThumbDownEvent>(_spotVoteThumbDownEvent);
    on<RaceDateLoadedEvent>(_raceDateLoadedEvent);
    on<ShareCartelaEvent>(_shareCartelaEvent);
  }

  void _initRaceFieldsEvent(InitRaceFieldsEvent event, Emitter emit) async {
    String raceId = Edition.currentEdition;
    try {
      _raceInfoSubscription =
          factoryDao.raceDao.streamRaceInfo(raceId).listen((race) async {
        if (race != null) {
          if (_race == null) {
            _race = Race(
              kmCounter: race.kmCounter,
              stageCounter: race.stageCounter,
              extraCounter: race.extraCounter,
              stage: race.stage,
              stageLimit: race.stageLimit,
              stageTitle: race.stageTitle,
              startDate: race.startDate,
              finalDate: race.finalDate,
              nextStageDate: race.nextStageDate,
              purchaseButterfliesSite: race.purchaseButterfliesSite,
              purchaseSongSite: race.purchaseSongSite,
            );
            add(RaceDateLoadedEvent());
          } else {
            _race!.kmCounter = race.kmCounter;
            _race!.stageCounter = race.stageCounter;
            _race!.extraCounter = race.extraCounter;
            _race!.stage = race.stage;
            _race!.stageLimit = race.stageLimit;
            _race!.stageTitle = race.stageTitle;
            _race!.startDate = race.startDate;
            _race!.finalDate = race.finalDate;
            _race!.nextStageDate = race.nextStageDate;
          }

          Duration leftDuration = _race!.startDate.isAfter(DateTime.now())
              ? const Duration(days: 0)
              : _race!.nextStageDate.difference(DateTime.now());
          int inDays = leftDuration.inDays <= 0 ? 0 : leftDuration.inDays;
          _stageDayLeft = inDays.toDouble();

          await _raceMapFactory.init(
              _race!.stage, _race!.startDate, _race!.nextStageDate);

          if (_raceMapFactory.isArgentinaActive4AutoChange) {
            add(AutoMapChange4ArgentinaEvent());
          }

          if (_raceMapFactory.isSpainActive4AutoChange) {
            add(AutoMapChange4SpainEvent());
          }

          add(UpdateRaceFieldsEvent());
        }
      });

      _buyersSubscription =
          factoryDao.raceDao.streamBuyers(raceId).listen((buyers) {
        //Se consolidan los compradores
        _buyers.clear();
        for (var buyer in buyers) {
          var mainBuyerList = _buyers.where(
              (mainBuyer) => mainBuyer.userId.compareTo(buyer.userId) == 0);

          if (mainBuyerList.isEmpty ||
              mainBuyerList.first.userId.compareTo('anonymous') == 0) {
            _buyers.add(buyer);
          } else {
            var mainBuyer = mainBuyerList.first;
            mainBuyer.butterfly = mainBuyer.butterfly + buyer.butterfly;
            mainBuyer.totalPurchase =
                mainBuyer.totalPurchase + buyer.totalPurchase;
          }
        }
        //Ordenamos por compra total
        _buyers.sort((a, b) => a.compareTo(b));

        add(UpdateRaceFieldsEvent());
      });

      _raceSpotSubscription =
          factoryDao.raceDao.streamRaceSpot(raceId).listen((raceSpot) {
        _raceSpots.clear();
        _raceSpots.addAll(raceSpot);
        add(UpdateRaceFieldsEvent());
      });

      _isSpainMapSelected = true;

      if(_race!=null) {
        emit(_updateRaceFields());
      }
    } catch (error) {
      emit(error is RaceStateError
          ? RaceStateError(error.message)
          : RaceStateError('Algo fue mal al recoger los Km!'));
    }
  }

  void _streamRaceVotesEvent(StreamRaceVotesEvent event, Emitter emit) {
    String raceId = Edition.currentEdition;
    _spotVotesSubscription = factoryDao.userDao
        .streamSpotVotes(_user!.id!, raceId)
        .listen((spotVotes) {
      _spotVotes.clear();
      _spotVotes.addAll(spotVotes);

      if (spotVotes.isEmpty) {
        _hasVote = true;
      } else {
        _hasVote = false;
      }

      add(UpdateRaceFieldsEvent());
    });
  }

  void _updateRaceFieldsEvent(UpdateRaceFieldsEvent event, Emitter emit) async {
    emit(_updateRaceFields());
  }

  void _clickOnMapEvent(ClickOnMapEvent event, Emitter emit) async {
    try {
      try {
        _currentSpot = _spainStagesBuilding
            .firstWhere((spot) => spot.id.compareTo(event.id) == 0);
      } on StateError catch (_) {
        _currentSpot = _argentinaStagesBuilding
            .firstWhere((spot) => spot.id.compareTo(event.id) == 0);
      }

      emit(_updateRaceFields());
    } catch (error) {
      emit(error is RaceStateError
          ? RaceStateError(error.message)
          : RaceStateError('Algo fue mal al clickar sobre el mapa'));
    }
  }

  void _backClickOnMapEvent(BackClickOnMapEvent event, Emitter emit) async {
    _currentSpot = null;

    emit(_updateRaceFields());
  }

  void _mouseOnEnterEvent(MouseOnEnterEvent event, Emitter emit) async {
    try {
      try {
        _currentMouseSpot = _spainStagesBuilding
            .firstWhere((spot) => spot.id.compareTo(event.id) == 0);
      } on StateError catch (_) {
        _currentMouseSpot = _argentinaStagesBuilding
            .firstWhere((spot) => spot.id.compareTo(event.id) == 0);
      }

      emit(_updateRaceFields());
    } catch (error) {
      emit(error is RaceStateError
          ? RaceStateError(error.message)
          : RaceStateError('Algo fue mal al pasar sobre el mapa'));
    }
  }

  void _mouseOnExitEvent(MouseOnExitEvent event, Emitter emit) async {
    _currentMouseSpot = null;

    emit(_updateRaceFields());
  }

  void _changeMapSelectedEvent(
      ChangeMapSelectedEvent event, Emitter emit) async {
    _isSpainMapSelected = !_isSpainMapSelected;

    emit(_updateRaceFields());
  }

  void _autoMapChange4ArgentinaEvent(
      AutoMapChange4ArgentinaEvent event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 6));
    _isSpainMapSelected = false;

    emit(_updateRaceFields());
  }

  void _autoMapChange4SpainEvent(
      AutoMapChange4SpainEvent event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 13));
    _isSpainMapSelected = true;

    emit(_updateRaceFields());
  }

  void _purchaseButterfliesEvent(PurchaseButterfliesEvent event, Emitter emit) {
    if (_race != null && _race!.purchaseButterfliesSite.isNotEmpty) {
      launchUrl(Uri.parse(_race!.purchaseButterfliesSite));
    }
  }

  void _purchaseSongEvent(PurchaseSongEvent event, Emitter emit) {
    if (_race != null && _race!.purchaseSongSite.isNotEmpty) {
      launchUrl(Uri.parse(_race!.purchaseSongSite));
    }
  }

  void _spotVoteThumbUpEvent(SpotVoteThumbUpEvent event, Emitter emit) async {
    String raceId = Edition.currentEdition;
    if (_user != null) {
      _spotVotes.add(event.spotId);
      await factoryDao.userDao.spotThumbUp(_user!.id!, raceId, event.spotId);

      emit(_updateRaceFields());
    } else {
      emit(RaceStateError("Debes loguearte para poder dar a Me gusta!"));
    }
  }

  void _spotVoteThumbDownEvent(
      SpotVoteThumbDownEvent event, Emitter emit) async {
    String raceId = Edition.currentEdition;
    if (_user != null) {
      _spotVotes.remove(event.spotId);
      await factoryDao.userDao.spotThumbDown(_user!.id!, raceId, event.spotId);

      emit(_updateRaceFields());
    }
  }

  void _raceDateLoadedEvent( RaceDateLoadedEvent event, Emitter emit) async {
      emit(RaceDateLoadedState(_race!));
  }

  void _shareCartelaEvent(ShareCartelaEvent event, Emitter emit) async {
    // Share.shareXFiles([XFile("/assets/images/logo.webp")], text: "Hola");
    Share.share("#YoParticipo  #YoDono\n\nhttps://firebasestorage.googleapis.com/v0/b/yo-corro-por-el-dravet.appspot.com/o/app%2Fcartela2023.jpeg?alt=media&token=357b35ff-d5ba-4d7f-be14-d3cf025dd1bb");
  }

  RaceState _updateRaceFields() => UpdateRaceFieldsState(
        kmCounter: _race?.kmCounter ?? 0,
        stageCounter: _race?.stageCounter ?? 0,
        extraCounter: _race?.extraCounter ?? 0,
        stageLimit: _race?.stageLimit ?? 0,
        stageTitle: _race?.stageTitle ?? "",
        stageDayLeft: _stageDayLeft,
        riveArtboardSpain: _raceMapFactory.riveArtboardSpain,
        riveArtboardArgentina: _raceMapFactory.riveArtboardArgentina,
        buyers: _buyers,
        currentSpot: _currentSpot,
        currentMouseSpot: _currentMouseSpot,
        spainStagesBuilding: _spainStagesBuilding,
        argentinaStagesBuilding: _argentinaStagesBuilding,
        raceSpots: _raceSpots,
        spotVotes: _spotVotes,
        canVote: _canVote,
        hasVote: _hasVote,
        isSpainMapSelected: _isSpainMapSelected,
        isRaceOver: _race?.isOver ?? false,
      );

  Race? getRace() => _race;

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    _raceInfoSubscription?.cancel();
    _buyersSubscription?.cancel();
    _raceSpotSubscription?.cancel();
    _spotVotesSubscription?.cancel();
    return super.close();
  }
}
