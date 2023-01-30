import 'package:poly_bool_dart/coordinate.dart';
import 'package:poly_bool_dart/polybool.dart';
import 'package:poly_bool_dart/types.dart';

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}

void example() {
  final poly1 = Polygon(regions: [
    [LatLng(50, 50), LatLng(150, 150), LatLng(190, 50)]
        .map((c) => Coordinate(double.parse(c.longitude.toStringAsFixed(6)),
            double.parse(c.latitude.toStringAsFixed(6))))
        .toList(),
    [LatLng(130, 50), LatLng(290, 150), LatLng(290, 50)]
        .map((c) => Coordinate(double.parse(c.longitude.toStringAsFixed(6)),
            double.parse(c.latitude.toStringAsFixed(6))))
        .toList(),
  ]);

  final poly2 = Polygon(regions: [
    [LatLng(110, 20), LatLng(110, 110), LatLng(20, 20)]
        .map((c) => Coordinate(double.parse(c.longitude.toStringAsFixed(6)),
            double.parse(c.latitude.toStringAsFixed(6))))
        .toList(),
    [LatLng(130, 170), LatLng(130, 20), LatLng(260, 170)]
        .map((c) => Coordinate(double.parse(c.longitude.toStringAsFixed(6)),
            double.parse(c.latitude.toStringAsFixed(6))))
        .toList(),
  ]);

  print('union: ${poly1.union(poly2).regions}');
  print('intersection: ${poly1.intersect(poly2).regions}');
  print('difference: ${poly1.difference(poly2).regions}');
  print('inverse difference: ${poly1.differenceRev(poly2).regions}');
  print('xor: ${poly1.xor(poly2).regions}');
}

void main() {
  example();
}
