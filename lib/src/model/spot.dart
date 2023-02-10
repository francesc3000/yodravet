import 'package:yodravet/src/model/researcher.dart';

class Spot {
  final String id;
  final String name;
  final String shortName;
  final String photo;
  final List<Researcher> researchers;

  Spot(
      this.id, this.name, this.shortName, this.photo, this.researchers);
}