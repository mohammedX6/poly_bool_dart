// MIT License

import 'intersector.dart';
import 'segment_chainer.dart';
import 'segment_selector.dart';
import 'types.dart';

typedef Selector = SegmentList Function(CombinedSegmentLists);

class PolyBool {
  var log;

  SegmentList segments(RegionPolygon poly) {
    var i = new Intersecter(true);

    for (var region in poly.regions!) {
      i.addRegion(region);
    }

    var result = i.calculate(inverted: poly.inverted);
    result.inverted = poly.inverted;

    return result;
  }

  CombinedSegmentLists combine(SegmentList segments1, SegmentList segments2) {
    var i = new Intersecter(
      false,
    );

    return new CombinedSegmentLists(
        combined: i.calculateXD(
            segments1, segments1.inverted, segments2, segments2.inverted),
        inverted1: segments1.inverted,
        inverted2: segments2.inverted);
  }

  SegmentList selectUnion(CombinedSegmentLists combined) {
    var result = SegmentSelector.union(combined.combined!, log);
    result.inverted = combined.inverted1 || combined.inverted2;

    return result;
  }

  SegmentList selectIntersect(CombinedSegmentLists combined) {
    var result = SegmentSelector.intersect(
      combined.combined!,
      log,
    );
    result.inverted = combined.inverted1 && combined.inverted2;

    return result;
  }

  SegmentList selectDifference(CombinedSegmentLists combined) {
    var result = SegmentSelector.difference(combined.combined!, log);
    result.inverted = combined.inverted1 && !combined.inverted2;

    return result;
  }

  SegmentList selectDifferenceRev(CombinedSegmentLists combined) {
    var result = SegmentSelector.differenceRev(combined.combined!, log);
    result.inverted = !combined.inverted1 && combined.inverted2;

    return result;
  }

  SegmentList selectXor(CombinedSegmentLists combined) {
    var result = SegmentSelector.xor(combined.combined!, log);
    result.inverted = combined.inverted1 != combined.inverted2;

    return result;
  }

  RegionPolygon polygon(SegmentList segments) {
    //missing log
    var chain = new SegmentChainer().chain(segments);

    return new RegionPolygon(regions: chain, inverted: segments.inverted);
  }

  RegionPolygon union(RegionPolygon poly1, RegionPolygon poly2) {
    return _operate(poly1, poly2, selectUnion);
  }

  RegionPolygon intersect(RegionPolygon poly1, RegionPolygon poly2) {
    return _operate(poly1, poly2, selectIntersect);
  }

  RegionPolygon difference(RegionPolygon poly1, RegionPolygon poly2) {
    return _operate(poly1, poly2, selectDifference);
  }

  RegionPolygon differenceRev(RegionPolygon poly1, RegionPolygon poly2) {
    return _operate(poly1, poly2, selectDifferenceRev);
  }

  RegionPolygon xor(RegionPolygon poly1, RegionPolygon poly2) {
    return _operate(poly1, poly2, selectXor);
  }

  RegionPolygon _operate(
      RegionPolygon poly1, RegionPolygon poly2, Selector selector) {
    var seg1 = segments(poly1);
    var seg2 = segments(poly2);
    var comb = combine(seg1, seg2);

    var seg3 = selector(comb);

    return polygon(seg3);
  }
}
