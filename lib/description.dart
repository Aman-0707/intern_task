import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
// For date formatting

class DesriptionScreen extends StatefulWidget {
  final String title;
  final String imgUrl;
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
  String? _description; // Holds the fetched description
  bool _isLoading = true; // To show loading state

  @override
  void initState() {
    super.initState();
    // Call the function to scrape description when the screen is initialized
    _scrapeDescription();
  }

  // Function to scrape the description from the article's URL
  Future<void> _scrapeDescription() async {
    try {
      final String url = widget.descurl; // Construct URL using encoded title

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parse(response.body);

        // Extract the description from the page (adjust selector according to actual HTML structure)
        final descriptionElement = document.querySelector(
            '#newsdetail-content'); // Assuming the description is inside this class
        final String description =
            descriptionElement?.text.trim() ?? 'No description available';

        setState(() {
          _description = description;
        });
      } else {
        setState(() {
          _description = 'Failed to load description';
        });
      }
    } catch (e) {
      setState(() {
        _description = 'Error occurred while fetching description';
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading after scraping is done
      });
    }
  }

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
              SizedBox(
                height: 20,
              ),
              Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.date,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 20),
              // Check if the description is available or still loading

              SizedBox(height: 20),
              Image.network(
                widget.imgUrl,
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      _description ?? 'No description available',
                      style: TextStyle(fontSize: 16),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
