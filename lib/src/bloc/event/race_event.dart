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

class BackClickOnMapEvent extends RaceEvent{
  @override
  String toString() => 'BackClickOnMap Event';
}

class MouseOnEnterEvent extends RaceEvent{
  final String id;

  MouseOnEnterEvent(this.id);
  @override
  String toString() => 'MouseOnEnter Event';
}

class MouseOnExitEvent extends RaceEvent{
  @override
  String toString() => 'MouseOnExitEvent Event';
}

class UpdateRaceFieldsEvent extends RaceEvent{
  @override
  String toString() => 'UpdateRaceFields Event';
}

class ChangeMapSelectedEvent extends RaceEvent{
  @override
  String toString() => 'ChangeMapSelected Event';
}