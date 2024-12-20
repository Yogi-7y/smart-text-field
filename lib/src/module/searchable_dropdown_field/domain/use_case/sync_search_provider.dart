import 'package:flutter/foundation.dart';

import '../entity/searchable.dart';
import 'search_provider.dart';

/// Synchronous search provider.
///
/// To be used when the client already has the items on which the search will be performed.
/// It applies the query logic on all the items and returns the relevant results.
@immutable
abstract class SyncSearchProvider<T extends Searchable> extends SearchProvider<T> {
  SyncSearchProvider({required this.items});

  /// List of searchable items on which the query will be performed.
  final List<T> items;

  /// Query logic to be implemented by the client.
  /// Based on the query, the search operation will return relevant results.
  bool query({required Query text, required T item});

  @override
  SearchResults<T> search(Query text) {
    if (text.isEmpty) return items;
    return items.where((item) => query(text: text, item: item)).toList();
  }
}
