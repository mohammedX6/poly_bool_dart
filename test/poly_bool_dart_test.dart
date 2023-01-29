//@dart=2.11
import 'package:poly_bool_dart/coordinate.dart';
import 'package:poly_bool_dart/polybool.dart';
import 'package:poly_bool_dart/types.dart';
import 'package:test/test.dart';

void main() {
  test('Two partially overlapping squares', () {
    final p10 = Coordinate(1, 1);
    final p11 = Coordinate(10, 1);
    final p12 = Coordinate(10, 10);
    final p13 = Coordinate(1, 10);
    RegionPolygon poly1 = RegionPolygon(regions: [
      [p10, p11, p12, p13, p10],
    ]);

    final p20 = Coordinate(-4, -4);
    final p21 = Coordinate(4, -4);
    final p22 = Coordinate(4, 4);
    final p23 = Coordinate(-4, 4);
    RegionPolygon poly2 = RegionPolygon(regions: [
      [p20, p21, p22, p23, p20],
    ]);

    CombinedSegmentLists combine(RegionPolygon poly1, RegionPolygon poly2) {
      final seg1 = PolyBool().segments(poly1);
      final seg2 = PolyBool().segments(poly2);
      return PolyBool().combine(seg1, seg2);
    }

    final comb = combine(poly1, poly2);
    print('${comb.combined.delegate}');

    // Self-union is identity.
    expect(
        PolyBool()
            .polygon(PolyBool().selectUnion(combine(poly1, poly1)))
            .regions
            .first,
        unorderedEquals(poly1.regions.first.sublist(0, 4)));
    print('start');
    final union = PolyBool().polygon(PolyBool().selectUnion(comb));
    expect(
        union.regions.first,
        unorderedEquals([
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
    expect(
        PolyBool()
            .polygon(PolyBool().selectIntersect(combine(poly1, poly1)))
            .regions
            .first,
        unorderedEquals(poly1.regions.first.sublist(0, 4)));
    final intersect = PolyBool().polygon(PolyBool().selectIntersect(comb));
    expect(
        intersect.regions.first,
        unorderedEquals([
          Coordinate(4.0, 4.0),
          Coordinate(4.0, 1.0),
          Coordinate(1.0, 1.0),
          Coordinate(1.0, 4.0),
        ]));

    // Self-difference is empty.
    expect(
        PolyBool()
            .polygon(PolyBool().selectDifference(combine(poly1, poly1)))
            .regions,
        equals([]));
    final difference = PolyBool().polygon(PolyBool().selectDifference(comb));
    expect(
        difference.regions.first,
        unorderedEquals([
          Coordinate(10.0, 10.0),
          Coordinate(10.0, 1.0),
          Coordinate(4.0, 1.0),
          Coordinate(4.0, 4.0),
          Coordinate(1.0, 4.0),
          Coordinate(1.0, 10.0)
        ]));

    // Self-difference is empty.
    expect(
        PolyBool()
            .polygon(PolyBool().selectDifferenceRev(combine(poly1, poly1)))
            .regions,
        equals([]));
    final differenceRev =
        PolyBool().polygon(PolyBool().selectDifferenceRev(comb));
    expect(
        differenceRev.regions.first,
        unorderedEquals([
          Coordinate(4.0, 1.0),
          Coordinate(4.0, -4.0),
          Coordinate(-4.0, -4.0),
          Coordinate(-4.0, 4.0),
          Coordinate(1.0, 4.0),
          Coordinate(1.0, 1.0),
        ]));
    // Make sure -(P1 - P2) == (P2 - P1).
    expect(
        differenceRev.regions.first,
        equals(PolyBool()
            .polygon(PolyBool().selectDifference(combine(poly2, poly1)))
            .regions
            .first));

    // Self-XOR is empty.
    expect(
        PolyBool().polygon(PolyBool().selectXor(combine(poly1, poly1))).regions,
        equals([]));
    final xor = PolyBool().polygon(PolyBool().selectXor(comb));
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

  test('basic_test', () {
    // Note you can use Multipolygon also :)

    RegionPolygon poly1 = RegionPolygon(regions: [
      [
        Coordinate(37.27935791015625, 29.32472016151103),
        Coordinate(37.122802734375, 29.257648503615542),
        Coordinate(37.22442626953125, 29.135369220927156),
        Coordinate(37.36175537109374, 29.221699149280646),
        Coordinate(37.27935791015625, 29.32472016151103)
      ],
    ]);

    RegionPolygon poly2 = RegionPolygon(regions: [
      [
        Coordinate(37.104949951171875, 29.159357041355424),
        Coordinate(37.1722412109375, 29.046565622728846),
        Coordinate(37.31781005859375, 29.105376571809618),
        Coordinate(37.20794677734375, 29.216904948184734),
        Coordinate(37.104949951171875, 29.159357041355424),
      ]
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
    print(result['union'].regions);
    print('*********');
    print(result['intersect'].regions);
    print('*********');
    print(result['difference'].regions);
    print('*********');
    print(result['differenceRev'].regions);
    print('*********');
    print(result['xor'].regions);
    print('*********');
  });
}
