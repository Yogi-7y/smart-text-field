import 'package:flutter/material.dart';

import '../../domain/entity/searchable.dart';
import '../../domain/use_case/search_provider.dart';

/// Renderer class for a given [SearchProvider].
/// Usually mapped with a [SearchProvider] and passed in the [SearchSource]
abstract class SearchRenderer<T extends Searchable> {
  /// The UI that will be rendered for each item in the search results.
  Widget render(BuildContext context, T item);
}
