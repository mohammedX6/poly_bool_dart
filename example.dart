import 'package:dart_jts/dart_jts.dart' as JTS;
import 'package:flutter/material.dart';
import 'package:poly_bool_dart/polybool.dart';
import 'package:poly_bool_dart/types.dart';
import 'package:latlong2/latlong.dart';

class Example {
  void test() {
    RegionPolygon poly1 = RegionPolygon(regions: [
      [LatLng(50, 50), LatLng(150, 150), LatLng(190, 50)]
          .map((c) => JTS.Coordinate(
              double.parse(c.longitude.toStringAsFixed(6)),
              double.parse(c.latitude.toStringAsFixed(6))))
          .toList(),
      [LatLng(130, 50), LatLng(290, 150), LatLng(290, 50)]
          .map((c) => JTS.Coordinate(
              double.parse(c.longitude.toStringAsFixed(6)),
              double.parse(c.latitude.toStringAsFixed(6))))
          .toList(),
    ]);

    RegionPolygon poly2 = RegionPolygon(regions: [
      [LatLng(110, 20), LatLng(110, 110), LatLng(20, 20)]
          .map((c) => JTS.Coordinate(
              double.parse(c.longitude.toStringAsFixed(6)),
              double.parse(c.latitude.toStringAsFixed(6))))
          .toList(),
      [LatLng(130, 170), LatLng(130, 20), LatLng(260, 170)]
          .map((c) => JTS.Coordinate(
              double.parse(c.longitude.toStringAsFixed(6)),
              double.parse(c.latitude.toStringAsFixed(6))))
          .toList(),
    ]);

    var seg1 = PolyBool().segments(poly1);
    var seg2 = PolyBool().segments(poly2);
    var comb = PolyBool().combine(seg1, seg2);
    var result = {
      'union': PolyBool().polygon(PolyBool().selectUnion(comb)),
      'intersect': PolyBool().polygon(PolyBool().selectIntersect(comb)),
      'difference': PolyBool().polygon(PolyBool().selectDifference(comb)),
      'differenceRev': PolyBool().polygon(PolyBool().selectDifferenceRev(comb)),
      'xor': PolyBool().polygon(PolyBool().selectXor(comb))
    };

  }
}
