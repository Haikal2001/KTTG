import 'package:finalyearproject/search/place_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> favoriteNames = [];
  List<String> favoriteImages = [];
  List<String> favoriteOverviews = [];
  List<String> favoriteDescriptions = [];
  List<String> favoriteTags = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritePlaces();
  }

  void _loadFavoritePlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteNames = prefs.getStringList('favoriteNames') ?? [];
      favoriteImages = prefs.getStringList('favoriteImages') ?? [];
      favoriteOverviews = prefs.getStringList('favoriteOverviews') ?? [];
      favoriteDescriptions = prefs.getStringList('favoriteDescriptions') ?? [];
      favoriteTags = prefs.getStringList('favoriteTags') ?? [];
    });
  }

  Future<void> _removeFavorite(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String removedName = favoriteNames[index];
      favoriteNames.removeAt(index);
      favoriteImages.removeAt(index);
      favoriteOverviews.removeAt(index);
      favoriteDescriptions.removeAt(index);
      favoriteTags.removeAt(index);
      prefs.setStringList('favoriteNames', favoriteNames);
      prefs.setStringList('favoriteImages', favoriteImages);
      prefs.setStringList('favoriteOverviews', favoriteOverviews);
      prefs.setStringList('favoriteDescriptions', favoriteDescriptions);
      prefs.setStringList('favoriteTags', favoriteTags);
      prefs.setBool(removedName, false); // Update favorite status in SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the arrow navigation
        title: const Text('Favorite Page'),
        backgroundColor: Colors.orange,
      ),
      body: favoriteNames.isEmpty
          ? const Center(
              child: Text(
                'No favorites added.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: favoriteNames.length,
              itemBuilder: (context, index) {
                return PlaceCard(
                  title: favoriteNames[index],
                  rating: 4.0, // Assuming you don't store the rating
                  image: favoriteImages[index],
                  overview: favoriteOverviews[index],
                  description: favoriteDescriptions[index],
                  tags: favoriteTags[index].split(','), // Assuming tags are stored as a comma-separated string
                  onTap: () {
                    // Handle navigation to the detail page if needed
                  },
                  onDelete: () => _removeFavorite(index),
                  isFavorite: true,
                  onFavoriteToggle: () {
                    _removeFavorite(index);
                    return null; // Ensure this callback returns null
                  },
                  height: 100, // Fixed height for favorite cards
                  isFavoritePage: true,
                  favorite: null, // Indicate that this is the favorite page
                );
              },
            ),
    );
  }
}
