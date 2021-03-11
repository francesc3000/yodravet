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

class HomeLogOutEvent extends HomeEvent {
  @override
  String toString() => 'HomeLogOut Event';
}