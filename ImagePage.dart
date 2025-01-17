import 'package:flutter/material.dart';
import 'package:pixelsapp/DartObject.dart';
import 'PhotoViewer.dart';

class Imagepage extends StatefulWidget {
  final DartObject obj;
  final Future<void> Function() fetchData; // Correctly type the fetchData function

  const Imagepage({super.key, required this.obj, required this.fetchData});

  @override
  State<Imagepage> createState() => _ImagepageState();
}

class _ImagepageState extends State<Imagepage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.fetchData, // Call the fetchData function correctly
      child: ListView.builder(
        itemCount: widget.obj.photos?.length ?? 0,
        itemBuilder: (context, index) {
          final photo = widget.obj.photos?[index];
          final imageUrl = photo?.src?.landscape ??
              'https://via.placeholder.com/150';
          final photographer = photo?.photographer ?? 'Unknown Photographer';

          return Hero(
            tag: photo?.src?.landscape ?? 'defaultTag', // Ensure unique tag
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Photoviewer(
                          url: '${photo?.src
                              ?.landscape}', // Pass the image URL to Photoviewer
                        ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error,
                                color: Colors.red); // Handle errors
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        photographer,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}