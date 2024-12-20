// ignore_for_file: sort_constructors_first, avoid_setters_without_getters

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../smart_textfield.dart';
import 'query_notifier.dart';

typedef SearchResultItem<T extends Searchable> = ({SearchRenderBuilder<T> builder, T item});
typedef SearchResults<T extends Searchable> = List<SearchResultItem<T>>;

class SearchResultsNotifier<T extends Searchable> extends ChangeNotifier {
  static const _defaultDebounceDuration = Duration(milliseconds: 300);

  SearchResultsNotifier({
    required this.sources,
    required this.textController,
    required this.queryNotifier,
    required this.focusNode,
    this.debounceDuration = _defaultDebounceDuration,
    this.initialValue,
  }) {
    textController.addListener(_onTextChanged);
    focusNode.addListener(_onFocusChanged);
    queryNotifier.addListener(_onSearchTriggered);
  }

  final SearchSources<T> sources;

  /// If passed, this value will be set as selected by default.
  final T? initialValue;
  final Duration debounceDuration;

  late final TextEditingController textController;
  late final QueryNotifier queryNotifier;
  late final FocusNode focusNode;

  Timer? _debounceTimer;

  final _widgets = <SearchResultItem<T>>[];
  List<SearchResultItem<T>> get widgets => _widgets;

  T? _selectedValue;
  T? get selectedValue => _selectedValue;

  /// Whether the suggestions overlay is visible or not.
  bool _isSuggestionsVisible = false;
  bool get isSuggestionsVisible => _isSuggestionsVisible;
  set updateSuggestionsVisibility(bool isVisible) {
    if (_isSuggestionsVisible == isVisible) return;
    _isSuggestionsVisible = isVisible;
    notifyListeners();
  }

  void _onTextChanged() {
    queryNotifier.updateQuery = textController.text;
    updateSuggestionsVisibility = true;
  }

  void _onFocusChanged() {
    if (!focusNode.hasFocus && selectedValue == null) {
      textController.clear();
    }
  }

  void selectValue(T value) {
    _selectedValue = value;
    textController.text = value.stringifiedValue;
    updateSuggestionsVisibility = false;
  }

  Future<void> _onSearchTriggered() async => search(queryNotifier.value);

  Future<void> search(
    Query query,
  ) async {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(
      debounceDuration,
      () async => _onDebounceCallback(query: query),
    );
  }

  Future<void> _onDebounceCallback({
    required Query query,
  }) async {
    _widgets.clear();

    final _results = await searchQuery(
      query: query,
    );

    _widgets.addAll(_results);

    notifyListeners();
  }

  @visibleForTesting
  Future<SearchResults<T>> searchQuery({
    required Query query,
  }) async {
    final _results = <SearchResultItem<T>>[];

    for (final source in sources) {
      final _provider = source.provider;
      final _renderer = source.renderer;

      if (_provider is SyncSearchProvider<T>) {
        final _result = _provider
            .search(query)
            .map((item) => (builder: _renderer.render, item: item)) //
            .toList();

        _results.addAll(_result);
      } else if (_provider is AsyncSearchProvider<T>) {
        final _providerResults = await _provider.search(query);

        final _result = _providerResults
            .map((item) => (builder: _renderer.render, item: item)) //
            .toList();

        _results.addAll(_result);
      }
    }

    return _results;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
