class BookModel {
  final int id;
  final String title;
  final String author;
  final String category;
  final String description;
  final String? imageUrl;
  final String? filePath;
  final String downloadUrl;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.downloadUrl,
    required this.filePath,
    this.imageUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      category: json['category'],
      description: json['description'],
      downloadUrl: json['download_url'],
      imageUrl: json['image_url'],
      filePath: json['file_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'download_url': downloadUrl,
      'image_url': imageUrl,
      'file_path': filePath,
    };
  }
}
