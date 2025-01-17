import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pixelsapp/DartObject.dart';
import 'package:pixelsapp/baseUrl.dart';

import 'ImagePage.dart';
import 'SearchImage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  DartObject? obj; // Nullable since it might be null initially

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    fetchData(); // Fetch data on initialization
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the TabController to prevent memory leaks
    super.dispose();
  }

  /// Generates a random query using predefined terms
  String generateRandomQuery() {
    const searchTerms = [
      'nature', 'ocean', 'sky', 'animals', 'flowers',
      'cartoons', 'actors', 'actress', 'house', 'superheros',
      'cars', 'bikes', 'hills', 'themes', 'wallpapers'
    ];

    final random = Random();
    List<String> mixedQueries = [];

    // Define how many of each type you want in the mix
    final queryCounts = {
      'nature': 2,
      'ocean': 1,
      'sky': 1,
      'animals': 2,
      'flowers': 1,
      'cartoons': 1,
      'hills': 3,
      'themes': 1,
      'wallpapers': 2,
    };

    // Generate a mix based on the counts
    for (var entry in queryCounts.entries) {
      for (int i = 0; i < entry.value; i++) {
        mixedQueries.add(entry.key);
      }
    }

    // Shuffle the list to randomize order
    mixedQueries.shuffle(random);

    // Pick one random query from the mixed list
    return mixedQueries[random.nextInt(mixedQueries.length)];
  }


  /// Fetches data from the API
  Future<void> fetchData() async {
    try {
      final randomQuery = generateRandomQuery(); // Generate a mixed random query
      final randomPage = Random().nextInt(10) + 1; // Random page between 1 and 10
      var url = Uri.parse(baseUrl(randomQuery, 20, randomPage));
      var response = await http.get(url, headers: header);

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        setState(() {
          obj = DartObject.fromJson(decode);
        });
        print('Fetched images for query: $randomQuery');
        print(response.body);
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        title: const Text("PixelsImages"),
        centerTitle: true,
        elevation: 5,
        bottom: TabBar(
          controller: controller,
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Images", style: TextStyle(color: Colors.white)),
                  Icon(Icons.image, color: Colors.white),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Search", style: TextStyle(color: Colors.white)),
                  Icon(Icons.search, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
      body: (obj == null)
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: controller,
        children: [
          Imagepage(obj: obj!, fetchData: fetchData), // Pass `fetchData` properly
          Searchimage(obj: obj!), // Corrected capitalization
        ],
      ),
    );
  }
}
