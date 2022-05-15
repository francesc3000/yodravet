abstract class HomeEvent{
}

class HomeEventEmpty extends HomeEvent{
  @override
  String toString() => 'Empty Event';
}

class ChangeTabEvent extends HomeEvent {
  int index;

  ChangeTabEvent(this.index);
  @override
  String toString() => 'ChangeTabEvent Event';
}

class Navigate2UserPageEvent extends HomeEvent {
  @override
  String toString() => 'Navigate2UserPage Event';
}

class HomeStaticEvent extends HomeEvent {
  @override
  String toString() => 'HomeStaticEvent Event';
}

class HomeInitDataEvent extends HomeEvent {
  @override
  String toString() => 'HomeInitData Event';
}

class ChangeMuteOptionEvent extends HomeEvent {
  @override
  String toString() => 'ChangeMuteOption Event';
}