import 'package:finalyearproject/detailCategory/drink_detail_page.dart';
import 'package:finalyearproject/detailCategory/food_detail_page.dart';
import 'package:finalyearproject/detailCategory/history_detail_page.dart';
import 'package:finalyearproject/detailCategory/shop_detail_page.dart';
import 'package:finalyearproject/detailCategory/stay_detail_page.dart';
import 'package:finalyearproject/recommendation/tags.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalyearproject/search/list_places.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final Map<String, bool> seeMore = {
    'Stays': false,
    'Shops': false,
    'Historical Sites': false,
    'Food': false,
    'Drinks': false,
  };

  final Map<String, Set<String>> selectedTags = {
    'Stays': {},
    'Shops': {},
    'Historical Sites': {},
    'Food': {},
    'Drinks': {},
  };

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Place> _searchResults = [];
  List<Place> _tagSearchResults = [];
  List<String> _allTags = [];
  List<String> _filteredTags = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedTags();
    _loadAllTags();
  }

  // Load selected tags from SharedPreferences
  Future<void> _loadSelectedTags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTags.forEach((key, value) {
        selectedTags[key] = (prefs.getStringList(key) ?? []).toSet();
      });
    });
  }

  // Save selected tags to SharedPreferences
  Future<void> _saveSelectedTags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedTags.forEach((key, value) {
      prefs.setStringList(key, value.toList());
    });
  }
  // Load all tags from predefined categories
  void _loadAllTags() {
    _allTags = categories.values.expand((tags) => tags).toSet().toList();
  }
  void _toggleSeeMore(String category) {
    setState(() {
      seeMore[category] = !seeMore[category]!;
    });
  }

  // Toggle tag selection
  void _toggleTag(String category, String tag) {
    setState(() {
      if (selectedTags[category]!.contains(tag)) {
        selectedTags[category]!.remove(tag);
      } else {
        selectedTags[category]!.add(tag);
      }
    });
    _saveSelectedTags();
  }

  //Content-Based Filtering
  List<Place> _getFilteredPlaces() {
    List<String> allSelectedTags = selectedTags.values.expand((tags) => tags).toList();
    if (allSelectedTags.isEmpty) {
      return [];
    }

    List<Place> filteredPlaces = [];
    for (var category in placeCategories) {
      for (var place in category.places) {
        if (allSelectedTags.any((tag) => place.tags.contains(tag))) {
          filteredPlaces.add(place);
        }
      }
    }
    return filteredPlaces;
  }

  // Update search query and results
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _searchResults = searchPlaces(query); // Search places based on the query
      _filteredTags = _allTags.where((tag) => tag.toLowerCase().contains(query.toLowerCase())).toList(); // Filter tags based on the query
      _tagSearchResults.clear(); // Clear tag search results when the query changes
    });
  }

  // Clear search query and results
  void _clearSearchQuery() {
    setState(() {
      _searchQuery = '';
      _searchResults.clear(); // Clear search results when the query is cleared
      _filteredTags.clear(); // Clear filtered tags when the query is cleared
      _tagSearchResults.clear(); // Clear tag search results when the query is cleared
    });
    _searchController.clear(); // Clear the search input field
  }

  //Recommend other places that have similarity with the places that user like
  List<Place> _getSimilarPlaces(Place selectedPlace) {
    List<Place> similarPlaces = [];
    for (var category in placeCategories) {
      for (var place in category.places) {
        if (place.tags.any((tag) => selectedPlace.tags.contains(tag)) &&
            place != selectedPlace) {
          similarPlaces.add(place);
        }
      }
    }
    return similarPlaces;
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.orange, size: 16); // Full star icon
        } else if (index == fullStars && halfStar) {
          return Icon(Icons.star_half, color: Colors.orange, size: 16); // Half star icon
        } else {
          return Icon(Icons.star_border, color: Colors.orange, size: 16); // Empty star icon
        }
      }),
    );
  }

  // Show tags dialog for a specific category
  void _showTagsDialog(String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final tags = categories[category]!;
        Set<String> tempSelectedTags = Set<String>.from(selectedTags[category]!);

        return AlertDialog(
          title: Text('Tags for $category'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: tags.map((tag) {
                    final isSelected = tempSelectedTags.contains(tag);
                    return ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (isSelected) {
                            tempSelectedTags.remove(tag); // Remove tag if selected
                          } else {
                            tempSelectedTags.add(tag); // Add tag if not selected
                          }
                        });
                      },
                      selectedColor: Colors.orange,
                      backgroundColor: isSelected
                          ? Colors.orange
                          : Color.fromRGBO(255, 243, 224, 1),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedTags[category] = tempSelectedTags; // Save selected tags to the category
                });
                _saveSelectedTags(); // Persist selected tags
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save', style: TextStyle(color: Colors.orange)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog without saving
              child: Text('Cancel', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetailPage(Place place) {
    Widget detailPage;

    if (place.tags.any((tag) => categories['Stays']!.contains(tag))) {
      detailPage = StayDetailPage(placeDetails: {
        'name': place.title,
        'overview': place.overview,
        'description': place.description,
        'image': place.image,
        'tags': place.tags,
        'latitude': place.latitude, // Ensure latitude is not null
        'longitude': place.longitude, // Ensure longitude is not null
      });
    } else if (place.tags.any((tag) => categories['Shops']!.contains(tag))) {
      detailPage = ShopDetailPage(shopDetails: {
        'name': place.title,
        'overview': place.overview,
        'description': place.description,
        'image': place.image,
        'tags': place.tags,
        'latitude': place.latitude, // Ensure latitude is not null
        'longitude': place.longitude, // Ensure longitude is not null
      });
    } else if (place.tags.any((tag) => categories['Historical Sites']!.contains(tag))) {
      detailPage = HistoryDetailPage(historyDetails: {
        'name': place.title,
        'overview': place.overview,
        'description': place.description,
        'image': place.image,
        'tags': place.tags,
        'latitude': place.latitude, // Ensure latitude is not null
        'longitude': place.longitude, // Ensure longitude is not null
      });
    } else if (place.tags.any((tag) => categories['Food']!.contains(tag))) {
      detailPage = FoodDetailPage(foodDetails: {
        'name': place.title,
        'overview': place.overview,
        'description': place.description,
        'image': place.image,
        'tags': place.tags,
        'latitude': place.latitude, // Ensure latitude is not null
        'longitude': place.longitude, // Ensure longitude is not null
      });
    } else if (place.tags.any((tag) => categories['Drinks']!.contains(tag))) {
      detailPage = DrinkDetailPage(drinkDetails: {
        'name': place.title,
        'overview': place.overview,
        'description': place.description,
        'image': place.image,
        'tags': place.tags,
        'latitude': place.latitude, // Ensure latitude is not null
        'longitude': place.longitude, // Ensure longitude is not null
      }, placeDetails: {});
    } else {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => detailPage, // Navigate to the appropriate detail page
      ),
    );
  }

  void _showSimilarPlacesDialog(Place place) {
    final similarPlaces = _getSimilarPlaces(place);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Similar Places to ${place.title}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: similarPlaces.map((similarPlace) {
                return ListTile(
                  leading: Icon(Icons.search, color: Colors.orange),
                  title: Text(similarPlace.title),
                  onTap: () {
                    Navigator.of(context).pop();
                    _navigateToDetailPage(similarPlace); // Navigate to the detail page of the similar place
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _onTagSelected(String tag) {
    setState(() {
      _searchQuery = tag;
      _searchController.text = tag;
      _tagSearchResults = _getPlacesByTag(tag); // Filter places by the selected tag
      _searchResults.clear(); // Clear previous search results
      _filteredTags.clear(); // Clear filtered tags
    });
  }

  List<Place> _getPlacesByTag(String tag) {
    List<Place> filteredPlaces = [];
    for (var category in placeCategories) {
      for (var place in category.places) {
        if (place.tags.contains(tag)) {
          filteredPlaces.add(place); // Add place if it contains the tag
        }
      }
    }
    return filteredPlaces;
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = _getFilteredPlaces(); // Get places filtered by selected tags

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the arrow navigation
        title: const Text('Recommendations'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              color: Colors.orange,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Find your places here based on what you like", // Search hint text
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/guide.jpg',
                        width: 80,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: _updateSearchQuery,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearchQuery,
                            )
                          : null,
                      hintText: 'Search for places or tags...', // Search input hint
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_searchQuery.isNotEmpty && _filteredTags.isNotEmpty) ...[
                      const Text(
                        'Tags', // Display filtered tags
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _filteredTags.map((tag) {
                          return GestureDetector(
                            onTap: () => _onTagSelected(tag),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.search, color: Colors.orange),
                                  const SizedBox(width: 8),
                                  Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.orange,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (_searchQuery.isNotEmpty && _searchResults.isNotEmpty) ...[
                      const Text(
                        'Search Results', // Display search results
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._searchResults.map((place) {
                        return ListTile(
                          leading: const Icon(Icons.search, color: Colors.orange),
                          title: Text(place.title),
                          onTap: () => _showSimilarPlacesDialog(place),
                        );
                      }).toList(),
                    ],
                    if (_tagSearchResults.isNotEmpty) ...[
                      const Text(
                        'Recommendations', // Display tag-based recommendations
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._tagSearchResults.map((place) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 4.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                place.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              place.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                _buildRatingStars(place.rating),
                                const SizedBox(width: 8),
                                Text(
                                  '${place.rating}',
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                            onTap: () => _navigateToDetailPage(place),
                          ),
                        );
                      }).toList(),
                    ],
                    const SizedBox(height: 16),
                    ...categories.keys.map((category) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.label, color: Colors.orange),
                                onPressed: () => _showTagsDialog(category),
                              ),
                            ],
                          ),
                          if (selectedTags[category]!.isNotEmpty)
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: selectedTags[category]!.map((tag) {
                                return ChoiceChip(
                                  label: Text(tag),
                                  selected: true,
                                  onSelected: (selected) => _toggleTag(category, tag),
                                  selectedColor: Colors.orange,
                                  backgroundColor: Color.fromRGBO(255, 243, 224, 1),
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    }),
                    if (filteredPlaces.isNotEmpty) ...[
                      const SizedBox(height: 16.0),
                      const Text(
                        'Recommendation Places', // Display filtered places
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8.0),
                      ...filteredPlaces.map((place) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 4.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                place.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              place.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                _buildRatingStars(place.rating),
                                const SizedBox(width: 8),
                                Text(
                                  '${place.rating}',
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                            onTap: () => _navigateToDetailPage(place),
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
