import 'package:flutter/foundation.dart';

import '../../domain/entity/searchable.dart';
import '../../domain/use_case/search_provider.dart';
import 'search_renderer.dart';

@immutable

/// Source class for a given search operation. Combines the query logic and the UI for a search operation.
class SearchSource<T extends Searchable> {
  const SearchSource({
    required this.provider,
    required this.renderer,
  });

  /// Source which will have the logic and return the results.
  final SearchProvider<T> provider;

  /// Renders the UI for the returned results from the [provider].
  final SearchRenderer<T> renderer;
}
