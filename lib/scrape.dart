import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class WebScraperScreen extends StatefulWidget {
  @override
  _WebScraperScreenState createState() => _WebScraperScreenState();
}

class _WebScraperScreenState extends State<WebScraperScreen> {
  List<Map<String, String>> _scrapedData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    scrapeWebsite();
  }

  Future<void> scrapeWebsite() async {
    const url = 'https://ekantipur.com/news'; // Replace with the target URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parse(response.body);

        // Extract relevant elements
        final articles = document.querySelectorAll('.image figure');

        setState(() {
          _scrapedData = [];

          for (final article in articles) {
            // Extract title from image 'alt' attribute
            final imgElement = article.querySelector('img');
            final title = imgElement?.attributes['alt'] ?? 'No title available';

            // Extract image URL
            final imageUrl = imgElement?.attributes['data-src'] ?? '';

            // Add scraped data
            _scrapedData.add({
              'title': title,
              'image': imageUrl,
            });
          }
        });
      } else {
        print('Failed to load webpage, Status code: ${response.statusCode}');
        setState(() {
          _scrapedData = [
            {'title': 'Failed to load website', 'image': ''}
          ];
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        _scrapedData = [
          {'title': 'Error occurred while scraping', 'image': ''}
        ];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Scraper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _scrapedData.isEmpty
                ? Center(
                    child: Text(
                      'No data scraped.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _scrapedData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              _scrapedData[index]['image'] != null &&
                                      _scrapedData[index]['image']!.isNotEmpty
                                  ? Image.network(
                                      _scrapedData[index]['image']!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white,
                                      ),
                                    ),

                              SizedBox(width: 10),

                              // Title
                              Expanded(
                                child: Text(
                                  _scrapedData[index]['title']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
