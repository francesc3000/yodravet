import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yodravet/src/dao/factory_dao.dart';
import 'package:bloc/bloc.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
import 'package:yodravet/src/model/race.dart';
import 'package:yodravet/src/model/researcher.dart';
import 'package:yodravet/src/model/stage_building.dart';
import 'package:yodravet/src/shared/race_map_factory.dart';

import 'event/race_event.dart';
import 'state/race_state.dart';

class RaceBloc extends Bloc<RaceEvent, RaceState> {
  Race _race = Race();
  double _stageDayLeft = 0;
  final FactoryDao factoryDao;
  List<ActivityPurchase> _buyers = [];
  RaceMapFactory _raceMapFactory = RaceMapFactory();
  StageBuilding _currentStageBuilding;
  StageBuilding _currentMouseStageBuilding;
  List<StageBuilding> _stagesBuilding = [
    StageBuilding('Stage1', 'C.I. Príncipe Felipe', 'C.I. Príncipe Felipe',
        'assets/race/stages/centrofelipe.png', [
      Researcher(
          'Máximo Ibo Galindo',
          'Medicina de precisión mediante la utilización de modelo Drosophila.',
          'assets/race/stages/researchers/maximoibogalindo.png',
          'https://www.indrenetwork.com/es/proyectos/medicina-precision-sindrome-dravet'),
      Researcher(
          'Isabel del Pino',
          'Mecanismos de excitabilidad neuronal intrínseca y actividad espontánea subyacentes a las alteraciones de la corteza cerebral.',
           'assets/race/stages/researchers/isabelpino.png',
          'https://www.indrenetwork.com/es/proyectos/mecanismos-excitabilidad-neuronal-intrinseca-actividad-espontanea-subyacentes-alteraciones-corteza-cerebral-deficiencia-nr2f1-coup-tf1'),
    ]),
    StageBuilding(
      'Stage2',
      'Centro Andaluz de Biologia Molecular y Medicina Regenerativa',
      'CABIMER',
      'assets/race/stages/cabimer.png',
      [
        Researcher(
            'Manuel Álvarez Dolado',
            'Terapia Celular Mediante Precursores Neuronales Gabaérgicos para Encefalopatías Epilépticas Infantiles (S. Dravet, S. West y S. Stxbp1).',
            'assets/race/stages/researchers/manuelalvarezdolado.png',
            'https://www.indrenetwork.com/es/proyectos/terapia-celular-mediante-precursores-neuronales-gabaergicos-encefalopatias-epilepticas-infantiles-sdravet-swest-sstxbp1'),
      ],
    ),
    StageBuilding(
      'Stage3.1',
      'Facultad Medicina Madrid',
      'Facultad Medicina Madrid',
      'assets/race/stages/fmedicinamadrid.png',
      [
        Researcher(
            'Onintza Sagredo',
            'Estudio del sistema cannbinoideo en el Síndrome de Dravet.',
            'assets/race/stages/researchers/onintzasagredo.png',
            'https://www.indrenetwork.com/es/proyectos/estudio-sistema-cannabinoide-sindrome-dravet'),
      ],
    ),
    StageBuilding(
      'Stage3.2',
      'Hospital Ruber Internacional Madrid',
      'H.Ruber',
      'assets/race/stages/rubermadrid.png',
      [
        Researcher(
            'Antonio Gil-Nagel Rein',
            'Ensayos clínicos. Investigación clínica. Estudios de imagen.',
            'assets/race/stages/researchers/antoniogilnagelrein.png',
            'https://www.indrenetwork.com/es/grupos-investigacion/unidad-epilepsia-hospital-ruber-internacional'),
      ],
    ),
    StageBuilding(
      'Stage3.3',
      'Universidad Nebrija',
      'U.Nebrija',
      'assets/race/stages/universidadnebrija.png',
      [
        Researcher(
            'Jon Andoni Duñabeitia',
            'Caracterización del desarrollo cognitivo en el Síndrome de Dravet.',
            'assets/race/stages/researchers/jonandonidunabeitia.png',
            'https://www.indrenetwork.com/es/grupos-investigacion/centro-ciencia-cognitiva-c3'),
      ],
    ),
    StageBuilding(
      'Stage4',
      'Facultad de Ciencias de la Salud Campus Oza Universidad A Coruña',
      'Uni. A Coruña',
      'assets/race/stages/universidadacoruna.png',
      [
        Researcher(
            'Juan Casto Rivadulla',
            'Efecto de campos magnéticos estáticos de intensidad moderada en modelos de epilepsia y síndrome de Dravet.',
            'assets/race/stages/researchers/juancastorivadulla.png',
            'https://www.indrenetwork.com/es/proyectos/efecto-campos-magneticos-estaticos-intensidad-moderada-modelos-epilepsia-sindrome-dravet'),
      ],
    ),
    StageBuilding(
      'Stage5.1',
      'Biocruces Health Research Institute',
      'Biocruces',
      'assets/race/stages/biocruces.png',
      [
        Researcher(
            'Paolo Bonifazi',
            'Neuroimagen computacional.',
            'assets/race/stages/researchers/paolobonifazi.png',
            'https://www.indrenetwork.com/es/grupos-investigacion/computational-neuroimaging-lab'),
      ],
    ),
    StageBuilding(
      'Stage5.2',
      'Achucarro Basque Center for Neuroscience',
      'Achucarro',
      'assets/race/stages/achucarro.png',
      [
        Researcher(
            'Juan Manuel Encinas',
            'Neurogénesis y Gliogénesis Reactiva en un Modelo de Síndrome de Dravet.',
            'assets/race/stages/researchers/juanmanuelencinas.png',
            'https://www.indrenetwork.com/es/proyectos/neurogenesis-gliogenesis-reactiva-modelo-sindrome-dravet'),
        Researcher(
          'Jan Tonnesen',
          'Investigación de la epilepsia mediante imágenes de súper resolución de las sinapsis y del espacio extracelular en tejido cerebral vivo.',
          'assets/race/stages/researchers/jantonnensen.png',
          'https://www.indrenetwork.com/es/proyectos/investigacion-epilepsia-mediante-imagenes-super-resolucion-sinapsis-espacio-extracelular-tejido-cerebral-vivo',
        ),
      ],
    ),
    StageBuilding(
      'Stage6',
      'Biobide',
      'Biobide',
      'assets/race/stages/biobide.png',
      [
        Researcher(
            'Ainhoa Alzualde',
            'Caracterización de la línea de pez cebra didys552 (mutante del gen snc1lab) y puesta a punto del ensayo de screening de eficacia con drogas de referencia.',
            'assets/race/stages/researchers/ainhoaalzualde.png',
            'https://www.indrenetwork.com/es/proyectos/caracterizacion-linea-pez-cebra-didys552-mutante-gen-snc1lab-puesta-punto-ensayo-screening-eficacia-drogas-referencia'),
      ],
    ),
    StageBuilding(
      'Stage7.1',
      'Universitat Pompeu Fabra',
      'Uni. Pompeu Fabra',
      'assets/race/stages/pompeufabra.png',
      [
        Researcher(
            'Sandra Acosta',
            'Organoides cerebrales en encefalopatías epilépticas. Neurogenética funcional.',
            'assets/race/stages/researchers/sandraacosta.png',
            'https://www.indrenetwork.com/es/grupos-investigacion/neurogenetica-funcional'),
      ],
    ),
    StageBuilding(
      'Stage7.2',
      "Vall d'Hebron",
      "Vall d'Hebron",
      'assets/race/stages/vallhebron.png',
      [
        Researcher(
            'Victor Puntes',
            'Nanopartículas anti-oxidantes y anti-inflamatorias para proteger contra la hiper-actividad y mitigar el daño post-crisis.',
            'assets/race/stages/researchers/victorpuntes.png',
            'https://www.indrenetwork.com/es/proyectos/nanoparticulas-anti-oxidantes-anti-inflamatorias-proteger-contra-hiper-actividad-mitigar-dano-post-crisis'),
      ],
    ),
    StageBuilding(
      'Stage8',
      'Ajuntament de Sant Feliu de Llobregat',
      'Ajuntament Sant Feliu',
      'assets/race/stages/ajsantfeliu.png',
      [
        Researcher(
          'Asociació Esportiva Yo Corro por el Dravet',
          'Ciudad de la sede de la Asociación Esportiva yo corro por el Dravet y punto de salida de la cursa virtual Dravet Tour y de llegada el día 23 junio dia internacional del sindrome de Dravet.',
          'assets/race/logoYocorro.png',
          '',
        )
      ],
    ),
  ];

