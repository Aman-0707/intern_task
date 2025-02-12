import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intern_task/datbaseService.dart';
import 'package:intern_task/description.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

class wWebScraperScreen extends StatefulWidget {
  @override
  _WebScraperScreenState createState() => _WebScraperScreenState();
}

class _WebScraperScreenState extends State<wWebScraperScreen> {
  List<Map<String, dynamic>> _scrapedData = [];

  @override
  void initState() {
    super.initState();
    scrapeWebsite();
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

          final articleData = {
            'title': title,
            'imageUrl': imageUrl,
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

          final articleData = {
            'title': title,
            'imageUrl': imageUrl,
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
      _scrapedData = articles.reversed.toList();
    });
  }

  // Displaying the articles in the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Scraper'),
        actions: [
          // Row(
          //   children: [
          //     Icon(_currentThemeMode ? Icons.dark_mode : Icons.light_mode),
          //     Switch(
          //       value: _currentThemeMode,
          //       onChanged: (value) {
          //         setState(() {
          //           _currentThemeMode = value; // Update the theme mode state
          //         });
          //         widget
          //             .onToggleTheme(); // Call the parent callback to toggle theme
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            // _isLoading
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     :
            _scrapedData.isEmpty
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
                      print(_scrapedData[index]['title']);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DesriptionScreen(
                                title:
                                    _scrapedData[index]['title'] ?? 'No Title',
                                imgUrl: _scrapedData[index]['imageUrl'] ??
                                    'default_image_url',
                                date: _scrapedData[index]['date'] ??
                                    'Unknown Date',
                                descurl: _scrapedData[index]['link'] ??
                                    'default_link',
                                // title: _scrapedData[index]['title'],
                                // imgUrl: _scrapedData[index]['imageUrl'],
                                // date: _scrapedData[index]['date'],
                                // descurl: _scrapedData[index]['a'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          color:
                              // _currentThemeMode
                              //     ? Colors.grey[800] // Dark mode card background
                              //     :
                              Colors.grey[200], // Light mode card background
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _scrapedData[index]['imageUrl'] != null &&
                                        _scrapedData[index]['imageUrl']!
                                            .isNotEmpty
                                    ? Image.network(
                                        _scrapedData[index]['imageUrl']!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.black,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _scrapedData[index]['title']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              // _currentThemeMode
                                              //     ? Colors.grey
                                              //     :
                                              Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Date: ${_scrapedData[index]['date']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              //  _currentThemeMode
                                              //     ? Colors.orangeAccent
                                              //     :
                                              Colors.orange,
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
