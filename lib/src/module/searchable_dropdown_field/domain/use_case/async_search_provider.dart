import 'dart:async';

import 'package:flutter/foundation.dart';

import '../entity/searchable.dart';
import 'search_provider.dart';

@immutable
abstract class AsyncSearchProvider<T extends Searchable> extends SearchProvider<T> {
  Future<SearchResults<T>> query(Query text);

  @override
  Future<SearchResults<T>> search(Query text) => query(text);
}
