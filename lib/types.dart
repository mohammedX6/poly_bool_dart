

import 'package:quiver/collection.dart';

import 'coordinate.dart';
import 'linked_list.dart';
import 'segment_fill.dart';

class Transition {
  EventNode? before;
  EventNode? after;
  StatusNode? prev;
  StatusNode? here;

  Transition({this.before, this.after, this.prev, this.here});
}

class Intersection {
  static Intersection Empty = new Intersection();

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
  Coordinate? pt;

  /// <summary>
  /// where intersection point is along A
  /// </summary>
  double? alongA;

  /// <summary>
  /// where intersection point is along B
  /// </summary>
  double? alongB;

  Intersection({this.alongA, this.alongB, this.pt});
}

class RegionPolygon {
  List<List<Coordinate>>? regions;
  bool inverted;

  RegionPolygon({this.regions, this.inverted = false});
}

class SegmentList extends DelegatingList<Segment?> {
  final List<Segment> _segments = [];
  bool inverted = false;

  List<Segment> get delegate => _segments;

// custom methods
}

class CombinedSegmentLists {
  SegmentList? combined;
  bool inverted1;
  bool inverted2;

  CombinedSegmentLists(
      {this.combined, this.inverted1 = false, this.inverted2 = false});
}

// class PointList extends DelegatingList<Coordinate> {
//   final List<Coordinate> _points = [];
//
//   List<Coordinate> get delegate => _points;
// }

class Segment {
  int id = -1;
  Coordinate? start;
  Coordinate? end;
  SegmentFill? myFill;
  SegmentFill? otherFill;

  Segment({this.id = -1, this.start, this.end, this.myFill, this.otherFill}) {
    if (myFill == null) myFill = SegmentFill();
  }
}
