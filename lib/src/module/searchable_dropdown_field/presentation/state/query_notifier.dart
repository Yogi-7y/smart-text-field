// ignore_for_file: avoid_setters_without_getters

import 'package:flutter/foundation.dart';

class QueryNotifier extends ValueNotifier<String> {
  QueryNotifier() : super('');

  set updateQuery(String query) => value = query;

  void clear() => value = '';
}
