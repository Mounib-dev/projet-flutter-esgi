import 'package:flutter/material.dart';
import '../models/show.dart';
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String showId;
  const DetailScreen({super.key, required this.showId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService _apiService = ApiService();
  TVShow? _show;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final show = await _apiService.getShowDetails(widget.showId);
    setState(() {
      _show = show;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Details'),
        backgroundColor: Colors.indigo,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(_show!.image),
                      const SizedBox(height: 16),
                      Text(
                        _show!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(_show!.description),
                    ],
                  ),
                ),
              ),
    );
  }
}
