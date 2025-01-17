import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pixelsapp/DartObject.dart';

import 'PhotoViewer.dart';
import 'baseUrl.dart';

class Searchimage extends StatefulWidget {
  const Searchimage({super.key, required DartObject obj});

  @override
  State<Searchimage> createState() => _SearchimageState();
}

class _SearchimageState extends State<Searchimage> {
  DartObject? obj; // Holds fetched data
  TextEditingController searchController = TextEditingController();
  bool isLoading = false; // To show a loading indicator
  bool hasSearched = false; // To track if a search has been performed

  /// Fetches data from the API
  Future<void> fetchData(String query) async {
    if (query.isEmpty) return;

    try {
      setState(() {
        isLoading = true;
        hasSearched = true; // Mark that a search has been performed
      });

      // Use the query input from the user
      var url = Uri.parse(baseUrl(query, 20, 1)); // Assuming page=1 for the initial search
      var response = await http.get(url, headers: header);

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        setState(() {
          obj = DartObject.fromJson(decode);
        });
        print('Fetched images for query: $query');
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Builds the list of images with the photographer's name
  Widget buildList() {
    if (obj == null || obj!.photos == null || obj!.photos!.isEmpty) {
      return const Center(
        child: Text("No images found for your query."),
      );
    }

    return ListView.builder(
      itemCount: obj!.photos!.length,
      itemBuilder: (context, index) {
        final photo = obj!.photos![index];
        final imageUrl = photo.src?.landscape ?? 'https://via.placeholder.com/150';
        final photographer = photo.photographer ?? 'Unknown Photographer';

        return Hero(
          tag: photo.src?.landscape ?? 'defaultTag',
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Photoviewer(
                    url: photo.src?.landscape ?? '', // Pass the image URL
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8),
              elevation: 4,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      photographer, // Display photographer's name
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Images"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      obj = null; // Clear the image list
                      hasSearched = false; // Reset the search status
                    });
                  },
                ),
              ),
              onFieldSubmitted: (value) {
                fetchData(value); // Fetch data based on the search query
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasSearched
                ? buildList() // Show the list of images after a search
                : const Center(
              child: Text(
                "No images yet. Start searching!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
