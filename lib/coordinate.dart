class Coordinate {
  double x;
  double y;

  Coordinate(this.x, this.y);

  @override
  String toString() {
    return "($x, $y)";
  }

  @override
  bool operator==(Object other) => other is Coordinate && x == other.x && y == other.y;
}
