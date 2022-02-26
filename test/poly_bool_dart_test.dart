import 'package:flutter_test/flutter_test.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:poly_bool_dart/polybool.dart';
import 'package:poly_bool_dart/types.dart';

void main() {
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
