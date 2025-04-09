import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/show_provider.dart';
import '../../widgets/show_card.dart';
import 'detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 0;
  final int itemsPerPage = 7;

  @override
  void initState() {
    super.initState();
    Provider.of<ShowProvider>(context, listen: false).fetchPopularShows();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    setState(() {
      currentPage = 0; // Reset to first page on new search
    });
    if (query.isNotEmpty) {
      Provider.of<ShowProvider>(context, listen: false).searchShows(query);
    } else {
      Provider.of<ShowProvider>(context, listen: false).fetchPopularShows();
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  void _goToNextPage(int totalItems) {
    if ((currentPage + 1) * itemsPerPage < totalItems) {
      setState(() {
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShowProvider>(context);
    final totalItems = provider.shows.length;

    // Calcule la portion à afficher pour cette page
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);
    final currentPageItems = provider.shows.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows'),
        backgroundColor: const Color.fromARGB(255, 14, 28, 226),
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
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (totalItems == 0)
            const Expanded(child: Center(child: Text('No results')))
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentPageItems.length,
                      itemBuilder: (context, index) {
                        final show = currentPageItems[index];
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: currentPage > 0 ? _goToPreviousPage : null,
                      ),
                      Text('Page ${currentPage + 1}'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: (currentPage + 1) * itemsPerPage < totalItems
                            ? () => _goToNextPage(totalItems)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
