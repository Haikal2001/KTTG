import 'package:finalyearproject/Map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryDetailPage extends StatefulWidget {
  final Map<String, dynamic> historyDetails;

  const HistoryDetailPage({super.key, required this.historyDetails});

  @override
  _HistoryDetailPageState createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.historyDetails['name']) ?? false;
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool(widget.historyDetails['name'], isFavorite);
    });
    _updateFavoriteList(isFavorite);
  }

  void _updateFavoriteList(bool isFavorite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteNames = prefs.getStringList('favoriteNames') ?? [];
    List<String> favoriteImages = prefs.getStringList('favoriteImages') ?? [];
    List<String> favoriteOverviews = prefs.getStringList('favoriteOverviews') ?? [];
    List<String> favoriteDescriptions = prefs.getStringList('favoriteDescriptions') ?? [];
    List<String> favoriteTags = prefs.getStringList('favoriteTags') ?? [];

    if (isFavorite) {
      favoriteNames.add(widget.historyDetails['name']);
      favoriteImages.add(widget.historyDetails['image']);
      favoriteOverviews.add(widget.historyDetails['overview']);
      favoriteDescriptions.add(widget.historyDetails['description']);
      favoriteTags.add(widget.historyDetails['tags'].join(','));
    } else {
      int index = favoriteNames.indexOf(widget.historyDetails['name']);
      if (index != -1) {
        favoriteNames.removeAt(index);
        favoriteImages.removeAt(index);
        favoriteOverviews.removeAt(index);
        favoriteDescriptions.removeAt(index);
        favoriteTags.removeAt(index);
      }
    }

    prefs.setStringList('favoriteNames', favoriteNames);
    prefs.setStringList('favoriteImages', favoriteImages);
    prefs.setStringList('favoriteOverviews', favoriteOverviews);
    prefs.setStringList('favoriteDescriptions', favoriteDescriptions);
    prefs.setStringList('favoriteTags', favoriteTags);
  }

  @override
  Widget build(BuildContext context) {
    final String placeName = widget.historyDetails['name'];
    final String overview = widget.historyDetails['overview'];
    final String description = widget.historyDetails['description'];
    final String image = widget.historyDetails['image'];
    final List<String> tags = List<String>.from(widget.historyDetails['tags']);
    final double latitude = widget.historyDetails['latitude'];
    final double longitude = widget.historyDetails['longitude'];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      placeName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 8),
              const Text(
                'OVERVIEW',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                overview,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              const Text(
                'DESCRIPTION',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'TAGS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: tags.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Colors.orange.shade100,
                )).toList(),
              ),
              const SizedBox(height: 60),  // Adding space for the button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(
                  latitude: latitude,
                  longitude: longitude,
                  placeName: placeName,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            'Get Your Location',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
