import 'package:finalyearproject/search/list_places.dart';
import 'package:flutter/material.dart';
import 'package:finalyearproject/search/place_card.dart';
import 'package:finalyearproject/detailCategory/drink_detail_page.dart';
import 'package:finalyearproject/detailCategory/food_detail_page.dart';
import 'package:finalyearproject/detailCategory/history_detail_page.dart';
import 'package:finalyearproject/detailCategory/shop_detail_page.dart';
import 'package:finalyearproject/detailCategory/stay_detail_page.dart';

class SearchHistory {
  final List<Place> places;

  SearchHistory({required this.places});
}

class HistoryPage extends StatefulWidget {
  final List<Place> searchHistory;

  const HistoryPage({Key? key, required this.searchHistory}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Place> selectedPlaces = [];

  void _navigateToDetailPage(BuildContext context, Place place) {
    final category = placeCategories.firstWhere((category) =>
        category.places.contains(place));
    Widget detailPage;

    switch (category.category) {
      case 'Drinks':
        detailPage = DrinkDetailPage(drinkDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude,
          'longitude': place.longitude,
        }, placeDetails: {},);
        break;
      case 'Food':
        detailPage = FoodDetailPage(foodDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude,
          'longitude': place.longitude,
        });
        break;
      case 'Historical Sites':
        detailPage = HistoryDetailPage(historyDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude,
          'longitude': place.longitude,
        });
        break;
      case 'Shops':
        detailPage = ShopDetailPage(shopDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude,
          'longitude': place.longitude,
        });
        break;
      case 'Stays':
        detailPage = StayDetailPage(placeDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude,
          'longitude': place.longitude,
        });
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailPage),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Clear All History'),
              onTap: () {
                Navigator.pop(context);
                _showClearAllConfirmationDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_box),
              title: Text('Select Items to Clear'),
              onTap: () {
                Navigator.pop(context);
                _showSelectItemsModal(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showClearAllConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Clear All History'),
          content: Text('Are you sure you want to clear history?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Clear All'),
              onPressed: () {
                setState(() {
                  widget.searchHistory.clear();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSelectItemsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Items to Clear'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.searchHistory.length,
                  itemBuilder: (context, index) {
                    final place = widget.searchHistory[index];
                    return CheckboxListTile(
                      title: Text(place.title),
                      value: selectedPlaces.contains(place),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedPlaces.add(place);
                          } else {
                            selectedPlaces.remove(place);
                          }
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                selectedPlaces.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Clear Selected'),
              onPressed: () {
                _showClearSelectedConfirmationDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showClearSelectedConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Clear Selected Items'),
          content: Text('Are you sure you want to remove your selected places from the history?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Clear Selected'),
              onPressed: () {
                setState(() {
                  widget.searchHistory.removeWhere((place) => selectedPlaces.contains(place));
                  selectedPlaces.clear();
                });
                Navigator.pop(context); // Close the confirmation dialog
                Navigator.pop(context); // Close the select items dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the arrow navigation
        title: const Text('Search History'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showSettingsModal(context);
            },
          ),
        ],
      ),
      body: widget.searchHistory.isNotEmpty
          ? ListView.builder(
              itemCount: widget.searchHistory.length,
              itemBuilder: (context, index) {
                final place = widget.searchHistory[index];
                return PlaceCard(
                  title: place.title,
                  rating: place.rating,
                  image: place.image,
                  overview: place.overview,
                  description: place.description,
                  tags: place.tags,
                  onTap: () => _navigateToDetailPage(context, place),
                  onDelete: () {}, // Define the action when a place is deleted
                  isFavorite: false, // Provide a default value
                  onFavoriteToggle: () {}, 
                  height: 120, // Set a default height
                  isFavoritePage: false, favorite: null, // Default to false
                );
              },
            )
          : Center(
              child: Text(
                'No search history available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
    );
  }
}
