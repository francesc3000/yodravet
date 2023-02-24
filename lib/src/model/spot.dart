import 'package:yodravet/src/model/researcher.dart';

class Spot {
  final String id;
  final String name;
  final String shortName;
  final String photo;
  final double top;
  final double left;
  final double top720;
  final double left720;
  final List<Researcher> researchers;

  Spot(this.id, this.name, this.shortName, this.photo, this.top, this.left,
      this.top720, this.left720, this.researchers);
}
