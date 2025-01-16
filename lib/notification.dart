import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

var count = 0;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notification'),
        ),
        body: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Card(
                  elevation: 9,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.grey[200], // Dark mode card background
                  // Light mode card background
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          count++;
                                        });
                                      },
                                      child: Text(
                                        'Count +',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    badges.Badge(
                                      badgeStyle: badges.BadgeStyle(
                                          badgeColor: Colors.redAccent),
                                      badgeContent: Text(
                                        '$count',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      child: Icon(
                                        Icons.notifications_active,
                                        size: 30,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              );
            }));
  }
}
