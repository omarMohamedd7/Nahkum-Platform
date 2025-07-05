import 'package:get/get.dart';
import '../controllers/blog_details_controller.dart';

class BlogDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogDetailsController>(() => BlogDetailsController());
  }
}
