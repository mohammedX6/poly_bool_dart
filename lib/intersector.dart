import 'coordinate.dart';
import 'epsilon.dart';
import 'linked_list.dart';
import 'segment_fill.dart';
import 'types.dart';

class Intersecter {
  final bool selfIntersection;
  final event_root = EventLinkedList();
  final status_root = StatusLinkedList();

  Intersecter(this.selfIntersection);

  Segment segmentNew(Coordinate start, Coordinate end) {
    return Segment(start: start, end: end, myFill: SegmentFill());
  }

  Segment segmentCopy(Coordinate start, Coordinate end, Segment seg) {
    return Segment(
      start: start,
      end: end,
      myFill: SegmentFill(above: seg.myFill.above, below: seg.myFill.below),
    );
  }

  EventNode eventAddSegment(Segment seg, bool primary) {
    final ev_start =
        EventNode(isStart: true, pt: seg.start, seg: seg, primary: primary);

    final ev_end =
        EventNode(isStart: false, pt: seg.end, seg: seg, primary: primary);

    ev_start.other = ev_end;
    ev_end.other = ev_start;

    event_root.insertBefore(ev_start);
    event_root.insertBefore(ev_end);

    return ev_start;
  }

  void eventUpdateEnd(EventNode ev, Coordinate end) {
    // slides an end backwards
    //   (start)------------(end)    to:
    //   (start)---(end)

    ev.other.unlink();
    ev.seg.end = end;
    ev.other.pt = end;

    event_root.insertBefore(ev.other);
  }

  EventNode eventDivide(EventNode ev, Coordinate pt) {
    final ns = segmentCopy(pt, ev.seg.end, ev.seg);
    eventUpdateEnd(ev, pt);

    return eventAddSegment(ns, ev.primary);
  }

  SegmentList calculate({bool inverted = false}) {
    if (!selfIntersection) {
      throw Exception(
          "This function is only intended to be called when selfIntersection = true");
    }

    return calculate_INTERNAL(inverted, false);
  }

  SegmentList calculateXD(SegmentList segments1, bool inverted1,
      SegmentList segments2, bool inverted2) {
    if (selfIntersection) {
      throw Exception(
          "This function is only intended to be called when selfIntersection = false");
    }

    // segmentsX come from the self-intersection API, or this API
    // invertedX is whether we treat that list of segments as an inverted polygon or not
    // returns segments that can be used for further operations
    for (int i = 0; i < segments1.length; i++) {
      eventAddSegment(segments1[i], true);
    }
    for (int i = 0; i < segments2.length; i++) {
      eventAddSegment(segments2[i], false);
    }

    return calculate_INTERNAL(inverted1, inverted2);
  }

  void addRegion(List<Coordinate> region) {
    if (!selfIntersection) {
      throw Exception(
          "The addRegion() function is only intended for use when selfIntersection = false");
    }

    // Ensure that the polygon is fully closed (the start point and end point are exactly the same)
    if (!Epsilon().pointsSame(region[region.length - 1], region[0])) {
      region.add(region[0]);
    }

    // regions are a list of points:
    //  [ [0, 0], [100, 0], [50, 100] ]
    // you can add multiple regions before running calculate
    for (int i = 0; i < region.length - 1; i++) {
      final pt1 = region[i];
      final pt2 = region[i + 1];

      final forward = Epsilon().pointsCompare(pt1, pt2);
      if (forward == 0) // points are equal, so we have a zero-length segment
        continue; // just skip it

      eventAddSegment(
          segmentNew(forward < 0 ? pt1 : pt2, forward < 0 ? pt2 : pt1), true);
    }
  }

  EventNode? checkIntersection(EventNode ev1, EventNode ev2) {
    // returns the segment equal to ev1, or false if nothing equal

    final seg1 = ev1.seg;
    final seg2 = ev2.seg;
    final a1 = seg1.start;
    final a2 = seg1.end;
    final b1 = seg2.start;
    final b2 = seg2.end;

    final intersect = Epsilon().linesIntersect(seg1, seg2);

    if (intersect == null) {
      // segments are parallel or coincident

      // if points aren't collinear, then the segments are parallel, so no intersections
      if (!Epsilon().pointsCollinear(a1, a2, b1)) return null;

      // otherwise, segments are on top of each other somehow (aka coincident)

      if (Epsilon().pointsSame(a1, b2) || Epsilon().pointsSame(a2, b1))
        return null; // segments touch at endpoints... no intersection

      final a1_equ_b1 = Epsilon().pointsSame(a1, b1);
      final a2_equ_b2 = Epsilon().pointsSame(a2, b2);

      if (a1_equ_b1 && a2_equ_b2) return ev2; // segments are exactly equal

      final a1_between = !a1_equ_b1 && Epsilon().pointBetween(a1, b1, b2);
      final a2_between = !a2_equ_b2 && Epsilon().pointBetween(a2, b1, b2);

      if (a1_equ_b1) {
        if (a2_between) {
          //  (a1)---(a2)
          //  (b1)----------(b2)
          eventDivide(ev2, a2);
        } else {
          //  (a1)----------(a2)
          //  (b1)---(b2)
          eventDivide(ev1, b2);
        }

        return ev2;
      } else if (a1_between) {
        if (!a2_equ_b2) {
          // make a2 equal to b2
          if (a2_between) {
            //         (a1)---(a2)
            //  (b1)-----------------(b2)
            eventDivide(ev2, a2);
          } else {
            //         (a1)----------(a2)
            //  (b1)----------(b2)
            eventDivide(ev1, b2);
          }
        }

        //         (a1)---(a2)
        //  (b1)----------(b2)
        eventDivide(ev2, a1);
      }
    } else {
      // otherwise, lines intersect at i.pt, which may or may not be between the endpoints

      // is A divided between its endpoints? (exclusive)
      if (intersect.alongA == 0) {
        if (intersect.alongB == -1) // yes, at exactly b1
          eventDivide(ev1, b1);
        else if (intersect.alongB == 0) // yes, somewhere between B's endpoints
          eventDivide(ev1, intersect.pt);
        else if (intersect.alongB == 1) // yes, at exactly b2
          eventDivide(ev1, b2);
      }

      // is B divided between its endpoints? (exclusive)
      if (intersect.alongB == 0) {
        if (intersect.alongA == -1) // yes, at exactly a1
          eventDivide(ev2, a1);
        else if (intersect.alongA ==
            0) // yes, somewhere between A's endpoints (exclusive)
          eventDivide(ev2, intersect.pt);
        else if (intersect.alongA == 1) // yes, at exactly a2
          eventDivide(ev2, a2);
      }
    }

    return null;
  }

