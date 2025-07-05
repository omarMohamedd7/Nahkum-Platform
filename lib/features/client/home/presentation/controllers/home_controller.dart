import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/models/lawyer.dart';
import 'package:nahkum/core/repo/client_repo.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/features/auth/data/models/user/user_model.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final ClientRepo _clientRepo = injector();
  var isLoading = false.obs;
  var isAllLawyersLoading = false.obs;
  var lawyers = <Lawyer>[].obs;
  var allLawyers = <Lawyer>[].obs;

  // User data
  final RxString userName = 'أسم المستخدم'.obs;
  final Rx<String?> userImageUrl = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCityLawyers();
    _initUserData();
  }

  void _initUserData() {
    try {
      final cachedUserJson = cache.read(CacheHelper.user);
      if (cachedUserJson != null) {
        final UserModel cachedUser = UserModel.fromJson(cachedUserJson);
        userName.value = cachedUser.name;
        userImageUrl.value = cachedUser.profileImageUrl;
      }
    } catch (e) {
      // Silently handle error
    }
  }

  void refreshUserData() {
    _initUserData();
  }

  Future<void> fetchCityLawyers() async {
    isLoading.value = true;

    try {
      final result = await _clientRepo.getCityLawyers();

      if (result is DataSuccess && result.data != null) {
        if (result.data['lawyers'] != null && result.data['lawyers'] is List) {
          final lawyersData = result.data['lawyers'] as List<dynamic>;
          final mappedLawyers = lawyersData.map((lawyer) {
            var rawId = lawyer['lawyer_id'] ?? lawyer['id'];
            String id = '0';
            if (rawId != null) {
              id = rawId.toString();
            }

            return Lawyer(
              id: id,
              name: lawyer['name'] ?? 'غير معروف',
              location: lawyer['city'] ?? 'غير محدد',
              description: lawyer['bio'] ?? 'لا يوجد وصف',
              consultationFee:
                  double.tryParse(lawyer['consult_fee']?.toString() ?? '0') ??
                      0.0,
              imageUrl: lawyer['profile_image'] ??
                  'assets/images/user-profile-image.svg',
              specialization: lawyer['specialization'] ?? 'غير محدد',
            );
          }).toList();

          lawyers.assignAll(mappedLawyers);
        } else if (result.data['data'] != null && result.data['data'] is List) {
          final lawyersData = result.data['data'] as List<dynamic>;
          final mappedLawyers = lawyersData.map((lawyer) {
            var rawId = lawyer['lawyer_id'] ?? lawyer['id'];
            String id = '0';
            if (rawId != null) {
              id = rawId.toString();
            }

            return Lawyer(
              id: id,
              name: lawyer['name'] ?? 'غير معروف',
              location: lawyer['city'] ?? 'غير محدد',
              description: lawyer['bio'] ?? 'لا يوجد وصف',
              consultationFee:
                  double.tryParse(lawyer['consult_fee']?.toString() ?? '0') ??
                      0.0,
              imageUrl: lawyer['profile_image'] ??
                  'assets/images/user-profile-image.svg',
              specialization: lawyer['specialization'] ?? 'غير محدد',
            );
          }).toList();

          lawyers.assignAll(mappedLawyers);
        }
      }
    } catch (e) {
      // Silently handle error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllLawyers() async {
    isAllLawyersLoading.value = true;

    try {
      final result = await _clientRepo.getAllLawyers();

      if (result is DataSuccess && result.data != null) {
        if (result.data['lawyers'] != null && result.data['lawyers'] is List) {
          final lawyersData = result.data['lawyers'] as List<dynamic>;
          final mappedLawyers = lawyersData.map((lawyer) {
            var rawId = lawyer['lawyer_id'] ?? lawyer['id'];
            String id = '0';
            if (rawId != null) {
              id = rawId.toString();
            }

            return Lawyer(
              id: id,
              name: lawyer['name'] ?? 'غير معروف',
              location: lawyer['city'] ?? 'غير محدد',
              description: lawyer['bio'] ?? 'لا يوجد وصف',
              consultationFee:
                  double.tryParse(lawyer['consult_fee']?.toString() ?? '0') ??
                      0.0,
              imageUrl: lawyer['profile_image'] ??
                  'assets/images/user-profile-image.svg',
              specialization: lawyer['specialization'] ?? 'غير محدد',
            );
          }).toList();

          allLawyers.assignAll(mappedLawyers);
        } else if (result.data['data'] != null && result.data['data'] is List) {
          final lawyersData = result.data['data'] as List<dynamic>;
          final mappedLawyers = lawyersData.map((lawyer) {
            var rawId = lawyer['lawyer_id'] ?? lawyer['id'];
            String id = '0';
            if (rawId != null) {
              id = rawId.toString();
            }

            return Lawyer(
              id: id,
              name: lawyer['name'] ?? 'غير معروف',
              location: lawyer['city'] ?? 'غير محدد',
              description: lawyer['bio'] ?? 'لا يوجد وصف',
              consultationFee:
                  double.tryParse(lawyer['consult_fee']?.toString() ?? '0') ??
                      0.0,
              imageUrl: lawyer['profile_image'] ??
                  'assets/images/user-profile-image.svg',
              specialization: lawyer['specialization'] ?? 'غير محدد',
            );
          }).toList();

          allLawyers.assignAll(mappedLawyers);
        }
      }
    } catch (e) {
      // Silently handle error
    } finally {
      isAllLawyersLoading.value = false;
    }
  }

  void navigateToPublishCase() {
    Get.toNamed('/publish_case');
  }

  void navigateToLawyersListing() {
    Get.toNamed('/lawyers_listing');
  }

  void navigateToConsultationRequest(Lawyer lawyer) {
    Get.toNamed('/consultation_request', arguments: lawyer);
  }

  void showErrorMessage(String message) {
    final bool isDuplicateError = message.contains('أرسلت بالفعل طلبًا') ||
        message.contains('already sent a request');

    Get.snackbar(
      isDuplicateError ? 'تنبيه' : 'خطأ',
      isDuplicateError ? 'لقد أرسلت بالفعل طلبًا إلى هذا المحامي' : message,
      backgroundColor: isDuplicateError ? Colors.orange : Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: Icon(
        isDuplicateError ? Icons.warning_amber_rounded : Icons.error_outline,
        color: Colors.white,
      ),
    );
  }

  Future<bool> hasExistingRequestForLawyer(int lawyerId) async {
    try {
      final result = await _clientRepo.getCaseRequests();
      if (result is DataSuccess && result.data != null) {
        final requests = result.data as List<dynamic>;
        return requests.any((request) {
          if (request is Map<String, dynamic>) {
            if (request['lawyer_id'] != null &&
                int.parse(request['lawyer_id'].toString()) == lawyerId) {
              return true;
            }

            if (request['lawyer'] != null &&
                request['lawyer'] is Map<String, dynamic>) {
              final lawyerData = request['lawyer'] as Map<String, dynamic>;
              if (lawyerData['id'] != null &&
                  int.parse(lawyerData['id'].toString()) == lawyerId) {
                return true;
              }
            }
          }
          return false;
        });
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void goToDirectCaseRequest(dynamic lawyer) async {
    try {
      int lawyerId;
      if (lawyer is Map<String, dynamic> && lawyer['id'] != null) {
        lawyerId = int.parse(lawyer['id'].toString());
      } else if (lawyer.id != null) {
        lawyerId = int.parse(lawyer.id.toString());
      } else {
        showErrorMessage('حدث خطأ أثناء معالجة طلبك');
        return;
      }

      final bool hasExisting = await hasExistingRequestForLawyer(lawyerId);

      if (hasExisting) {
        Get.dialog(
          Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text(
                'طلب موجود بالفعل',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              content: const Text(
                'لقد أرسلت بالفعل طلبًا إلى هذا المحامي. يرجى انتظار رده على طلبك الحالي قبل إرسال طلب جديد.',
                style: TextStyle(
                  fontFamily: 'Almarai',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'حسناً',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        Get.toNamed('/direct_case_request', arguments: lawyer);
      }
    } catch (e) {
      showErrorMessage('حدث خطأ أثناء معالجة طلبك');
    }
  }
}
