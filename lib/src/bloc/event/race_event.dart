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

class AutoMapChange4ArgentinaEvent extends RaceEvent{
  @override
  String toString() => 'AutoMapChange4Argentina Event';
}

class AutoMapChange4SpainEvent extends RaceEvent{
  @override
  String toString() => 'AutoMapChange4Spain Event';
}

class PurchaseButterfliesEvent extends RaceEvent{
  @override
  String toString() => 'PurchaseButterflies Event';
}

class PurchaseSongEvent extends RaceEvent{
  @override
  String toString() => 'PurchaseSongEvent Event';
}

class GetSpotsEvent extends RaceEvent{
  @override
  String toString() => 'GetSpots Event';
}