  EventNode? checkBothIntersections(
      EventNode ev, EventNode? above, EventNode? below) {
    if (above != null) {
      final eve = checkIntersection(ev, above);
      if (eve != null) return eve;
    }

    if (below != null) {
      return checkIntersection(ev, below);
    }

    return null;
  }

  SegmentList calculate_INTERNAL(
      bool primaryPolyInverted, bool secondaryPolyInverted) {
    //
    // main event loop
    //
    final segments = SegmentList();

    while (!event_root.isEmpty) {
      final ev = event_root.first;

      if (ev.isStart) {
        final surrounding = status_root.findTransition(ev);
        final above = surrounding.above;
        final below = surrounding.below;

        final eve = checkBothIntersections(ev, above, below);
        if (eve != null) {
          // ev and eve are equal
          // we'll keep eve and throw away ev

          // merge ev.seg's fill information into eve.seg

          if (selfIntersection) {
            bool toggle = true; // are we a toggling edge?
            if (ev.seg.myFill.below != null)
              toggle = ev.seg.myFill.above != ev.seg.myFill.below;

            // merge two segments that belong to the same polygon
            // think of this as sandwiching two segments together, where `eve.seg` is
            // the bottom -- this will cause the above fill flag to toggle
            if (toggle) {
              eve.seg.myFill.above = !eve.seg.myFill.above;
            }
          } else {
            // merge two segments that belong to different polygons
            // each segment has distinct knowledge, so no special logic is needed
            // note that this can only happen once per segment in this phase, because we
            // are guaranteed that all self-intersections are gone
            eve.seg.otherFill = ev.seg.myFill;
          }

          ev.other.unlink();
          ev.unlink();
        }

        if (event_root.head != ev) {
          // something was inserted before us in the event queue, so loop back around and
          // process it before continuing
          continue;
        }

        //
        // calculate fill flags
        //
        if (selfIntersection) {
          // if we are a segment...
          bool toggle = true; // are we a toggling edge?
          if (ev.seg.myFill.below != null)
            // we are a segment that has previous knowledge from a division
            toggle =
                ev.seg.myFill.above != ev.seg.myFill.below; // calculate toggle

          // next, calculate whether we are filled below us
          if (below == null) {
            // if nothing is below us...
            // we are filled below us if the polygon is inverted
            ev.seg.myFill.below = primaryPolyInverted;
          } else {
            // otherwise, we know the answer -- it's the same if whatever is below
            // us is filled above it
            ev.seg.myFill.below = below.seg.myFill.above;
          }

          // since now we know if we're filled below us, we can calculate whether
          // we're filled above us by applying toggle to whatever is below us
          if (toggle)
            ev.seg.myFill.above =
                !(ev.seg.myFill.below ?? !ev.seg.myFill.above);
          else
            ev.seg.myFill.above = ev.seg.myFill.below ?? ev.seg.myFill.above;
        } else {
          // now we fill in any missing transition information, since we are all-knowing
          // at this point

          if (ev.seg.otherFill == null) {
            // if we don't have other information, then we need to figure out if we're
            // inside the other polygon
            bool inside = false;
            if (below == null) {
              // if nothing is below us, then we're inside if the other polygon is
              // inverted
              inside = ev.primary ? secondaryPolyInverted : primaryPolyInverted;
            } else {
              // otherwise, something is below us
              // so copy the below segment's other polygon's above
              if (ev.primary == below.primary)
                inside = below.seg.otherFill!.above;
              else
                inside = below.seg.myFill.above;
            }

            ev.seg.otherFill = SegmentFill(above: inside, below: inside);
          }
        }

        // insert the status and remember it for later removal
        ev.other.status = surrounding.insert();
      } else {
        final st = ev.status;
        if (st == null) {
          throw Exception(
              "PolyBool: Zero-length segment detected; your epsilon is probably too small or too large");
        }

        // removing the status will create two adjacent edges, so we'll need to check
        // for those
        if (st.previous != null && st.next != null)
          checkIntersection(st.previous!.ev, st.next!.ev);

        // remove the status
        st.unlink();

        // if we've reached this point, we've calculated everything there is to know, so
        // save the segment for reporting
        if (!ev.primary) {
          // make sure `seg.myFill` actually points to the primary polygon though
          final s = ev.seg.myFill;
          ev.seg.myFill = ev.seg.otherFill!;
          ev.seg.otherFill = s;
        }

        segments.add(ev.seg);
      }

      // remove the event and continue
      ev.unlink();
    }

    return segments;
  }
}
