import 'package:flutter/material.dart';
import 'package:finalyearproject/search/list_places.dart';
import 'package:finalyearproject/detailCategory/drink_detail_page.dart';
import 'package:finalyearproject/detailCategory/food_detail_page.dart';
import 'package:finalyearproject/detailCategory/history_detail_page.dart';
import 'package:finalyearproject/detailCategory/shop_detail_page.dart';
import 'package:finalyearproject/detailCategory/stay_detail_page.dart';

class PopularPlaces extends StatelessWidget {
  const PopularPlaces({super.key});

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

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.orange, size: 16);
        } else if (index == fullStars && halfStar) {
          return Icon(Icons.star_half, color: Colors.orange, size: 16);
        } else {
          return Icon(Icons.star_border, color: Colors.orange, size: 16);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final highRatedPlaces = placeCategories.expand((category) => category.places).where((place) => place.rating >= 4.5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "See all",
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: highRatedPlaces.length,
            itemBuilder: (context, index) {
              final place = highRatedPlaces[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _navigateToDetailPage(context, place),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.asset(
                            place.image,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            place.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              _buildRatingStars(place.rating),
                              const SizedBox(width: 4),
                              Text(
                                '${place.rating}',
                                style: const TextStyle(fontSize: 14, color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
