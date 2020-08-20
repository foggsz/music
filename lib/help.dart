import 'package:flutter/material.dart';

BoxConstraints getBoxConstraints(BoxConstraints constraints, [double ratio]) {
  return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: constraints.maxHeight * (ratio ?? 9 / 16));
}
