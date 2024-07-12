import 'package:finalyearproject/BottomNavigationBar/search_history_page.dart';
import 'package:finalyearproject/BottomNavigationBar/favorite_page.dart';
import 'package:finalyearproject/BottomNavigationBar/profile_page.dart';
import 'package:finalyearproject/BottomNavigationBar/recommendation_page.dart';
import 'package:finalyearproject/authentication/exit_confirmation_dialog.dart';
import 'package:finalyearproject/homescreen/category_card.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:finalyearproject/detailCategory/drink_detail_page.dart';
import 'package:finalyearproject/detailCategory/food_detail_page.dart';
import 'package:finalyearproject/detailCategory/history_detail_page.dart';
import 'package:finalyearproject/detailCategory/shop_detail_page.dart';
import 'package:finalyearproject/detailCategory/stay_detail_page.dart';
import 'package:finalyearproject/profile/user_profile_provider.dart';
import 'package:finalyearproject/search/list_places.dart';
import 'package:finalyearproject/search/place_card.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finalyearproject/authentication/travel.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  const HomeScreen({super.key, required this.email});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  double _selectedRating = 0.0; // Store the selected rating for filtering
  double _tempSelectedRating = 0.0; // Temporary rating for filter dialog
  List<Place> _searchResults = [];
  List<Place> searchHistory = []; // Store search history
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    await FirebaseAuth.instance.signOut();
    userProfileProvider.resetUserData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TravelPage()),
    );
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(), // Home Page
      const RecommendationPage(), // Explore Page
      HistoryPage(searchHistory: searchHistory), // History Page
      const FavoritePage(), // Favorite Page
      ProfilePage(email: widget.email), // Profile Page with user email
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeMessage();
    });
  }

  void _showWelcomeMessage() {
    final snackBar = SnackBar(
      content: Text('You are successfully logged in with ${widget.email}'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filterSearchResults(); // Update to filter search results based on query and rating
    });
  }

  void _clearSearchQuery() {
    _searchController.clear();
    _updateSearchQuery('');
  }

  void _addPlaceToHistory(Place place) {
    setState(() {
      if (!searchHistory.contains(place)) {
        searchHistory.add(place);
      }
    });
  }

  void _navigateToDetailPage(Place place) {
    _addPlaceToHistory(place);
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
          'latitude': place.latitude, // Ensure latitude is not null
          'longitude': place.longitude, // Ensure longitude is not null
        }, placeDetails: {},);
        break;
      case 'Food':
        detailPage = FoodDetailPage(foodDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude, // Ensure latitude is not null
          'longitude': place.longitude, // Ensure longitude is not null
        });
        break;
      case 'Historical Sites':
        detailPage = HistoryDetailPage(historyDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude, // Ensure latitude is not null
          'longitude': place.longitude, // Ensure longitude is not null
        });
        break;
      case 'Shops':
        detailPage = ShopDetailPage(shopDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude, // Ensure latitude is not null
          'longitude': place.longitude, // Ensure longitude is not null
        });
        break;
      case 'Stays':
        detailPage = StayDetailPage(placeDetails: {
          'name': place.title,
          'image': place.image,
          'overview': place.overview,
          'description': place.description,
          'tags': place.tags,
          'latitude': place.latitude, // Ensure latitude is not null
          'longitude': place.longitude, // Ensure longitude is not null
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.orange[50], // Travel-themed background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Row(
                children: const [
                  Icon(Icons.filter_alt, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('Filter by Rating', style: TextStyle(color: Colors.orange)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: _tempSelectedRating,
                    min: 0,
                    max: 5,
                    divisions: 50, // Allow steps of 0.1
                    label: _tempSelectedRating.toStringAsFixed(1),
                    activeColor: Colors.orange,
                    inactiveColor: Colors.orange[100],
                    onChanged: (double value) {
                      setState(() {
                        _tempSelectedRating = value;
                      });
                    },
                  ),
                  Text(
                    'Minimum Rating: ${_tempSelectedRating.toStringAsFixed(1)}',
                    style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempSelectedRating = _selectedRating;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedRating = _tempSelectedRating;
                      _filterSearchResults();
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _filterSearchResults() {
    setState(() {
      _searchResults = searchPlaces(_searchQuery).where((place) {
        return place.rating >= _selectedRating;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitConfirmationDialog(context),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
        body: _selectedIndex == 0
            ? Stack(
                children: [
                  Container(
                    color: Colors.orange, // Use the orange color for the app bar
                    height: 250, // Adjust height as needed
                  ),
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHomeHeader(context),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 243, 224, 1), // Apply the desired background color for the lower part
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: _searchQuery.isEmpty
                                ? _pages[_selectedIndex]
                                : _buildSearchResults(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : _pages[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.orange,
          buttonBackgroundColor: Colors.orange,
          height: 60,
          items: const <Widget>[
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.explore, size: 30, color: Colors.white),
            Icon(Icons.history, size: 30, color: Colors.white), // Updated to history icon
            Icon(Icons.favorite, size: 30, color: Colors.white),
            Icon(Icons.person, size: 30, color: Colors.white),
          ],
          onTap: _onItemTapped,
          index: _selectedIndex,
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }

  Widget _buildHomeHeader(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.orange, // Use your desired background color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: userProfileProvider.profileImageUrl.isNotEmpty
                        ? NetworkImage(userProfileProvider.profileImageUrl)
                        : null,
                    child: userProfileProvider.profileImageUrl.isEmpty
                        ? Icon(Icons.person, size: 30, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      Text(
                        userProfileProvider.displayName, // Display the username from UserProfileProvider
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        widget.email, // Display the user email
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.white),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: _signOut,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Discover the Best Place\nTo Travel",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _updateSearchQuery,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearchQuery,
                          )
                        : null,
                    hintText: "Search Location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.orange),
                  onPressed: _showFilterDialog, // Show the filter dialog on press
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final place = _searchResults[index];
        return PlaceCard(
          title: place.title,
          rating: place.rating,
          image: place.image,
          overview: place.overview,
          description: place.description,
          tags: place.tags,
          onTap: () => _navigateToDetailPage(place),
          onDelete: () {}, // Keep the onDelete function if necessary
          isFavorite: false, // Provide a default value
          onFavoriteToggle: () {},
          height: 120, // Set a default height for non-favorite pages
          isFavoritePage: false, favorite: null, // Default to false for non-favorite pages
        );
      },
    );
  }
}
