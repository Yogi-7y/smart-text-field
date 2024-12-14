import 'package:flutter/foundation.dart';

import '../tokenable.dart';

@immutable
class TokenableString implements Tokenable {
  const TokenableString(this.value);

  final String value;

  @override
  String get stringValue => value;

  @override
  String toString() => 'TokenableString(value: $value)';

  @override
  bool operator ==(covariant TokenableString other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String get prefix => '';
}
