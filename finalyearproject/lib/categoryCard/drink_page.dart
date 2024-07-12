import 'package:finalyearproject/detailCategory/drink_detail_page.dart';
import 'package:finalyearproject/search/list_places.dart';
import 'package:flutter/material.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({super.key});

  @override
  _DrinkPageState createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter the places from the 'Drinks' category based on the search query
    List<Place> drinks = placeCategories
        .firstWhere((category) => category.category == 'Drinks')
        .places;
    List<Place> filteredDrinks = drinks
        .where((drink) =>
            drink.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: const Text('Drink'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.orange),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.orange),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDrinks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(filteredDrinks[index].image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(filteredDrinks[index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              filteredDrinks[index].rating.toString(),
                              style: const TextStyle(color: Colors.orange),
                            ),
                            const SizedBox(width: 4),
                            _buildStarRating(filteredDrinks[index].rating),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrinkDetailPage(
                            drinkDetails: {
                              'name': filteredDrinks[index].title,
                              'image': filteredDrinks[index].image,
                              'overview': filteredDrinks[index].overview,
                              'description': filteredDrinks[index].description,
                              'tags': filteredDrinks[index].tags,
                              'latitude': filteredDrinks[index].latitude, // Add latitude
                              'longitude': filteredDrinks[index].longitude, // Add longitude
                            },
                            placeDetails: {},
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(Icon(
        i <= rating ? Icons.star : Icons.star_border,
        color: Colors.orange,
        size: 16,
      ));
    }
    return Row(children: stars);
  }
}
