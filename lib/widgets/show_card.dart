import 'package:flutter/material.dart';

import '../models/show.dart';

class ShowCard extends StatelessWidget {
  final TVShow show;
  const ShowCard({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Image.network(show.image, width: 50, fit: BoxFit.cover),
        title: Text(show.name),
      ),
    );
  }
}
