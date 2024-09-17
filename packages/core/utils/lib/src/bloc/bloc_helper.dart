import 'package:flutter/material.dart';

bool alwaysTrue<S>(S first, S second) {
  return true;
}

bool alwaysFalse<S>(S first, S second) {
  return false;
}

void idleListener<S>(BuildContext context, S state) {}
