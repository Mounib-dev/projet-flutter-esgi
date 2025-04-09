import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/show_provider.dart';
import '../../widgets/show_card.dart';
import '../views/detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ShowProvider>(context, listen: false).fetchPopularShows();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Provider.of<ShowProvider>(context, listen: false).searchShows(query);
    } else {
      Provider.of<ShowProvider>(context, listen: false).fetchPopularShows();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShowProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search TV Show',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ),
            ),
          ),
          if (provider.isLoading)
            const CircularProgressIndicator()
          else if (provider.shows.isEmpty)
            const Expanded(child: Center(child: Text('No results')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: provider.shows.length,
                itemBuilder: (context, index) {
                  final show = provider.shows[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(showId: show.id),
                        ),
                      );
                    },
                    child: ShowCard(show: show),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
