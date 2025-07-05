import 'package:get/get.dart';
import 'package:nahkum/core/data/data_consts.dart';
import 'package:nahkum/features/judge/data/models/book_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogDetailsController extends GetxController {
  late final BookModel book;

  @override
  void onInit() {
    final data = Get.arguments?['book'];
    if (data != null) {
      book = BookModel.fromJson(data);
    } else {
      // fallback or throw
      throw Exception("No book data passed");
    }
    super.onInit();
  }

  void downloadReference() async {
    final url = DataConsts.imageBaseURL + book.filePath.toString();

    await launch(url);
  }
}
