import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../smart_textfield.dart';

typedef Widgets = List<Widget>;

class SearchResultsNotifier extends ChangeNotifier {
  SearchResultsNotifier({
    required this.sources,
    this.debounceDuration = _defaultDebounceDuration,
  });

  static const _defaultDebounceDuration = Duration(milliseconds: 300);

  final SearchSources sources;

  final Duration debounceDuration;
  Timer? _debounceTimer;

  final _widgets = <Widget>[];
  List<Widget> get widgets => _widgets;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> search(
    BuildContext context,
    Query query,
  ) async {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(
      debounceDuration,
      () async => _onDebounceCallback(context: context, query: query),
    );
  }

  Future<void> _onDebounceCallback({
    required BuildContext context,
    required Query query,
  }) async {
    _widgets.clear();

    final _results = await searchQuery(
      context: context,
      query: query,
    );

    _widgets.addAll(_results);

    notifyListeners();
  }

  @visibleForTesting
  Future<Widgets> searchQuery({
    required BuildContext context,
    required Query query,
  }) async {
    final _results = <Widget>[];

    for (final source in sources) {
      final _provider = source.provider;
      final _renderer = source.renderer;

      if (_provider is SyncSearchProvider) {
        final _result = _provider
            .search(query)
            .map((item) => _renderer.render(context, item)) //
            .toList();

        _results.addAll(_result);
      } else if (_provider is AsyncSearchProvider) {
        final _providerResults = await _provider.search(query);

        final _result = _providerResults
            .map((item) => _renderer.render(context, item)) //
            .toList();

        _results.addAll(_result);
      }
    }

    return _results;
  }
}
