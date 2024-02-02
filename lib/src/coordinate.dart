class Coordinate {
  late double x;
  late double y;

  Coordinate(double x, double y) {
    this.x = double.parse(x.toStringAsFixed(5));
    this.y = double.parse(y.toStringAsFixed(5));
  }

  @override
  String toString() {
    return "($x, $y)";
  }

  @override
  bool operator ==(Object other) =>
      other is Coordinate && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}
