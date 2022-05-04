
import 'build_log.dart';
//
// filter a list of segments based on boolean operations
//
import 'segment_fill.dart';
import 'types.dart';

class SegmentSelector {
  static select(SegmentList segments, selection, BuildLog? buildLog) {
    var result = new SegmentList();

    segments.forEach((seg) {
      var index = (seg!.myFill!.above! ? 8 : 0) +
          (seg.myFill!.below! ? 4 : 0) +
          ((seg.otherFill != null && seg.otherFill!.above!) ? 2 : 0) +
          ((seg.otherFill != null && seg.otherFill!.below!) ? 1 : 0);

      if (selection[index] != 0) {
        result.add(new Segment(
            id: -1,
            start: seg.start,
            end: seg.end,
            myFill: SegmentFill(
                above: selection[index] == 1, // 1 if filled above
                below: selection[index] == 2 // 2 if filled below
                ),
            otherFill: null));

        // copy the segment to the results, while also calculating the fill status

      }
    });

    return result;
  }

  // primary | secondary
  // above1 below1 above2 below2    Keep?               Value
  //    0      0      0      0   =>   no                  0
  //    0      0      0      1   =>   yes filled below    2
  //    0      0      1      0   =>   yes filled above    1
  //    0      0      1      1   =>   no                  0
  //    0      1      0      0   =>   yes filled below    2
  //    0      1      0      1   =>   yes filled below    2
  //    0      1      1      0   =>   no                  0
  //    0      1      1      1   =>   no                  0
  //    1      0      0      0   =>   yes filled above    1
  //    1      0      0      1   =>   no                  0
  //    1      0      1      0   =>   yes filled above    1
  //    1      0      1      1   =>   no                  0
  //    1      1      0      0   =>   no                  0
  //    1      1      0      1   =>   no                  0
  //    1      1      1      0   =>   no                  0
  //    1      1      1      1   =>   no                  0
  static List<int> union_select_table = [
    0,
    2,
    1,
    0,
    2,
    2,
    0,
    0,
    1,
    0,
    1,
    0,
    0,
    0,
    0,
    0
  ];

  // primary & secondary
  // above1 below1 above2 below2    Keep?               Value
  //    0      0      0      0   =>   no                  0
  //    0      0      0      1   =>   no                  0
  //    0      0      1      0   =>   no                  0
  //    0      0      1      1   =>   no                  0
  //    0      1      0      0   =>   no                  0
  //    0      1      0      1   =>   yes filled below    2
  //    0      1      1      0   =>   no                  0
  //    0      1      1      1   =>   yes filled below    2
  //    1      0      0      0   =>   no                  0
  //    1      0      0      1   =>   no                  0
  //    1      0      1      0   =>   yes filled above    1
  //    1      0      1      1   =>   yes filled above    1
  //    1      1      0      0   =>   no                  0
  //    1      1      0      1   =>   yes filled below    2
  //    1      1      1      0   =>   yes filled above    1
  //    1      1      1      1   =>   no                  0
  static List<int> intersect_select_table = [
    0,
    0,
    0,
    0,
    0,
    2,
    0,
    2,
    0,
    0,
    1,
    1,
    0,
    2,
    1,
    0
  ];

  // primary - secondary
  // above1 below1 above2 below2    Keep?               Value
  //    0      0      0      0   =>   no                  0
  //    0      0      0      1   =>   no                  0
  //    0      0      1      0   =>   no                  0
  //    0      0      1      1   =>   no                  0
  //    0      1      0      0   =>   yes filled below    2
  //    0      1      0      1   =>   no                  0
  //    0      1      1      0   =>   yes filled below    2
  //    0      1      1      1   =>   no                  0
  //    1      0      0      0   =>   yes filled above    1
  //    1      0      0      1   =>   yes filled above    1
  //    1      0      1      0   =>   no                  0
  //    1      0      1      1   =>   no                  0
  //    1      1      0      0   =>   no                  0
  //    1      1      0      1   =>   yes filled above    1
  //    1      1      1      0   =>   yes filled below    2
  //    1      1      1      1   =>   no                  0
  static List<int> difference_select_table = [
    0,
    0,
    0,
    0,
    2,
    0,
    2,
    0,
    1,
    1,
    0,
    0,
    0,
    1,
    2,
    0
  ];

  // secondary - primary
  // above1 below1 above2 below2    Keep?               Value
  //    0      0      0      0   =>   no                  0
  //    0      0      0      1   =>   yes filled below    2
  //    0      0      1      0   =>   yes filled above    1
  //    0      0      1      1   =>   no                  0
  //    0      1      0      0   =>   no                  0
  //    0      1      0      1   =>   no                  0
  //    0      1      1      0   =>   yes filled above    1
  //    0      1      1      1   =>   yes filled above    1
  //    1      0      0      0   =>   no                  0
  //    1      0      0      1   =>   yes filled below    2
  //    1      0      1      0   =>   no                  0
  //    1      0      1      1   =>   yes filled below    2
  //    1      1      0      0   =>   no                  0
  //    1      1      0      1   =>   no                  0
  //    1      1      1      0   =>   no                  0
  //    1      1      1      1   =>   no                  0
  static List<int> differenceRev_select_table = [
    0,
    2,
    1,
    0,
    0,
    0,
    1,
    1,
    0,
    2,
    0,
    2,
    0,
    0,
    0,
    0
  ];

  // primary ^ secondary
  // above1 below1 above2 below2    Keep?               Value
  //    0      0      0      0   =>   no                  0
  //    0      0      0      1   =>   yes filled below    2
  //    0      0      1      0   =>   yes filled above    1
  //    0      0      1      1   =>   no                  0
  //    0      1      0      0   =>   yes filled below    2
  //    0      1      0      1   =>   no                  0
  //    0      1      1      0   =>   no                  0
  //    0      1      1      1   =>   yes filled above    1
  //    1      0      0      0   =>   yes filled above    1
  //    1      0      0      1   =>   no                  0
  //    1      0      1      0   =>   no                  0
  //    1      0      1      1   =>   yes filled below    2
  //    1      1      0      0   =>   no                  0
  //    1      1      0      1   =>   yes filled above    1
  //    1      1      1      0   =>   yes filled below    2
  //    1      1      1      1   =>   no                  0
  static List<int> xor_select_table = [
    0,
    2,
    1,
    0,
    2,
    0,
    0,
    1,
    1,
    0,
    0,
    2,
    0,
    1,
    2,
    0
  ];

  static SegmentList union(SegmentList segments, BuildLog? buildLog) {
    return select(segments, union_select_table, buildLog);
  }

  static SegmentList difference(SegmentList segments, BuildLog? buildLog) {
    return select(segments, difference_select_table, buildLog);
  }

  static SegmentList intersect(SegmentList segments, BuildLog? buildLog) {
    return select(segments, intersect_select_table, buildLog);
  }

  static SegmentList differenceRev(SegmentList segments, BuildLog? buildLog) {
    return select(segments, differenceRev_select_table, buildLog);
  }

  static SegmentList xor(SegmentList segments, BuildLog? buildLog) {
    return select(segments, xor_select_table, buildLog);
  }
}
