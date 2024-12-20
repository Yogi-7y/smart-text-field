import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

class AsyncSearchExample extends StatefulWidget {
  const AsyncSearchExample({super.key});

  @override
  State<AsyncSearchExample> createState() => _AsyncSearchExampleState();
}

class _AsyncSearchExampleState extends State<AsyncSearchExample> {
  final _searchSource = SearchSource<Package>(
    provider: PubPackageSearchProvider(),
    renderer: PackageSearchRenderer(),
  );

  @override
  Widget build(BuildContext context) {
    return SearchableDropdownField(
      sources: [_searchSource],
    );
  }
}

class PubPackageSearchProvider extends AsyncSearchProvider<Package> {
  final _client = HttpClient();

  @override
  Future<SearchResults<Package>> query(Query text) async {
    if (text.isEmpty) return [];

    try {
      final uri = Uri.parse('https://pub.dev/api/search?q=${Uri.encodeComponent(text)}');
      final request = await _client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200)
        throw Exception('Failed to search packages: ${response.statusCode}');

      final jsonString = await response.transform(utf8.decoder).join();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final packages = (json['packages'] as List<Object?>)
          .cast<Map<String, Object?>>()
          .map(Package.fromJson)
          .toList();

      return packages;
    } catch (e) {
      debugPrint('Error searching packages: $e');
      return [];
    }
  }
}

class PackageSearchRenderer extends SearchRenderer<Package> {
  @override
  Widget render(BuildContext context, Package item) {
    return ListTile(
      title: Text(item.name),
    );
  }
}

@immutable
class Package implements Searchable {
  const Package({required this.name});

  factory Package.fromJson(Map<String, dynamic> json) =>
      Package(name: json['package'] as String? ?? 'N/A');

  final String name;

  @override
  String toString() => 'Package(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Package && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String get stringifiedValue => name;
}
