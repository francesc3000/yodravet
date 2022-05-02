import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:yodravet/src/model/buyer.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/researcher.dart';
import 'package:yodravet/src/model/stage_building.dart';
import 'package:yodravet/src/shared/edition.dart';
import 'package:yodravet/src/shared/race_map_factory.dart';

import 'event/race_event.dart';
import 'state/race_state.dart';

class RaceBloc extends Bloc<RaceEvent, RaceState> {
  Race? _race;
  double _stageDayLeft = 0;
  final FactoryDao factoryDao;
  final List<Buyer> _buyers = [];
  final RaceMapFactory _raceMapFactory = RaceMapFactory();
  StageBuilding? _currentStageBuilding;
  StageBuilding? _currentMouseStageBuilding;
  bool _isSpainMapSelected = true;
  final List<StageBuilding> _spainStagesBuilding = [
    StageBuilding('Stage1', 'C.I. Príncipe Felipe', 'C.I. Príncipe Felipe',
        'assets/images/race/stages/centrofelipe.png', [
      Researcher(
          'Máximo Ibo Galindo',
          'Medicina de precisión mediante la utilización de modelo Drosophila.',
          'assets/images/race/stages/researchers/maximoibogalindo.png',
          'https://www.indrenetwork.com/es/proyectos/medicina-precision-sindrome-dravet'),
      Researcher(
          'Isabel del Pino',
          'Mecanismos de excitabilidad neuronal intrínseca y actividad espontánea subyacentes a las alteraciones de la corteza cerebral.',
          'assets/images/race/stages/researchers/isabelpino.png',
          'https://www.indrenetwork.com/es/proyectos/mecanismos-excitabilidad-neuronal-intrinseca-actividad-espontanea-subyacentes-alteraciones-corteza-cerebral-deficiencia-nr2f1-coup-tf1'),
    ]),
    StageBuilding(
      'Stage2',
      'Centro Andaluz de Biologia Molecular y Medicina Regenerativa',
      'CABIMER',
      'assets/images/race/stages/cabimer.png',
      [
        Researcher(
            'Manuel Álvarez Dolado',
            'Terapia Celular Mediante Precursores Neuronales Gabaérgicos para Encefalopatías Epilépticas Infantiles (S. Dravet, S. West y S. Stxbp1).',
            'assets/images/race/stages/researchers/manuelalvarezdolado.png',
            'https://www.indrenetwork.com/es/proyectos/terapia-celular-mediante-precursores-neuronales-gabaergicos-encefalopatias-epilepticas-infantiles-sdravet-swest-sstxbp1'),
      ],
    ),
    StageBuilding(
      'Stage4.1',
      'Facultad Medicina Madrid',
      'Facultad Medicina Madrid',
      'assets/images/race/stages/fmedicinamadrid.png',
      [
        Researcher(
            'Onintza Sagredo',
            'Estudio del sistema cannbinoideo en el Síndrome de Dravet.',
            'assets/images/race/stages/researchers/onintzasagredo.png',
            'https://www.indrenetwork.com/es/proyectos/estudio-sistema-cannabinoide-sindrome-dravet'),
      ],
    ),
    StageBuilding(
      'Stage4.2',
      'Hospital Ruber Internacional Madrid',
      'H.Ruber',
      'assets/images/race/stages/rubermadrid.png',
      [
        Researcher(
            'Antonio Gil-Nagel Rein',
            'Ensayos clínicos. Investigación clínica. Estudios de imagen.',
            'assets/images/race/stages/researchers/antoniogilnagelrein.png',
            'https://www.indrenetwork.com/es/grupos-investigacion/unidad-epilepsia-hospital-ruber-internacional'),
      ],
    ),
    StageBuilding(
      'Stage4.3',
      'Universidad Nebrija',
      'U.Nebrija',
      'assets/images/race/stages/universidadnebrija.png',
      [
        Researcher(
            'Jon Andoni Duñabeitia',
            'Caracterización del desarrollo cognitivo en el Síndrome de Dravet.',
            'assets/images/race/stages/researchers/jonandonidunabeitia.png',
            'https://www.indrenetwork.com/es/grupos-investigacion/centro-ciencia-cognitiva-c3'),
      ],
    ),
    StageBuilding(
      'Stage5',
      'Facultad de Ciencias de la Salud Campus Oza Universidad A Coruña',
      'Uni. A Coruña',
      'assets/images/race/stages/universidadacoruna.png',
      [
        Researcher(
            'Juan Casto Rivadulla',
            'Efecto de campos magnéticos estáticos de intensidad moderada en modelos de epilepsia y síndrome de Dravet.',
            'assets/images/race/stages/researchers/juancastorivadulla.png',
            'https://www.indrenetwork.com/es/proyectos/efecto-campos-magneticos-estaticos-intensidad-moderada-modelos-epilepsia-sindrome-dravet'),
      ],
    ),
    StageBuilding(
      'Stage6.1',
      'Biocruces Health Research Institute',
      'Biocruces',
      'assets/images/race/stages/biocruces.png',
      [
        Researcher(
            'Paolo Bonifazi',
            'Neuroimagen computacional.',
            'assets/images/race/stages/researchers/paolobonifazi.png',
            'https://www.indrenetwork.com/es/grupos-investigacion/computational-neuroimaging-lab'),
      ],
    ),
    StageBuilding(
      'Stage6.2',
      'Achucarro Basque Center for Neuroscience',
      'Achucarro',
      'assets/images/race/stages/achucarro.png',
      [
        Researcher(
            'Juan Manuel Encinas',
            'Neurogénesis y Gliogénesis Reactiva en un Modelo de Síndrome de Dravet.',
            'assets/images/race/stages/researchers/juanmanuelencinas.png',
            'https://www.indrenetwork.com/es/proyectos/neurogenesis-gliogenesis-reactiva-modelo-sindrome-dravet'),
        Researcher(
          'Jan Tonnesen',
          'Investigación de la epilepsia mediante imágenes de súper resolución de las sinapsis y del espacio extracelular en tejido cerebral vivo.',
          'assets/images/race/stages/researchers/jantonnensen.png',
          'https://www.indrenetwork.com/es/proyectos/investigacion-epilepsia-mediante-imagenes-super-resolucion-sinapsis-espacio-extracelular-tejido-cerebral-vivo',
        ),
      ],
    ),
    StageBuilding(
      'Stage7',
      'Biobide',
      'Biobide',
      'assets/images/race/stages/biobide.png',
      [
        Researcher(
            'Ainhoa Alzualde',
            'Caracterización de la línea de pez cebra didys552 (mutante del gen snc1lab) y puesta a punto del ensayo de screening de eficacia con drogas de referencia.',
            'assets/images/race/stages/researchers/ainhoaalzualde.png',
            'https://www.indrenetwork.com/es/proyectos/caracterizacion-linea-pez-cebra-didys552-mutante-gen-snc1lab-puesta-punto-ensayo-screening-eficacia-drogas-referencia'),
      ],
    ),
    StageBuilding(
      'Stage8.1',
      'Universitat de Barcelona',
      'U.B.',
      'assets/images/race/stages/ub.png',
      [
        Researcher(
            'Sandra Acosta',
            'Organoides cerebrales en encefalopatías epilépticas. Neurogenética funcional.',
            'assets/images/race/stages/researchers/sandraacosta.png',
            'https://www.indrenetwork.com/es/grupos-investigacion/neurogenetica-funcional'),
      ],
    ),
    StageBuilding(
      'Stage8.2',
      "Vall d'Hebron",
      "Vall d'Hebron",
      'assets/images/race/stages/vallhebron.png',
      [
        Researcher(
            'Victor Puntes',
            'Nanopartículas anti-oxidantes y anti-inflamatorias para proteger contra la hiper-actividad y mitigar el daño post-crisis.',
            'assets/images/race/stages/researchers/victorpuntes.png',
            'https://www.indrenetwork.com/es/proyectos/nanoparticulas-anti-oxidantes-anti-inflamatorias-proteger-contra-hiper-actividad-mitigar-dano-post-crisis'),
      ],
    ),
    StageBuilding(
      'Stage9',
      'Ajuntament de Sant Feliu de Llobregat',
      'Ajuntament Sant Feliu',
      'assets/images/race/stages/ajsantfeliu.png',
      [
        Researcher(
          'Asociació Esportiva Yo Corro por el Dravet',
          'Ciudad de la sede de la Asociación Esportiva yo corro por el Dravet y punto de salida de la cursa virtual Dravet Tour y de llegada el día 23 junio dia internacional del sindrome de Dravet.',
          // 'assets/images/race/logoYoCorro.png',
          'assets/images/race/stages/researchers/victorpuntes.png',
          '',
        )
      ],
    ),
  ];

