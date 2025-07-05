import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/judge_repo.dart';
import 'package:nahkum/features/judge/data/models/prediction_model.dart';

class VideoAnalysisController extends GetxController {
  final JudgeRepo _repo = JudgeRepo();

  final RxBool isLoading = false.obs;
  final Rx<PredictionModel?> prediction = Rx<PredictionModel?>(null);
  final Rx<File?> file = Rx<File?>(null);

  Future<void> pickAndAnalyzeVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null && result.files.single.path != null) {
      file.value = File(result.files.single.path!);
      isLoading(true);

      final response = await _repo.predictVideo(file: file.value!);
      if (response is DataSuccess) {
        prediction.value = response.data;
      } else {
        Get.snackbar('خطأ', response.error.toString());
        cancelVideoPrediction();
      }

      isLoading(false);
    } else {
      Get.snackbar('إلغاء', 'لم يتم اختيار أي فيديو');
    }
    cancelUploadedVideo();
  }

  void cancelUploadedVideo() {
    file.value = null;
  }

  void cancelVideoPrediction() {
    file.value = null;
    file.value = null;
    isLoading(false);
  }

  final RxBool isLoadingPredictions = false.obs;
  final RxList<PredictionModel> predictions = <PredictionModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getPredictionsHistory();
  }

  Future<void> getPredictionsHistory() async {
    isLoadingPredictions(true);
    final result = await _repo.getPredictionsHistory();
    if (result is DataSuccess) {
      predictions.value = result.data?.data ?? [];
    }
    isLoadingPredictions(false);
  }
}
