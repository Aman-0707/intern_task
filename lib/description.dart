import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intern_task/datbaseService.dart'; // Update import according to your project structure

class DesriptionScreen extends StatefulWidget {
  final String title;
  final Uint8List imgUrl;
  final String date;
  final String descurl;

  DesriptionScreen({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.date,
    required this.descurl,
  });

  @override
  State<DesriptionScreen> createState() => _DesriptionScreenState();
}

class _DesriptionScreenState extends State<DesriptionScreen> {
  // String? _description; // Holds the fetched description
  bool _isLoading = true; // To show loading state

  @override
  void initState() {
    super.initState();
    // _scrapeDescription();
    // _loadDescription();
  }

  // // Function to load the description from the database first
  // Future<void> _loadDescription() async {
  //   // First, try to load the description from the database
  //   String? storedDescription =
  //       await DatabaseHelper().getDescription(widget.title);

  //   if (storedDescription != null) {
  //     // If the description is found in the database, set it
  //     setState(() {
  //       _description = storedDescription;
  //       _isLoading = false;
  //     });
  //   } else {
  //     // If the description is not found, scrape it from the web
  //     _scrapeDescription();
  //   }
  // }

  // // Function to scrape the description from the article's URL
  // Future<void> _scrapeDescription() async {
  //   try {
  //     final String url = widget.descurl;

  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final document = parse(response.body);

  //       // Adjust selector according to actual HTML structure
  //       final descriptionElement =
  //           document.querySelector('#newsdetail-content');
  //       final String description =
  //           descriptionElement?.text.trim() ?? 'No description available';

  //       // Save the description in the database
  //       await DatabaseHelper().insertDescription(widget.title, description);

  //       if (mounted) {
  //         setState(() {
  //           _description = description;
  //           _isLoading = false;
  //         });
  //       }
  //     } else {
  //       if (mounted) {
  //         setState(() {
  //           _description = 'Failed to load description';
  //           _isLoading = false;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _description = 'Error occurred while fetching description';
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                widget.date,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              Image.memory(
                widget.imgUrl,
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
              Text(
                widget.descurl,
                // _description ?? 'No description available',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
