<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Boolean operations on polygons (union, intersection, difference, xor) (this library is a port for flutter of polybooljs



## Features

1.Clips polygons for all boolean operations
2.Removes unnecessary vertices
3.Handles segments that are coincident (overlap perfectly, share vertices, one inside the other, etc)
4.Uses formulas that take floating point irregularities into account (via configurable epsilon)
5.Provides an API for constructing efficient sequences of operations

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```
# Resources

* [View the demo + animation](https://rawgit.com/voidqk/polybooljs/master/dist/demo.html)
* Based somewhat on the F. Martinez (2008) algorithm:
    * [Paper](http://www.cs.ucr.edu/~vbz/cs230papers/martinez_boolean.pdf)
    * [Code](https://github.com/akavel/martinez-src
