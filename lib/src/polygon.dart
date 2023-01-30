import 'coordinate.dart';
import 'intersector.dart';
import 'segment_chainer.dart';
import 'segment_selector.dart';
import 'types.dart';

typedef Selector = SegmentList Function(CombinedSegmentLists);

class Polygon {
  final List<List<Coordinate>> regions;
  final bool inverted;

  const Polygon({required this.regions, this.inverted = false});

  Polygon union(Polygon other) {
    return _operate(this, other, _selectUnion);
  }

  Polygon intersect(Polygon other) {
    return _operate(this, other, _selectIntersect);
  }

  Polygon difference(Polygon other) {
    return _operate(this, other, _selectDifference);
  }

  Polygon differenceRev(Polygon other) {
    return _operate(this, other, _selectDifferenceRev);
  }

  Polygon xor(Polygon other) {
    return _operate(this, other, _selectXor);
  }

  static Polygon _operate(Polygon poly1, Polygon poly2, Selector selector) {
    final comb = _combine(_segments(poly1), _segments(poly2));
    final segments = selector(comb);
    var chain = SegmentChainer().chain(segments);
    return Polygon(regions: chain, inverted: segments.inverted);
  }

  static SegmentList _segments(Polygon poly) {
    final i = Intersecter(true);

    for (final region in poly.regions) {
      i.addRegion(region);
    }

    var result = i.calculate(inverted: poly.inverted);
    result.inverted = poly.inverted;

    return result;
  }

  static CombinedSegmentLists _combine(
      SegmentList segments1, SegmentList segments2) {
    final i = Intersecter(false);

    return CombinedSegmentLists(
        combined: i.calculateXD(
            segments1, segments1.inverted, segments2, segments2.inverted),
        inverted1: segments1.inverted,
        inverted2: segments2.inverted);
  }

  static SegmentList _selectUnion(CombinedSegmentLists combined) {
    var result = SegmentSelector.union(combined.combined);
    result.inverted = combined.inverted1 || combined.inverted2;

    return result;
  }

  static SegmentList _selectIntersect(CombinedSegmentLists combined) {
    var result = SegmentSelector.intersect(
      combined.combined,
    );
    result.inverted = combined.inverted1 && combined.inverted2;

    return result;
  }

  static SegmentList _selectDifference(CombinedSegmentLists combined) {
    var result = SegmentSelector.difference(combined.combined);
    result.inverted = combined.inverted1 && !combined.inverted2;

    return result;
  }

  static SegmentList _selectDifferenceRev(CombinedSegmentLists combined) {
    var result = SegmentSelector.differenceRev(combined.combined);
    result.inverted = !combined.inverted1 && combined.inverted2;

    return result;
  }

  static SegmentList _selectXor(CombinedSegmentLists combined) {
    var result = SegmentSelector.xor(combined.combined);
    result.inverted = combined.inverted1 != combined.inverted2;

    return result;
  }
}
