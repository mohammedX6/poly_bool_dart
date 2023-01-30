import 'package:quiver/collection.dart';

import 'coordinate.dart';
import 'linked_list.dart';
import 'segment_fill.dart';

class Transition {
  final EventNode? above;
  final EventNode? below;
  final StatusNode Function() insert;

  Transition({this.above, this.below, required this.insert});
}

class Intersection {
  //  alongA and alongB will each be one of: -2, -1, 0, 1, 2
  //
  //  with the following meaning:
  //
  //    -2   intersection point is before segment's first point
  //    -1   intersection point is directly on segment's first point
  //     0   intersection point is between segment's first and second points (exclusive)
  //     1   intersection point is directly on segment's second point
  //     2   intersection point is after segment's second point

  /// <summary>
  /// where the intersection point is at
  /// </summary>
  final Coordinate pt;

  /// <summary>
  /// where intersection point is along A
  /// </summary>
  double? alongA;

  /// <summary>
  /// where intersection point is along B
  /// </summary>
  double? alongB;

  Intersection({this.alongA, this.alongB, required this.pt});
}

class RegionPolygon {
  final List<List<Coordinate>> regions;
  final bool inverted;

  RegionPolygon({required this.regions, this.inverted = false});
}

class SegmentList extends DelegatingList<Segment> {
  final List<Segment> _segments = [];
  bool inverted = false;

  @override
  List<Segment> get delegate => _segments;
}

class CombinedSegmentLists {
  final SegmentList combined;
  final bool inverted1;
  final bool inverted2;

  CombinedSegmentLists(
      {required this.combined, this.inverted1 = false, this.inverted2 = false});
}

// class PointList extends DelegatingList<Coordinate> {
//   final List<Coordinate> _points = [];
//
//   @override
//   List<Coordinate> get delegate => _points;
// }

class Segment {
  final Coordinate start;
  Coordinate end;
  SegmentFill myFill;
  SegmentFill? otherFill;

  Segment({
    required this.start,
    required this.end,
    required this.myFill,
  });

  @override
  String toString() {
    return '($start, $end)';
  }
}
