import 'package:flutter/material.dart';

class SearchableDropdownFieldData {
  SearchableDropdownFieldData({
    this.decoration,
    this.padding,
    this.margin = const EdgeInsets.only(top: 8),
  });

  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
}