  final List<StageBuilding> _argentinaStagesBuilding = [
    StageBuilding(
        'Stage3',
        'Universidad De la Plata. Laboratorio de investigación y desarrollo de bioactivos (LIDeB)',
        'Uni. De la Plata',
        'assets/images/race/stages/uni_plata.png', [
      Researcher(
          'Alan Talevi',
          'Diseño de bloqueantes altamente selectivos de canales NaV1.2 y NaV1.6 (sin efecto sobre canales NaV1.1). La idea es diseñar nuevos fármacos específicamente concebidos para tratar Dravet, que no interactúen con el canal de sodio cuya mutación usualmente está asociada a la enfermedad. Servicio de monitoreo de fármacos anticonvulsivantes usualmente utilizados en la terapéutica del síndrome de Dravet, el cual será accesible a la comunidad Dravet Argentina con la posibilidad de envío de muestras por correo postal.',
          'assets/images/race/stages/researchers/alantalevi.png',
          ''),
    ]),
  ];

  RaceBloc(this.factoryDao) : super(RaceInitState()) {
    on<InitRaceFieldsEvent>(_initRaceFieldsEvent);
    on<UpdateRaceFieldsEvent>(_updateRaceFieldsEvent);
    on<ClickOnMapEvent>(_clickOnMapEvent);
    on<BackClickOnMapEvent>(_backClickOnMapEvent);
    on<MouseOnEnterEvent>(_mouseOnEnterEvent);
    on<MouseOnExitEvent>(_mouseOnExitEvent);
    on<ChangeMapSelectedEvent>(_changeMapSelectedEvent);
    on<AutoMapChange4ArgentinaEvent>(_autoMapChange4ArgentinaEvent);
    on<AutoMapChange4SpainEvent>(_autoMapChange4SpainEvent);
  }

