import 'package:finalyearproject/detailCategory/food_detail_page.dart';
import 'package:finalyearproject/search/list_places.dart';
import 'package:flutter/material.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter the places from the 'Food' category based on the search query
    List<Place> foods = placeCategories
        .firstWhere((category) => category.category == 'Food')
        .places;
    List<Place> filteredFoods = foods
        .where((food) =>
            food.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: const Text('Food'),
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
              itemCount: filteredFoods.length,
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
                          image: AssetImage(filteredFoods[index].image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(filteredFoods[index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              filteredFoods[index].rating.toString(),
                              style: const TextStyle(color: Colors.orange),
                            ),
                            const SizedBox(width: 4),
                            _buildStarRating(filteredFoods[index].rating),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailPage(foodDetails: {
                            'name': filteredFoods[index].title,
                            'image': filteredFoods[index].image,
                            'overview': filteredFoods[index].overview,
                            'description': filteredFoods[index].description,
                            'tags': filteredFoods[index].tags,
                            'latitude': filteredFoods[index].latitude, // Add latitude
                            'longitude': filteredFoods[index].longitude, // Add longitude
                          }),
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
