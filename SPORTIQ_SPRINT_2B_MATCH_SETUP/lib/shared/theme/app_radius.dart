// Corner radius tokens sourced from Stitch export borderRadius config.
import 'package:flutter/material.dart';

abstract class AppRadius {
  AppRadius._();

  static const double xs = 4; // DEFAULT
  static const double sm = 8; // lg
  static const double md = 12; // xl
  static const double full = 9999;

  static BorderRadius get xsRadius => BorderRadius.circular(xs);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}
