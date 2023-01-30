//@dart=2.11
import 'package:poly_bool_dart/coordinate.dart';
import 'package:poly_bool_dart/polybool.dart';
import 'package:poly_bool_dart/types.dart';
import 'package:test/test.dart';

void main() {
  test('Two partially overlapping squares', () {
    final poly1 = Polygon(regions: [
      [
        Coordinate(1, 1),
        Coordinate(10, 1),
        Coordinate(10, 10),
        Coordinate(1, 10),
      ]
    ]);

    final poly2 = Polygon(regions: [
      [
        Coordinate(-4, -4),
        Coordinate(4, -4),
        Coordinate(4, 4),
        Coordinate(-4, 4),
      ]
    ]);

    // Self-union is identity.
    expect(poly1.union(poly1).regions.first,
        unorderedEquals(poly1.regions.first.sublist(0, 4)));
    expect(
        poly1.union(poly2).regions.first,
        orderedEquals([
          Coordinate(10.0, 10.0),
          Coordinate(10.0, 1.0),
          Coordinate(4.0, 1.0),
          Coordinate(4.0, -4.0),
          Coordinate(-4.0, -4.0),
          Coordinate(-4.0, 4.0),
          Coordinate(1.0, 4.0),
          Coordinate(1.0, 10.0),
        ]));

    // Self-intersection is also identity.
    expect(poly1.intersect(poly1).regions.first,
        unorderedEquals(poly1.regions.first.sublist(0, 4)));
    expect(
        poly1.intersect(poly2).regions.first,
        orderedEquals([
          Coordinate(4.0, 4.0),
          Coordinate(4.0, 1.0),
          Coordinate(1.0, 1.0),
          Coordinate(1.0, 4.0),
        ]));

    // Self-difference is empty.
    expect(poly1.difference(poly1).regions, equals([]));
    expect(
        poly1.difference(poly2).regions.first,
        orderedEquals([
          Coordinate(10.0, 10.0),
          Coordinate(10.0, 1.0),
          Coordinate(4.0, 1.0),
          Coordinate(4.0, 4.0),
          Coordinate(1.0, 4.0),
          Coordinate(1.0, 10.0)
        ]));

    // Self-difference is empty.
    expect(poly1.differenceRev(poly1).regions, equals([]));
    expect(
        poly1.differenceRev(poly2).regions.first,
        orderedEquals([
          Coordinate(4.0, 1.0),
          Coordinate(4.0, -4.0),
          Coordinate(-4.0, -4.0),
          Coordinate(-4.0, 4.0),
          Coordinate(1.0, 4.0),
          Coordinate(1.0, 1.0),
        ]));
    //// Make sure -(P1 - P2) == (P2 - P1).
    expect(poly1.differenceRev(poly2).regions.first,
        equals(poly2.difference(poly1).regions.first));

    // Self-XOR is empty.
    expect(poly1.xor(poly1).regions, equals([]));
    final xor = poly1.xor(poly2);
    expect(
        xor.regions.first,
        equals([
          Coordinate(4.0, 1.0),
          Coordinate(4.0, -4.0),
          Coordinate(-4.0, -4.0),
          Coordinate(-4.0, 4.0),
          Coordinate(1.0, 4.0),
          Coordinate(1.0, 1.0),
        ]));
    expect(
        xor.regions.last,
        equals([
          Coordinate(10.0, 10.0),
          Coordinate(10.0, 1.0),
          Coordinate(4.0, 1.0),
          Coordinate(4.0, 4.0),
          Coordinate(1.0, 4.0),
          Coordinate(1.0, 10.0),
        ]));
  });
}
