// class Article {
//   final int? id; // Primary key
//   final String title;
//   final String imageUrl;
//   final String link;
//   final String date;

//   Article({
//     this.id,
//     required this.title,
//     required this.imageUrl,
//     required this.link,
//     required this.date,
//   });

//   // Convert an Article object to a Map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'imageUrl': imageUrl,
//       'link': link,
//       'date': date,
//     };
//   }

//   // Create an Article object from a Map
//   factory Article.fromMap(Map<String, dynamic> map) {
//     return Article(
//       id: map['id'],
//       title: map['title'],
//       imageUrl: map['imageUrl'],
//       link: map['link'],
//       date: map['date'],
//     );
//   }
// }