  RaceBloc(this.factoryDao);

  @override
  RaceState get initialState => RaceInitState();

  @override
  Stream<RaceState> mapEventToState(RaceEvent event) async* {
    if (event is InitRaceFieldsEvent) {
      try {
        this
            .factoryDao
            .raceDao
            .streamRaceInfo('2021DravetTour')
            .listen((race) async {
          this._race.kmCounter = race.kmCounter;
          this._race.stageCounter = race.stageCounter;
          this._race.extraCounter = race.extraCounter;
          this._race.stage = race.stage;
          this._race.stageLimit = race.stageLimit;
          this._race.stageTitle = race.stageTitle;
          this._race.startDate = race.startDate;
          this._race.nextStageDate = race.nextStageDate;
          Duration leftDuration = this._race.startDate.isAfter(DateTime.now()) ? Duration(days: 0)
                                  : this._race.nextStageDate.difference(DateTime.now());
          int inDays = leftDuration.inDays <= 0 ? 0 : leftDuration.inDays;
          _stageDayLeft = inDays.toDouble();

          await _raceMapFactory.init(
              this._race.stage, 
              this._race.startDate,
              this._race.nextStageDate);

          this.add(UpdateRaceFieldsEvent());
        });

        this.factoryDao.raceDao.streamBuyers('2021DravetTour').listen((buyers) {
          //Se consolidan los compradores
          this._buyers.clear();
          buyers.forEach((buyer) {
            var mainBuyerList = this._buyers.where(
                (mainBuyer) => mainBuyer.userId.compareTo(buyer.userId) == 0);

            if (mainBuyerList.isEmpty ||
                mainBuyerList.first.userId.compareTo('anonymous') == 0) {
              this._buyers.add(buyer);
            } else {
              var mainBuyer = mainBuyerList.first;
              mainBuyer.distance = mainBuyer.distance + buyer.distance;
              mainBuyer.totalPurchase =
                  mainBuyer.totalPurchase + buyer.totalPurchase;
            }
          });
          //Ordenamos por compra total
          this._buyers.sort((a, b) {
            return a.compareTo(b);
          });

          this.add(UpdateRaceFieldsEvent());
        });

        yield _updateRaceFieldsEvent();
      } catch (error) {
        yield error is RaceStateError
            ? RaceStateError(error.message)
            : RaceStateError('Algo fue mal al recoger los Km!');
      }
    } else if (event is UpdateRaceFieldsEvent) {
      yield _updateRaceFieldsEvent();
    } else if (event is ClickOnMapEvent) {
      try {
        _currentStageBuilding = _stagesBuilding.firstWhere(
            (stageBuilding) => stageBuilding.id.compareTo(event.id) == 0);

        yield _updateRaceFieldsEvent();
      } catch (error) {
        yield error is RaceStateError
            ? RaceStateError(error.message)
            : RaceStateError('Algo fue mal al clickar sobre el mapa');
      }
    } else if (event is BackClickOnMapEvent) {
      _currentStageBuilding = null;

      yield _updateRaceFieldsEvent();
    } else if (event is MouseOnEnterEvent) {
      try {
        _currentMouseStageBuilding = _stagesBuilding.firstWhere(
            (stageBuilding) => stageBuilding.id.compareTo(event.id) == 0);

        yield _updateRaceFieldsEvent();
      } catch (error) {
        yield error is RaceStateError
            ? RaceStateError(error.message)
            : RaceStateError('Algo fue mal al pasar sobre el mapa');
      }
    } else if (event is MouseOnExitEvent) {
      _currentMouseStageBuilding = null;

      yield _updateRaceFieldsEvent();
    }
  }

  RaceState _updateRaceFieldsEvent() {
    return UpdateRaceFieldsState(
      kmCounter: _race.kmCounter,
      stageCounter: _race.stageCounter,
      extraCounter: _race.extraCounter,
      stageLimit: _race.stageLimit,
      stageTitle: _race.stageTitle,
      stageDayLeft: _stageDayLeft,
      riveArtboard: _raceMapFactory.riveArtboard,
      buyers: _buyers,
      currentStageBuilding: _currentStageBuilding,
      currentMouseStageBuilding: _currentMouseStageBuilding,
      stagesBuilding: _stagesBuilding,
    );
  }
}
