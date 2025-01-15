import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   extendBody: true,
    //   backgroundColor: Colors.grey,
    // );
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Portfolio'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: [
                Tab(text: "Allocation"),
                Tab(text: "Watchlist"),
                Tab(text: "Add Shares"),
                Tab(text: "Import"),
                Tab(
                  text: "Ipo Check",
                ),
                Tab(text: "Chart"),
                Tab(
                  text: "Ipo Check",
                ),
                Tab(text: "Chart"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  UrlLink(),
                  Container(),
                  AddSharesTab(),
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddSharesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(text: "Buy"),
              Tab(text: "Sell"),
              Tab(text: "Cash Dividend"),
              Tab(text: "Bonus Dividend"),
              Tab(text: "IPO"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}

class UrlLink extends StatefulWidget {
  const UrlLink({super.key});

  @override
  State<UrlLink> createState() => _UrlLinkState();
}

class _UrlLinkState extends State<UrlLink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              const url = 'https://www.google.com';
              if (await canLaunch(url)) {
                await launch(url, forceWebView: true, enableJavaScript: true);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Center(
              child: Text(
                "Google",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              width: 150,
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        await LaunchApp.openApp(
                            androidPackageName: 'com.example.nepal_app',
                            openStore: false);
                      },
                      child: const Center(
                        child: Text(
                          "Open App",
                          textAlign: TextAlign.center,
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
