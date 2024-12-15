import 'package:flutter/foundation.dart';

import '../../use_case/smart_textfield_use_case.dart';
import '../tokenable.dart';

@immutable
class TokenableDateTime extends DateTime implements Tokenable {
  TokenableDateTime(
    super.year, [
    super.month = 1,
    super.day = 1,
    super.hour = 0,
    super.minute = 0,
    super.second = 0,
    super.millisecond = 0,
    super.microsecond = 0,
  ]);

  @override
  String get stringValue => '$year';

  @override
  String get prefix => dateTimePrefix;
}
