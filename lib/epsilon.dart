//
// provides the raw computation functions that takes epsilon into account
//
// zero is defined to be between (-epsilon, epsilon) exclusive
//

import 'dart:math' as math;

import 'package:dart_jts/dart_jts.dart' as JTS;

import 'types.dart';

class Epsilon {
  static const eps = 0.0000000001; // sane default? sure why not

  bool pointAboveOrOnLine(
      JTS.Coordinate pt, JTS.Coordinate left, JTS.Coordinate right) {
    var Ax = left.x;
    var Ay = left.y;
    var Bx = right.x;
    var By = right.y;
    var Cx = pt.x;
    var Cy = pt.y;
    var ABx = Bx - Ax;
    var ABy = By - Ay;
    var AB = math.sqrt(ABx * ABx + ABy * ABy);
    // algebraic distance of 'pt' to ('left', 'right') line is:
    // [ABx * (Cy - Ay) - ABy * (Cx - Ax)] / AB
    return ABx * (Cy - Ay) - ABy * (Cx - Ax) >= -eps * AB;
  }

  bool pointBetween(
      JTS.Coordinate p, JTS.Coordinate left, JTS.Coordinate right) {
    // p must be collinear with left->right
    // returns false if p == left, p == right, or left == right
    if (pointsSame(p, left) || pointsSame(p, right)) return false;
    var d_py_ly = p.y - left.y;
    var d_rx_lx = right.x - left.x;
    var d_px_lx = p.x - left.x;
    var d_ry_ly = right.y - left.y;

    var dot = d_px_lx * d_rx_lx + d_py_ly * d_ry_ly;
    // dot < 0 is p is to the left of 'left'
    if (dot < 0) return false;
    var sqlen = d_rx_lx * d_rx_lx + d_ry_ly * d_ry_ly;
    // dot <= sqlen is p is to the left of 'right'
    return dot <= sqlen;
  }

  bool pointsSameX(JTS.Coordinate p1, JTS.Coordinate p2) {
    return (p1.x - p2.x).abs() < eps;
  }

  bool pointsSameY(JTS.Coordinate p1, JTS.Coordinate p2) {
    return (p1.y - p2.y).abs() < eps;
  }

  bool pointsSame(JTS.Coordinate p1, JTS.Coordinate p2) {
    return pointsSameX(p1, p2) && pointsSameY(p1, p2);
  }

  int pointsCompare(JTS.Coordinate p1, JTS.Coordinate p2) {
    // returns -1 if p1 is smaller, 1 if p2 is smaller, 0 if equal
    if (pointsSameX(p1, p2))
      return pointsSameY(p1, p2) ? 0 : (p1.y < p2.y ? -1 : 1);
    return p1.x < p2.x ? -1 : 1;
  }

  bool pointsCollinear(
      JTS.Coordinate pt1, JTS.Coordinate pt2, JTS.Coordinate pt3) {
    // does pt1->pt2->pt3 make a straight line?
    // essentially this is just checking to see if the slope(pt1->pt2) === slope(pt2->pt3)
    // if slopes are equal, then they must be collinear, because they share pt2
    var dx1 = pt1.x - pt2.x;
    var dy1 = pt1.y - pt2.y;
    var dx2 = pt2.x - pt3.x;
    var dy2 = pt2.y - pt3.y;
    var n1 = math.sqrt(dx1 * dx1 + dy1 * dy1);
    var n2 = math.sqrt(dx2 * dx2 + dy2 * dy2);
    // Assuming det(u, v) = 0, we have:
    // |det(u + u_err, v + v_err)| = |det(u + u_err, v + v_err) - det(u,v)|
    // =|det(u, v_err) + det(u_err. v) + det(u_err, v_err)|
    // <= |det(u, v_err)| + |det(u_err, v)| + |det(u_err, v_err)|
    // <= N(u)N(v_err) + N(u_err)N(v) + N(u_err)N(v_err)
    // <= eps * (N(u) + N(v) + eps)
    // We have N(u) ~ N(u + u_err) and N(v) ~ N(v + v_err).
    // Assuming eps << N(u) and eps << N(v), we end with:
    // |det(u + u_err, v + v_err)| <= eps * (N(u + u_err) + N(v + v_err))
    return (dx1 * dy2 - dx2 * dy1).abs() <= eps * (n1 + n2);
  }

  Map<bool, Intersection> linesIntersectAsMap(JTS.Coordinate a0,
      JTS.Coordinate a1, JTS.Coordinate b0, JTS.Coordinate b1) {
    Intersection intersection;
    // returns false if the lines are coincident (e.g., parallel or on top of each other)
    //
    // returns an object if the lines intersect:
    //   {
    //     pt: [x, y],    where the intersection point is at
    //     alongA: where intersection point is along A,
    //     alongB: where intersection point is along B
    //   }
    //
    //  alongA and alongB will each be one of: -2, -1, 0, 1, 2
    //
    //  with the following meaning:
    //
    //    -2   intersection point is before segment's first point
    //    -1   intersection point is directly on segment's first point
    //     0   intersection point is between segment's first and second points (exclusive)
    //     1   intersection point is directly on segment's second point
    //     2   intersection point is after segment's second point

    var adx = a1.x - a0.x;
    var ady = a1.y - a0.y;
    var bdx = b1.x - b0.x;
    var bdy = b1.y - b0.y;

    var axb = adx * bdy - ady * bdx;
    var n1 = math.sqrt(adx * adx + ady * ady);
    var n2 = math.sqrt(bdx * bdx + bdy * bdy);
    if ((axb).abs() <= eps * (n1 + n2)) {
      intersection = Intersection.Empty;
      return {false: intersection}; // lines are coincident

    }

    var dx = a0.x - b0.x;
    var dy = a0.y - b0.y;

    var A = (bdx * dy - bdy * dx) / axb;
    var B = (adx * dy - ady * dx) / axb;

    JTS.Coordinate pt = JTS.Coordinate(a0.x + A * adx, a0.y + A * ady);
    intersection = new Intersection(alongA: 0, alongB: 0, pt: pt);

    // categorize where intersection point is along A and B

    if (pointsSame(pt, a0))
      intersection.alongA = -1;
    else if (pointsSame(pt, a1))
      intersection.alongA = 1;
    else if (A < 0)
      intersection.alongA = -2;
    else if (A > 1) intersection.alongA = 2;

    if (pointsSame(pt, b0))
      intersection.alongB = -1;
    else if (pointsSame(pt, b1))
      intersection.alongB = 1;
    else if (B < 0)
      intersection.alongB = -2;
    else if (B > 1) intersection.alongB = 2;

    return {true: intersection};
  }
}
