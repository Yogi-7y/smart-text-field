import 'package:flutter/foundation.dart';

@immutable
abstract class Tokenable {
  const Tokenable({
    required this.stringValue,
    required this.prefix,
  });

  final String stringValue;

  final String prefix;
}
