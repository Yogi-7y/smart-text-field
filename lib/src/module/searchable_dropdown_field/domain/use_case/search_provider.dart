import 'dart:async';

import 'package:flutter/foundation.dart';

import '../entity/searchable.dart';

typedef SearchResults<T extends Searchable> = List<T>;
typedef Query = String;

/// Base provider for search operations.
///
/// [T] must be a [Searchable] type to ensure all searched items
/// conform to the searchable contract.
@immutable
abstract class SearchProvider<T extends Searchable> {
  /// Performs a search operation with the given [text].
  ///
  /// Returns a [FutureOr<List<T>>] to support both synchronous
  /// and asynchronous search operations.
  ///
  /// [text] is the search query entered by the user.
  FutureOr<SearchResults> search(Query text);
}
