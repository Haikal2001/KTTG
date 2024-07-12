import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String title;
  final double rating;
  final String image;
  final String overview;
  final String description;
  final List<String> tags;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final double? height;
  final bool isFavoritePage;

  const PlaceCard({
    super.key,
    required this.title,
    required this.rating,
    required this.image,
    required this.overview,
    required this.description,
    required this.tags,
    required this.onTap,
    required this.onDelete,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.height,
    this.isFavoritePage = false, required favorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Ensure this line is correct
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        height: height ?? 100, // Use the height if provided, otherwise default to 100
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Add this line to handle long titles
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.orange),
                      ),
                      const SizedBox(width: 4),
                      _buildStarRating(rating),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavoritePage ? Icons.delete : Icons.arrow_forward_ios,
                color: Colors.orange,
                size: 20,
              ),
              onPressed: isFavoritePage ? onDelete : onTap,
            ),
          ],
        ),
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
