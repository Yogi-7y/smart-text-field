import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../smart_textfield.dart';

class SearchResultsNotifier extends ChangeNotifier {
  SearchResultsNotifier({
    required this.sources,
  });

  final SearchSources sources;

  final _widgets = <Widget>[];
  List<Widget> get widgets => _widgets;

  Future<void> search(
    BuildContext context,
    Query query,
  ) async {
    _widgets.clear();

    for (final source in sources) {
      final _provider = source.provider;
      final _renderer = source.renderer;

      if (_provider is SyncSearchProvider) {
        final _result = _provider
            .search(query)
            .map((item) => _renderer.render(context, item)) //
            .toList();

        _widgets.addAll(_result);
      } else if (_provider is AsyncSearchProvider) {
        final _providerResults = await _provider.search(query);

        final _result = _providerResults
            .map((item) => _renderer.render(context, item)) //
            .toList();

        _widgets.addAll(_result);
      }
    }

    notifyListeners();
  }
}
