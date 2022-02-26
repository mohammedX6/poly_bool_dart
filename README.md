poly_bool_dart

Boolean operations on polygons (union, intersection, difference, xor) (this library is a port for flutter of polybooljs

## Features


1. Clips polygons for all boolean operations
2. Removes unnecessary vertices
3. Handles segments that are coincident (overlap perfectly, share vertices, one inside the other,
   etc)
4. Uses formulas that take floating point irregularities into account (via configurable epsilon)
5. Provides an API for constructing efficient sequences of operations


## How to use it




    RegionPolygon poly1 = RegionPolygon(regions: [
      [
        Coordinate(37.27935791015625, 29.32472016151103),
        Coordinate(37.122802734375, 29.257648503615542),
        Coordinate(37.22442626953125, 29.135369220927156),
        Coordinate(37.36175537109374, 29.221699149280646),
        Coordinate(37.27935791015625, 29.32472016151103)
      ],
    ]);

    RegionPolygon poly2 = RegionPolygon(regions: [
      [
        Coordinate(37.104949951171875, 29.159357041355424),
        Coordinate(37.1722412109375, 29.046565622728846),
        Coordinate(37.31781005859375, 29.105376571809618),
        Coordinate(37.20794677734375, 29.216904948184734),
        Coordinate(37.104949951171875, 29.159357041355424),
      ]
    ]);

    var seg1 = PolyBool().segments(poly1);
    var seg2 = PolyBool().segments(poly2);
    var comb = PolyBool().combine(seg1, seg2);
    var result = {
      'union': PolyBool().polygon(PolyBool().selectUnion(comb)),
      'intersect': PolyBool().polygon(PolyBool().selectIntersect(comb)),
      'difference': PolyBool().polygon(PolyBool().selectDifference(comb)),
      'differenceRev': PolyBool().polygon(PolyBool().selectDifferenceRev(comb)),
      'xor': PolyBool().polygon(PolyBool().selectXor(comb))
    };

## Notes
1. No test cases available, Because i don't have time right now


# Resources

* [View the demo + animation](https://unpkg.com/polybooljs@1.2.0/dist/demo.html)
* Based somewhat on the F. Martinez (2008) algorithm:
    * [Paper](http://www.cs.ucr.edu/~vbz/cs230papers/martinez_boolean.pdf)
    * [Code](https://github.com/akavel/martinez-src
    * [More Info](https://github.com/velipso/polybooljs)
