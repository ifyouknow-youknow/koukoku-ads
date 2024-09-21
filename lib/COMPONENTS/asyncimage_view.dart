import 'package:flutter/material.dart';
import 'package:koukoku_ads/MODELS/firebase.dart'; // Adjust the import path as needed

class AsyncImageView extends StatefulWidget {
  const AsyncImageView({
    super.key,
    this.imagePath = "Images/cocoimage.png",
    this.width = 100, // Default width
    this.height = 100, // Default height
    this.radius = 0, // Default radius for container
    this.objectFit = BoxFit.contain, // Default fit
  });

  final String imagePath;
  final double width;
  final double height;
  final double radius;
  final BoxFit objectFit; // Added objectFit property

  @override
  _AsyncImageViewState createState() => _AsyncImageViewState();
}

class _AsyncImageViewState extends State<AsyncImageView> {
  String imageUrl = ""; // State variable to hold the fetched URL

  @override
  void initState() {
    super.initState();
    fetchImageUrl(); // Call async function in initState
  }

  Future<void> fetchImageUrl() async {
    try {
      final url = await storage_DownloadMedia(widget.imagePath);
      if (mounted) {
        // Check if the widget is still mounted before updating state
        setState(() {
          imageUrl = url ??
              ""; // Update state with fetched URL, or empty string if null
        });
      }
    } catch (error) {
      print("Error fetching image URL: $error");
      // Handle error gracefully, e.g., show error message to user
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: widget.width,
                height: widget.height,
                fit: widget.objectFit, // Use the objectFit property
              )
            : const Center(
                child:
                    CircularProgressIndicator()), // Show loading indicator while fetching data
      ),
    );
  }
}
