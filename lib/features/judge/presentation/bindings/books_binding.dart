import 'package:get/get.dart';
import 'package:nahkum/features/judge/presentation/controllers/books_controller.dart';

class BooksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BooksController>(() => BooksController());
  }
}
