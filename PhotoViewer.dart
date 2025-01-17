import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Photoviewer extends StatefulWidget {
  final String url;  // Image URL to be passed from the previous screen

  const Photoviewer({super.key, required this.url});

  @override
  State<Photoviewer> createState() => _PhotoviewerState();
}

class _PhotoviewerState extends State<Photoviewer> {
  @override
  Widget build(BuildContext context) {
    // Ensure the image URL is not null or empty
    if (widget.url.isEmpty) {
      return Scaffold(
        body: const Center(child: Text("No image available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 14,)),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(widget.url), // URL passed to the PhotoView widget
          minScale: PhotoViewComputedScale.contained,  // To ensure the image fits
          maxScale: PhotoViewComputedScale.covered,   // Maximum zoom scale
          heroAttributes: PhotoViewHeroAttributes(tag: widget.url), // Optional for transitions
          backgroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7), // To give a nice background
          ),
        ),
      ),
    );
  }
}