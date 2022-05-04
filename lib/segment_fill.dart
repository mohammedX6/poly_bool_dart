
class SegmentFill {
  // NOTE: This is kind of asinine, but the original javascript code used (below === null) to determine that the edge had not
  // yet been processed, and treated below as a standard true/false in every other case, necessitating the use of a nullable
  // bool here.

  bool? above;
  bool? below;

  SegmentFill({this.above = false, this.below});
}
