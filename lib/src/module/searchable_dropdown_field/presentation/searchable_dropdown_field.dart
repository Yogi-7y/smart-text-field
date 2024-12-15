import 'package:flutter/widgets.dart';

typedef SearchSources<T> = List<SearchSource<T>>;

@immutable
class SearchableDropdownField extends StatelessWidget {
  const SearchableDropdownField({
    super.key,
    requried this.sources,
  });

  final SearchSources sources;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
