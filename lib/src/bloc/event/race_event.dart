abstract class RaceEvent{
}

class RaceEventEmpty extends RaceEvent{
  @override
  String toString() => 'Empty Event';
}

class InitRaceFieldsEvent extends RaceEvent{
  @override
  String toString() => 'InitRaceFieldsEvent Event';
}

class ClickOnMapEvent extends RaceEvent{
  final String id;

  ClickOnMapEvent(this.id);
  @override
  String toString() => 'ClickOnMap Event';
}

class UpdateRaceFieldsEvent extends RaceEvent{
  @override
  String toString() => 'UpdateRaceFields Event';
}