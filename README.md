# Polybool

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/mohammedx6)


1.This package is now on pub.dev: https://pub.dev/packages/polybool

2.Null saftey is now supported thanks to @ignatz


Boolean operations on polygons: union, intersection, difference, xor.

This library is based on:
  * [polybooljs](https://github.com/velipso/polybooljs) by velipso@, which is based on
  * [polybool actionscript](https://github.com/akavel/martinez-src) by akavel@, which is based on
  * an implementation by Mahir Iqbal, which is based on
  * F. Martinez' (2008) algorithm ([Paper](http://www.cs.ucr.edu/~vbz/cs230papers/martinez_boolean.pdf))

## Features

1. Clips polygons for all boolean operations
2. Removes unnecessary vertices
3. Handles segments that are coincident (overlap perfectly, share vertices, one inside the other,
   etc)
4. Uses formulas that take floating point irregularities into account
5. Provides an API for constructing efficient sequences of operations

## How to use it

```dart
    final poly1 = Polygon(regions: [
      [
        Coordinate(37.27935791015625, 29.32472016151103),
        Coordinate(37.122802734375, 29.257648503615542),
        Coordinate(37.22442626953125, 29.135369220927156),
        Coordinate(37.36175537109374, 29.221699149280646),
        Coordinate(37.27935791015625, 29.32472016151103),
      ],
    ]);

    final poly2 = Polygon(regions: [
      [
        Coordinate(37.104949951171875, 29.159357041355424),
        Coordinate(37.1722412109375, 29.046565622728846),
        Coordinate(37.31781005859375, 29.105376571809618),
        Coordinate(37.20794677734375, 29.216904948184734),
        Coordinate(37.104949951171875, 29.159357041355424),
      ]
    ]);

    final union = poly1.union(poly2);
    final intersection = poly1.intersect(poly2);
    final difference = poly1.difference(poly2);
    final inverseDifference = poly1.differenceRev(poly2);
    final xor = poly1.xor(poly2);
```

# Resources

* [Companion Tutorial](https://sean.cm/a/polygon-clipping-pt2)
