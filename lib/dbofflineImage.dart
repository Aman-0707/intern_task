import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intern_task/datbaseService.dart';
import 'package:intern_task/description.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

class ImgWebScraperScreen extends StatefulWidget {
  @override
  _WebScraperScreenState createState() => _WebScraperScreenState();
}

class _WebScraperScreenState extends State<ImgWebScraperScreen> {
  List<Map<String, dynamic>> _scrapedData = [];

  @override
  void initState() {
    super.initState();
    scrapeWebsite();
    scrapenxtWebsite();
    loadArticles();
  }

  // Scraping Function
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
          Uint8List? imageData;
          if (imageUrl.isNotEmpty) {
            try {
              final imageResponse = await http.get(Uri.parse(imageUrl));
              if (imageResponse.statusCode == 200) {
                imageData = imageResponse.bodyBytes; // Convert image to bytes
              }
            } catch (e) {
              print('Error downloading image: $e');
            }
          }

          final aElement = article.querySelector('a');
          final link = aElement?.attributes['href'] ?? '';

          final titleElement = article.querySelector('.featured-news-title');
          final title = titleElement?.text.trim() ?? 'No title available';
          _loadDescription(title, link);
          final dateElement = article.querySelector('p span.text-org');
          final dateText = dateElement?.text.trim() ?? 'Unknown date';

          DateTime? parsedDate;
          try {
            parsedDate = DateFormat('EEEE, MMMM d, yyyy').parse(dateText);
          } catch (_) {
            parsedDate = null;
          }

          final articleData = {
            'title': title,
            'imageData': imageData,
            'link': link,
            'date': parsedDate != null
                ? DateFormat('yyyy-MM-dd').format(parsedDate)
                : 'Invalid date',
          };

          // Insert article data into the database
          await DatabaseHelper().insertArticle(articleData);
        }
        print('Scraping completed and data saved.');
        loadArticles();
      } else {
        print('Failed to load main webpage: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while scraping main website: $e');
    }
  }

  Future<void> scrapenxtWebsite() async {
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

          Uint8List? imageData;
          if (imageUrl.isNotEmpty) {
            try {
              final imageResponse = await http.get(Uri.parse(imageUrl));
              if (imageResponse.statusCode == 200) {
                imageData = imageResponse.bodyBytes; // Convert image to bytes
              }
            } catch (e) {
              print('Error downloading image: $e');
            }
          }
          final aElement = article.querySelector('a');
          final link = aElement?.attributes['href'] ?? '';

          final titleElement = article.querySelector('.featured-news-title');
          final title = titleElement?.text.trim() ?? 'No title available';
          _loadDescription(title, link);
          final dateElement = article.querySelector('p span.text-org');
          final dateText = dateElement?.text.trim() ?? 'Unknown date';

          DateTime? parsedDate;
          try {
            parsedDate = DateFormat('EEEE, MMMM d, yyyy').parse(dateText);
          } catch (_) {
            parsedDate = null;
          }

          final articleData = {
            'title': title,
            'imageData': imageData,
            'link': link,
            'date': parsedDate != null
                ? DateFormat('yyyy-MM-dd').format(parsedDate)
                : 'Invalid date',
          };

          // Insert article data into the database
          await DatabaseHelper().insertArticle(articleData);
        }
        print('Scraping completed and data saved.');
        loadArticles();
      } else {
        print('Failed to load main webpage: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while scraping main website: $e');
    }
  }

  // Load articles from the database
  Future<void> loadArticles() async {
    final articles = await DatabaseHelper().fetchAllArticles();
    setState(() {
      _scrapedData = articles;
    });
  }

  // Function to load the description from the database first
  Future<void> _loadDescription(String title, String link) async {
    // First, try to load the description from the database
    String? storedDescription = await DatabaseHelper().getDescription(title);

    if (storedDescription == null) {
      // If the description is not found, scrape it from the web
      _scrapeDescription(title, link);
    }
  }

  // Function to scrape the description from the article's URL
  Future<void> _scrapeDescription(String title, String link) async {
    final String url = link;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = parse(response.body);

      // Adjust selector according to actual HTML structure
      final descriptionElement = document.querySelector('#newsdetail-content');
      final String description =
          descriptionElement?.text.trim() ?? 'No description available';

      // Save the description in the database
      await DatabaseHelper().insertDescription(title, description);
    }
  }

  // Displaying the articles in the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Scraper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _scrapedData.isEmpty
            ? const Center(
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
                            // imgData: _scrapedData[index]['imageData'],
                            title: _scrapedData[index]['title'] ?? 'No Title',
                            imgUrl: _scrapedData[index]['imageData']!
                                as Uint8List, // Pass an empty string for the image URL
                            date: _scrapedData[index]['date'] ?? 'Unknown Date',
                            descurl: _scrapedData[index]['description'] ??
                                'No description available',
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Handle image data
                            _scrapedData[index]['imageData'] != null &&
                                    _scrapedData[index]['imageData']
                                        is Uint8List
                                ? Image.memory(
                                    _scrapedData[index]['imageData']
                                        as Uint8List,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white,
                                    ),
                                  ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _scrapedData[index]['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Date: ${_scrapedData[index]['date']}',
                                    style: const TextStyle(
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
