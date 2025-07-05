import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/repo/client_repo.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/features/client/case_management/data/models/case_offer.dart';

class CaseOfferController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final isLoading = false.obs;
  final searchController = TextEditingController();
  final isSearching = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  late TabController tabController;
  final selectedTabIndex = 0.obs;

  final allOffers = <CaseOffer>[].obs;
  final ClientRepo _clientRepo = injector();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });

    _loadOffers();

    searchController.addListener(() {
      isSearching.value = searchController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    tabController.dispose();
    super.onClose();
  }

  Future<void> _loadOffers() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _clientRepo.getCaseOffers();

      if (response is DataSuccess) {
        final responseData = response.data;
        if (responseData != null && responseData is List) {
          final offers = responseData
              .map((offerJson) =>
                  _convertToCaseOffer(offerJson as Map<String, dynamic>))
              .toList();
          allOffers.assignAll(offers);
        } else if (responseData != null && responseData['data'] is List) {
          final offersData = responseData['data'] as List;
          final offers = offersData
              .map((offerJson) =>
                  _convertToCaseOffer(offerJson as Map<String, dynamic>))
              .toList();
          allOffers.assignAll(offers);
        } else {
          hasError.value = true;
          errorMessage.value = 'Invalid data format received';
        }
      } else if (response is DataFailed) {
        hasError.value = true;
        errorMessage.value =
            response.error?.data?.toString() ?? 'Failed to load offers';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value =
          'An error occurred while loading offers: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOffers() async {
    await _loadOffers();
  }

  List<CaseOffer> getFilteredOffers() {
    if (isSearching.value) {
      final searchQuery = searchController.text.toLowerCase();
      return allOffers
          .where((offer) =>
              offer.id.toLowerCase().contains(searchQuery) ||
              offer.caseType.toLowerCase().contains(searchQuery))
          .toList();
    }

    switch (selectedTabIndex.value) {
      case 0:
        return allOffers
            .where((offer) => offer.status.toLowerCase() == 'pending')
            .toList();
      case 1:
        return allOffers
            .where((offer) => offer.status.toLowerCase() == 'approved')
            .toList();
      case 2:
        return allOffers
            .where((offer) => offer.status.toLowerCase() == 'closed')
            .toList();
      case 3:
        return allOffers;
      default:
        return allOffers;
    }
  }

  void onSearchChanged(String query) {}

  void navigateToOfferDetails(CaseOffer offer) {
    Get.toNamed(
      Routes.CASE_OFFER_DETAIL,
      arguments: {
        'offer': offer,
      },
    );
  }

  Future<void> acceptOffer(String offerId) async {
    try {
      final response = await _clientRepo.acceptCaseOffer(offerId);
      if (response is DataSuccess) {
        await refreshOffers();
        Get.snackbar(
          'Success',
          'Offer accepted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response is DataFailed) {
        Get.snackbar(
          'Error',
          response.error?.data?.toString() ?? 'Failed to accept offer',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while accepting the offer',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> rejectOffer(String offerId) async {
    try {
      final response = await _clientRepo.rejectCaseOffer(offerId);
      if (response is DataSuccess) {
        await refreshOffers();
        Get.snackbar(
          'Success',
          'Offer rejected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response is DataFailed) {
        Get.snackbar(
          'Error',
          response.error?.data?.toString() ?? 'Failed to reject offer',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while rejecting the offer',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper method to convert API response to CaseOffer model
  CaseOffer _convertToCaseOffer(Map<String, dynamic> json) {
    // Extract nested objects
    final lawyerData = json['lawyer'] as Map<String, dynamic>? ?? {};
    final publishedCaseData =
        json['published_case'] as Map<String, dynamic>? ?? {};
    final caseData = publishedCaseData['case'] as Map<String, dynamic>? ?? {};

    return CaseOffer(
      id: json['offer_id']?.toString() ?? json['id']?.toString() ?? '',
      caseType: caseData['case_type']?.toString() ??
          json['case_type']?.toString() ??
          'غير محدد',
      lawyerId: lawyerData['lawyer_id']?.toString() ??
          json['lawyer_id']?.toString() ??
          '',
      lawyerName: lawyerData['name']?.toString() ??
          json['lawyer_name']?.toString() ??
          'غير محدد',
      message:
          json['message']?.toString() ?? json['description']?.toString() ?? '',
      expectedPrice: json['expected_price']?.toString() ??
          json['price']?.toString() ??
          '0',
      status: json['status']?.toString() ?? 'Pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      lawyerSpecialization: lawyerData['specialization']?.toString(),
      publishedCaseId: publishedCaseData['published_case_id']?.toString(),
    );
  }
}
