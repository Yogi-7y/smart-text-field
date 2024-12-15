import 'package:flutter/material.dart';
import 'package:smart_textfield/src/module/searchable_dropdown_field/domain/entity/searchable.dart';
import 'package:smart_textfield/src/module/searchable_dropdown_field/domain/use_case/sync_search_provider.dart';
import 'package:smart_textfield/src/module/searchable_dropdown_field/presentation/models/search_renderer.dart';
import 'package:smart_textfield/src/module/searchable_dropdown_field/presentation/models/search_source.dart';

// Search Provider
class CountrySearchProvider extends SyncSearchProvider<Country> {
  CountrySearchProvider({required super.items});

  @override
  bool query({required String text, required Country item}) {
    final searchLower = text.toLowerCase();
    return item.name.toLowerCase().contains(searchLower) ||
        item.code.toLowerCase().contains(searchLower) ||
        item.shortName.toLowerCase().contains(searchLower);
  }
}

// Search Renderer
class CountrySearchRenderer extends SearchRenderer<Country> {
  @override
  Widget render(BuildContext context, Country item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.shortName} • ${item.code}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
          Text(
            item.gmtString,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}

void main() {
  final searchSource = SearchSource<Country>(
    provider: CountrySearchProvider(items: countries),
    renderer: CountrySearchRenderer(),
  );

  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchableDropdownField<Country>(
              source: searchSource,
              onSelected: (country) {
                print('Selected: ${country.name}');
              },
              decoration: const InputDecoration(
                labelText: 'Select Country',
                hintText: 'Search by name, code or short name',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class Country implements Searchable {
  final String name;
  final String code;
  final String shortName;
  final double gmtOffset;

  const Country({
    required this.name,
    required this.code,
    required this.shortName,
    required this.gmtOffset,
  });

  String get gmtString {
    final hours = gmtOffset.toInt();
    final minutes = ((gmtOffset - hours) * 60).toInt().abs();
    final sign = gmtOffset >= 0 ? '+' : '-';
    return 'GMT$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

final countries = [
  const Country(
    name: 'United States',
    code: 'US',
    shortName: 'USA',
    gmtOffset: -5,
  ),
  const Country(
    name: 'United Kingdom',
    code: 'GB',
    shortName: 'UK',
    gmtOffset: 0,
  ),
  const Country(
    name: 'Japan',
    code: 'JP',
    shortName: 'JPN',
    gmtOffset: 9,
  ),
  const Country(
    name: 'India',
    code: 'IN',
    shortName: 'IND',
    gmtOffset: 5.5,
  ),
];
