import 'package:finalyearproject/homescreen/popular_places.dart';
import 'package:flutter/material.dart';
import 'package:finalyearproject/categoryCard/drink_page.dart';
import 'package:finalyearproject/categoryCard/food_page.dart';
import 'package:finalyearproject/categoryCard/history_page.dart';
import 'package:finalyearproject/categoryCard/shop_page.dart';
import 'package:finalyearproject/categoryCard/stay_page.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 35, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 70,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: const [
            CategoryCard(title: "Stay", icon: Icons.hotel, page: StayPage()),
            CategoryCard(title: "Food", icon: Icons.fastfood, page: FoodPage()),
            CategoryCard(title: "Drink", icon: Icons.local_drink, page: DrinkPage()),
            CategoryCard(title: "History", icon: Icons.history_edu, page: HistoryPage()),
            CategoryCard(title: "Shop", icon: Icons.shopping_cart, page: ShopPage()),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PopularPlaces(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Category",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const CategoryList(),
          const SizedBox(height: 20), // Add spacing below the category cards
        ],
      ),
    );
  }
}
