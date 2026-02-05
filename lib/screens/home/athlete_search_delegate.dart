import 'package:flutter/material.dart';

import '../../data/models/athlete.dart';
import '../../state/app_state.dart';

class AthleteSearchDelegate extends SearchDelegate<Athlete?> {
  final AppState appState;

  AthleteSearchDelegate({required this.appState});

  @override
  String get searchFieldLabel => 'Search athletes';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final base = Theme.of(context);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Color(0xFF777777)),
        border: InputBorder.none,
      ),
      textTheme: base.textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final q = query.trim().toLowerCase();

    final matches = appState.athletes.where((a) {
      final name = a.name.toLowerCase();
      final handle = a.handle.toLowerCase();
      return q.isEmpty || name.contains(q) || handle.contains(q);
    }).toList();

    if (matches.isEmpty) {
      return const Center(
        child: Text(
          'No athletes found',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      itemCount: matches.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFF222222)),
      itemBuilder: (context, i) {
        final a = matches[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF2A2A2A),
            backgroundImage: a.avatarUrl.isNotEmpty ? NetworkImage(a.avatarUrl) : null,
            child: a.avatarUrl.isEmpty
                ? Text(a.name.isNotEmpty ? a.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))
                : null,
          ),
          title: Text(a.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: Text(a.handle, style: const TextStyle(color: Colors.white54)),
          onTap: () => close(context, a),
        );
      },
    );
  }
}
