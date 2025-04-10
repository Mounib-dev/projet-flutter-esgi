import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/show_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/show_card.dart';
import 'detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ShowProvider>(context, listen: false);
    provider.fetchPopularShows();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !provider.isLoading &&
          provider.hasMore &&
          !provider.isLoadingMore) {
        provider.loadMorePopularShows();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    final provider = Provider.of<ShowProvider>(context, listen: false);
    if (query.isNotEmpty) {
      provider.searchShows(query);
    } else {
      provider.fetchPopularShows();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShowProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows App'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Row(
            children: [
              Switch(
                value: isDark,
                onChanged: themeProvider.toggleTheme,
                activeColor: Colors.red,
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _onSearch(),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search TV shows...',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                prefixIcon:
                    Icon(Icons.search, color: textColor.withOpacity(0.7)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: textColor.withOpacity(0.7)),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (provider.isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            )
          else if (provider.shows.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No results found',
                  style: TextStyle(color: textColor.withOpacity(0.7)),
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount: provider.shows.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2 / 3,
                        ),
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
                    if (provider.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}