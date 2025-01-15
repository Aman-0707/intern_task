import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intern_task/description.dart';
import 'package:intl/intl.dart'; // For date formatting

class SSWebScraperScreen extends StatefulWidget {
  @override
  _WebScraperScreenState createState() => _WebScraperScreenState();
}

class _WebScraperScreenState extends State<SSWebScraperScreen> {
  List<Map<String, String>> _scrapedData = [];
  List<Map<String, String>> _scrapednxtData = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    scrapeAllData(); // Scrape both websites at once
  }

  Future<void> scrapeAllData() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    await Future.wait([scrapeWebsite(), scrapeNxtWebsite()]);

    // Merge scraped data
    setState(() {
      _scrapedData.addAll(_scrapednxtData);
      _isLoading = false; // Hide loading indicator
    });
  }

  Future<void> scrapeWebsite() async {
    const url = 'https://www.sharesansar.com/category/dividend-right-bonus';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parse(response.body);

        final articles = document.querySelectorAll('.featured-news-list');

        for (final article in articles) {
          final imgElement = article.querySelector('img');
          final imageUrl = imgElement?.attributes['src'] ?? '';

          final aElement = article.querySelector('a');
          final link = aElement?.attributes['href'] ?? '';

          final titleElement = article.querySelector('.featured-news-title');
          final title = titleElement?.text.trim() ?? 'No title available';

          final dateElement = article.querySelector('p span.text-org');
          final dateText = dateElement?.text.trim() ?? 'Unknown date';

          DateTime? parsedDate;
          try {
            parsedDate = DateFormat('EEEE, MMMM d, yyyy').parse(dateText);
          } catch (_) {
            parsedDate = null;
          }

          _scrapedData.add({
            'title': title,
            'image': imageUrl,
            'a': link,
            'date': parsedDate != null
                ? DateFormat('yyyy-MM-dd').format(parsedDate)
                : 'Invalid date',
          });
        }
      } else {
        print('Failed to load main webpage: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while scraping main website: $e');
    }
  }

  ///nxt page
  Future<void> scrapeNxtWebsite() async {
    const url =
        'https://www.sharesansar.com/category/dividend-right-bonus?cursor=eyJwdWJsaXNoZWRfZGF0ZSI6IjIwMjUtMDEtMTMgMTQ6MjY6MDQiLCJfcG9pbnRzVG9OZXh0SXRlbXMiOnRydWV9';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parse(response.body);

        final articles = document.querySelectorAll('.featured-news-list');

        for (final article in articles) {
          final imgElement = article.querySelector('img');
          final imageUrl = imgElement?.attributes['src'] ?? '';

          final aElement = article.querySelector('a');
          final link = aElement?.attributes['href'] ?? '';

          final titleElement = article.querySelector('.featured-news-title');
          final title = titleElement?.text.trim() ?? 'No title available';

          final dateElement = article.querySelector('p span.text-org');
          final dateText = dateElement?.text.trim() ?? 'Unknown date';

          DateTime? parsedDate;
          try {
            parsedDate = DateFormat('EEEE, MMMM d, yyyy').parse(dateText);
          } catch (_) {
            parsedDate = null;
          }

          _scrapednxtData.add({
            'title': title,
            'image': imageUrl,
            'a': link,
            'date': parsedDate != null
                ? DateFormat('yyyy-MM-dd').format(parsedDate)
                : 'Invalid date',
          });
        }
      } else {
        print('Failed to load next webpage: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while scraping next website: $e');
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DesriptionScreen(
                                        title: _scrapedData[index]['title']!,
                                        imgUrl: _scrapedData[index]['image']!,
                                        date: _scrapedData[index]['date']!,
                                        descurl: _scrapedData[index]['a']!,
                                      )));
                        },
                        child: Card(
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

                                // Title and Date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _scrapedData[index]['title']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Date: ${_scrapedData[index]['date']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.orange,
                                        ),
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
    );
  }
}
