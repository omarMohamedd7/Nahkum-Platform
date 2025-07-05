import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/repo/client_repo.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/injector.dart';
import '../../../home/data/models/lawyer_model.dart';
import 'package:nahkum/features/client/case_management/data/models/case_offer.dart';

class CaseOfferDetailController extends GetxController {
  final isLoading = false.obs;
  final offer = Rx<CaseOffer?>(null);
  final lawyer = Rx<Lawyer?>(null);
  final ClientRepo _clientRepo = injector();

  @override
  void onInit() {
    super.onInit();
    _loadOfferDetails();
  }

  void _loadOfferDetails() {
    try {
      isLoading.value = true;

      final Map<String, dynamic> arguments = Get.arguments ?? {};

      if (arguments.containsKey('offer')) {
        offer.value = arguments['offer'] as CaseOffer;
      }

      if (arguments.containsKey('lawyer')) {
        lawyer.value = arguments['lawyer'] as Lawyer;
      } else if (offer.value != null) {
        _fetchLawyerDetails(offer.value!.lawyerId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchLawyerDetails(String lawyerId) async {
    lawyer.value = Lawyer(
      id: lawyerId,
      description: 'محامي جنائي',
      price: 1000,
      name: 'أسم المحامي',
      specialization: 'محامي جنائي',
      city: 'الرياض',
      imageUrl: 'assets/images/lawyer_profile.png',
    );
  }

  Future<void> acceptOffer() async {
    if (offer.value == null) return;

    isLoading.value = true;

    try {
      final response = await _clientRepo.acceptCaseOffer(offer.value!.id);

      if (response is DataSuccess) {
        Get.snackbar(
          'تم',
          'تم قبول العرض بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(
          Routes.CASES,
          arguments: {'tabIndex': 0}, // Active cases tab
        );
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء قبول العرض',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء قبول العرض: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectOffer() async {
    if (offer.value == null) return;

    isLoading.value = true;

    try {
      final response = await _clientRepo.rejectCaseOffer(offer.value!.id);

      if (response is DataSuccess) {
        Get.snackbar(
          'تم',
          'تم رفض العرض بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(
          Routes.CASES,
          arguments: {'tabIndex': 1}, // Closed cases tab
        );
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء رفض العرض',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء رفض العرض: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
