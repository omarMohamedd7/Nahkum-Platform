import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/judge_repo.dart';
import 'package:nahkum/features/judge/data/models/book_model.dart';

class BooksController extends GetxController {
  final JudgeRepo _repo = JudgeRepo();

  final RxBool isLoading = false.obs;
  final RxList<BookModel> allBooks = <BookModel>[].obs;
  final RxList<BookModel> filteredBooks = <BookModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  void updateSearch(String value) {
    if (value.isEmpty) {
      filteredBooks.value = allBooks;
    } else {
      filteredBooks.value = allBooks
          .where((book) =>
              book.title.contains(value) ||
              book.category.contains(value) ||
              book.author.contains(value))
          .toList();
    }
  }

  Future<void> fetchBooks() async {
    isLoading(true);
    final result = await _repo.getBooks();
    if (result is DataSuccess) {
      allBooks.value = result.data?.data ?? [];
      filteredBooks.value = result.data?.data ?? [];
    }
    isLoading(false);
  }
}
