import 'package:nahkum/features/judge/data/models/book_model.dart';

class BooksModel {
  final List<BookModel> data;

  BooksModel({
    required this.data,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) {
    return BooksModel(
      data: List<BookModel>.from(
        json['data'].map((x) => BookModel.fromJson(x)),
      ),
    );
  }
}
