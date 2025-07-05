import 'package:get/get.dart';
import 'package:nahkum/features/judge/presentation/controllers/video_analysis_controller.dart';

class VideoAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoAnalysisController>(() => VideoAnalysisController());
  }
}
