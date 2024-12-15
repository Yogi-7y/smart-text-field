// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'tokenable.dart';

/// Represents the extracted value form the input text.
@immutable
class Token<T extends Tokenable> {
  Token({
    required this.rawValue,
    required this.displayValue,
    required this.offset,
    required this.prefix,
    this.value,
    this.isHighlighted = false,
  }) : assert(
          !isHighlighted || prefix.isNotEmpty,
          'isHighlighted should be true only when prefix is not empty.',
        );

  /// Value extracted directly from input without any modification.
  /// Looks like: `@JohnDoe`
  final String rawValue;

  /// Value that will be displayed in the input field once the token is matched for better readability.
  final String displayValue;

  final T? value;

  final TokenOffset offset;

  /// Indicates if the token should be highlighted in the input field.
  final bool isHighlighted;

  /// Special character that invokes the tokenizer and is used to match the pattern in the input text.
  /// Empty string means that it's a normal text.
  final String prefix;

  @override
  String toString() {
    final buffer = StringBuffer('Token(')
      ..writeln('rawValue: $rawValue')
      ..writeln('displayValue: $displayValue')
      ..writeln('value: $value')
      ..writeln('offset: $offset')
      ..writeln('isHighlighted: $isHighlighted')
      ..writeln('prefix: $prefix')
      ..write(')');
    return buffer.toString();
  }

  @override
  int get hashCode =>
      rawValue.hashCode ^
      displayValue.hashCode ^
      value.hashCode ^
      offset.hashCode ^
      isHighlighted.hashCode ^
      prefix.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Token<T> &&
        other.rawValue == rawValue &&
        other.displayValue == displayValue &&
        other.value == value &&
        other.offset == offset &&
        other.isHighlighted == isHighlighted &&
        other.prefix == prefix;
  }
}

@immutable
class TokenOffset {
  const TokenOffset({
    required this.start,
    required this.end,
  });

  final int start;
  final int end;

  @override
  String toString() {
    final buffer = StringBuffer('TokenOffset(')
      ..write('start: $start, ')
      ..write('end: $end')
      ..write(')');
    return buffer.toString();
  }

  @override
  bool operator ==(covariant TokenOffset other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