  void _initRaceFieldsEvent(InitRaceFieldsEvent event, Emitter emit) async {
    String editionId = Edition.currentEdition;
    try {
      factoryDao.raceDao.streamRaceInfo(editionId).listen((race) async {
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
            );
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

      factoryDao.raceDao.streamBuyers(editionId).listen((buyers) {
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

      _isSpainMapSelected = true;

      emit(_updateRaceFields());
    } catch (error) {
      emit(error is RaceStateError
          ? RaceStateError(error.message)
          : RaceStateError('Algo fue mal al recoger los Km!'));
    }
  }

  void _updateRaceFieldsEvent(UpdateRaceFieldsEvent event, Emitter emit) async {
    emit(_updateRaceFields());
  }

  void _clickOnMapEvent(ClickOnMapEvent event, Emitter emit) async {
    try {
      try {
        _currentStageBuilding = _spainStagesBuilding.firstWhere(
                (stageBuilding) => stageBuilding.id.compareTo(event.id) == 0);
      } on StateError catch(_) {
        _currentStageBuilding = _argentinaStagesBuilding.firstWhere(
                (stageBuilding) => stageBuilding.id.compareTo(event.id) == 0);
      }

      emit(_updateRaceFields());
    } catch (error) {
      emit(error is RaceStateError
          ? RaceStateError(error.message)
          : RaceStateError('Algo fue mal al clickar sobre el mapa'));
    }
  }

  void _backClickOnMapEvent(BackClickOnMapEvent event, Emitter emit) async {
    _currentStageBuilding = null;

    emit(_updateRaceFields());
  }

  void _mouseOnEnterEvent(MouseOnEnterEvent event, Emitter emit) async {
    try {
      try {
        _currentMouseStageBuilding = _spainStagesBuilding.firstWhere(
                (stageBuilding) => stageBuilding.id.compareTo(event.id) == 0);
      } on StateError catch(_) {
        _currentMouseStageBuilding = _argentinaStagesBuilding.firstWhere(
                (stageBuilding) => stageBuilding.id.compareTo(event.id) == 0);
      }

      emit(_updateRaceFields());
    } catch (error) {
      emit(error is RaceStateError
          ? RaceStateError(error.message)
          : RaceStateError('Algo fue mal al pasar sobre el mapa'));
    }
  }

  void _mouseOnExitEvent(MouseOnExitEvent event, Emitter emit) async {
    _currentMouseStageBuilding = null;

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

  RaceState _updateRaceFields() => UpdateRaceFieldsState(
        kmCounter: _race!.kmCounter,
        stageCounter: _race!.stageCounter,
        extraCounter: _race!.extraCounter,
        stageLimit: _race!.stageLimit,
        stageTitle: _race!.stageTitle,
        stageDayLeft: _stageDayLeft,
        riveArtboardSpain: _raceMapFactory.riveArtboardSpain,
        riveArtboardArgentina: _raceMapFactory.riveArtboardArgentina,
        buyers: _buyers,
        currentStageBuilding: _currentStageBuilding,
        currentMouseStageBuilding: _currentMouseStageBuilding,
        spainStagesBuilding: _spainStagesBuilding,
        argentinaStagesBuilding: _argentinaStagesBuilding,
        isSpainMapSelected: _isSpainMapSelected,
        isRaceOver: _race!.isOver,
      );
}
