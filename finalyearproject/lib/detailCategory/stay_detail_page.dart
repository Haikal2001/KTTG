import 'package:finalyearproject/Map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StayDetailPage extends StatefulWidget {
  final Map<String, dynamic> placeDetails;

  const StayDetailPage({super.key, required this.placeDetails});

  @override
  _StayDetailPageState createState() => _StayDetailPageState();
}

class _StayDetailPageState extends State<StayDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.placeDetails['name']) ?? false;
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool(widget.placeDetails['name'], isFavorite);
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
      favoriteNames.add(widget.placeDetails['name']);
      favoriteImages.add(widget.placeDetails['image']);
      favoriteOverviews.add(widget.placeDetails['overview']);
      favoriteDescriptions.add(widget.placeDetails['description']);
      favoriteTags.add(widget.placeDetails['tags'].join(','));
    } else {
      int index = favoriteNames.indexOf(widget.placeDetails['name']);
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
    final place = widget.placeDetails;
    final double latitude = place['latitude'];
    final double longitude = place['longitude'];

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
                    image: AssetImage(place['image']),
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
                      place['name'],
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
                place['overview'],
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
                place['description'],
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
                children: place['tags'].map<Widget>((tag) => Chip(
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
                  placeName: place['name'],
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
