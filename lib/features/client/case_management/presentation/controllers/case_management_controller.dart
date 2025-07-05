import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/client_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/injector.dart';
import '../../../../../core/models/case.dart';
import '../../../case_management/data/models/case_offer.dart';

class CaseManagementController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final ClientRepo _clientRepo = injector();

  final searchController = TextEditingController();

  final RxList<Case> waitingApprovalCases = <Case>[].obs;
  final RxList<Case> approvedCases = <Case>[].obs;
  final RxList<Case> closedCases = <Case>[].obs;
  final RxList<CaseOffer> caseOffers = <CaseOffer>[].obs;
  final RxList<Case> publishedCases = <Case>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(_handleTabSelection);

    // Check if we have a tab index in arguments
    final Map<String, dynamic> args = Get.arguments ?? {};
    if (args.containsKey('tabIndex')) {
      final int tabIndex = args['tabIndex'] as int;
      tabController.animateTo(tabIndex);
      currentTabIndex.value = tabIndex;
    }

    print('CaseManagementController: onInit called, initializing controller');

    // Force load published cases immediately
    print('CaseManagementController: PRIORITY - Loading published cases');
    isLoading.value = true;

    fetchPublishedCases().then((_) {
      print('CaseManagementController: Published cases loaded successfully');
      print(
          'CaseManagementController: Published cases count: ${publishedCases.length}');

      // Then load other data
      fetchCases();
      fetchCaseOffers();

      isLoading.value = false;
    }).catchError((error) {
      print('CaseManagementController: Error loading published cases: $error');
      // Continue with other data loading even if published cases fail
      fetchCases();
      fetchCaseOffers();

      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _handleTabSelection() {
    if (!tabController.indexIsChanging) {
      currentTabIndex.value = tabController.index;
      print(
          'CaseManagementController: Tab changed to ${currentTabIndex.value}');

      // Refresh data when tab changes
      if (currentTabIndex.value == 0 && waitingApprovalCases.isEmpty) {
        print(
            'CaseManagementController: Tab 0 selected and no data, refreshing...');
        fetchPendingCaseRequests();
      } else if (currentTabIndex.value == 1 && approvedCases.isEmpty) {
        print(
            'CaseManagementController: Tab 1 selected and no data, refreshing...');
        fetchActiveCases();
      } else if (currentTabIndex.value == 2 && closedCases.isEmpty) {
        print(
            'CaseManagementController: Tab 2 selected and no data, refreshing...');
        fetchClosedCases();
      } else if (currentTabIndex.value == 3 && caseOffers.isEmpty) {
        print(
            'CaseManagementController: Tab 3 selected and no data, refreshing...');
        _loadCaseOffers();
      } else if (currentTabIndex.value == 4 && publishedCases.isEmpty) {
        print(
            'CaseManagementController: Tab 4 selected and no data, refreshing...');
        _loadPublishedCases();
      }
    }
  }

  Future<void> fetchCases() async {
    showLoading();

    try {
      print('CaseManagementController: Starting to fetch cases...');
      // Fetch pending case requests from backend
      await fetchPendingCaseRequests();
      print(
          'CaseManagementController: After fetchPendingCaseRequests, count: ${waitingApprovalCases.length}');

      // Fetch active cases
      await fetchActiveCases();
      print(
          'CaseManagementController: After fetchActiveCases, count: ${approvedCases.length}');

      // Fetch closed cases
      await fetchClosedCases();
      print(
          'CaseManagementController: After fetchClosedCases, count: ${closedCases.length}');
    } catch (e) {
      print('Error fetching cases: $e');
      showError('حدث خطأ أثناء تحميل البيانات');
    } finally {
      hideLoading();
    }
  }

  Future<void> fetchPendingCaseRequests() async {
    try {
      print('CaseManagementController: Calling getCaseRequests API...');
      final result = await _clientRepo.getCaseRequests();
      print('CaseManagementController: API call completed');

      if (result is DataSuccess && result.data != null) {
        print('CaseManagementController: API call successful');
        print(
            'CaseManagementController: Raw API response type: ${result.data.runtimeType}');
        print('CaseManagementController: Raw API response: ${result.data}');

        // Clear existing data
        waitingApprovalCases.clear();

        // Handle different response formats
        if (result.data is Map<String, dynamic>) {
          final responseMap = result.data as Map<String, dynamic>;
          print(
              'CaseManagementController: Response is a Map with keys: ${responseMap.keys.toList()}');

          // Check for nested data structure
          if (responseMap.containsKey('data') &&
              responseMap['data'] is Map<String, dynamic>) {
            final dataMap = responseMap['data'] as Map<String, dynamic>;

            // Handle the nested 'data' array inside the 'data' object
            if (dataMap.containsKey('data') && dataMap['data'] is List) {
              final caseRequestsList = dataMap['data'] as List<dynamic>;
              print(
                  'CaseManagementController: Found nested data list with ${caseRequestsList.length} items');

              // Process each case request
              for (var caseRequest in caseRequestsList) {
                if (caseRequest is Map<String, dynamic>) {
                  try {
                    final caseItem = Case.fromJson(caseRequest);
                    print(
                        'CaseManagementController: Created Case object from nested data: id=${caseItem.id}, title=${caseItem.title}, status=${caseItem.status}');

                    // Add to the appropriate list based on status
                    if (caseItem.status.toLowerCase() == 'pending' ||
                        caseItem.status == 'بانتظار الموافقة') {
                      waitingApprovalCases.add(caseItem);
                      print(
                          'CaseManagementController: Added pending case request: ${caseItem.id} - ${caseItem.title}');
                    }
                  } catch (e) {
                    print(
                        'CaseManagementController: Error processing case request: $e');
                  }
                }
              }
            }
          } else if (responseMap.containsKey('data') &&
              responseMap['data'] is List) {
            // Direct data array
            final caseRequestsList = responseMap['data'] as List<dynamic>;
            print(
                'CaseManagementController: Found direct data list with ${caseRequestsList.length} items');

            for (var caseRequest in caseRequestsList) {
              if (caseRequest is Map<String, dynamic>) {
                try {
                  final caseItem = Case.fromJson(caseRequest);
                  if (caseItem.status.toLowerCase() == 'pending' ||
                      caseItem.status == 'بانتظار الموافقة') {
                    waitingApprovalCases.add(caseItem);
                  }
                } catch (e) {
                  print(
                      'CaseManagementController: Error processing case request: $e');
                }
              }
            }
          }
        } else if (result.data is List) {
          // If the response is already a list
          final caseRequestsList = result.data as List<dynamic>;
          print(
              'CaseManagementController: Response is a List with ${caseRequestsList.length} items');

          for (var caseRequest in caseRequestsList) {
            if (caseRequest is Map<String, dynamic>) {
              try {
                final caseItem = Case.fromJson(caseRequest);
                if (caseItem.status.toLowerCase() == 'pending' ||
                    caseItem.status == 'بانتظار الموافقة') {
                  waitingApprovalCases.add(caseItem);
                }
              } catch (e) {
                print(
                    'CaseManagementController: Error processing case request: $e');
              }
            }
          }
        }

        print(
            'CaseManagementController: Final waitingApprovalCases count: ${waitingApprovalCases.length}');
        if (waitingApprovalCases.isEmpty) {
          print('CaseManagementController: No pending case requests found');
        } else {
          print(
              'CaseManagementController: First case: ${waitingApprovalCases[0].title}');
        }
      } else if (result is DataFailed) {
        print('CaseManagementController: API call failed: ${result.error}');
        throw Exception('Failed to fetch case requests: ${result.error}');
      } else {
        print('CaseManagementController: API call returned null data');
      }
    } catch (e) {
      print('CaseManagementController: Error in fetchPendingCaseRequests: $e');
      rethrow;
    }
  }

  Future<void> fetchActiveCases() async {
    try {
      print('CaseManagementController: Calling getActiveCases API...');
      final result = await _clientRepo.getActiveCases();
      print('CaseManagementController: API call completed');

      if (result is DataSuccess && result.data != null) {
        print('CaseManagementController: API call successful');
        print(
            'CaseManagementController: Raw API response type: ${result.data.runtimeType}');
        print('CaseManagementController: Raw API response: ${result.data}');

        // Clear existing data
        approvedCases.clear();

        // Handle different response formats
        if (result.data is Map<String, dynamic>) {
          final responseMap = result.data as Map<String, dynamic>;
          print(
              'CaseManagementController: Response is a Map with keys: ${responseMap.keys.toList()}');

          // Check for nested data structure
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            final activeCasesList = responseMap['data'] as List<dynamic>;
            print(
                'CaseManagementController: Found data list with ${activeCasesList.length} items');

            // Process each active case
            for (var caseData in activeCasesList) {
              if (caseData is Map<String, dynamic>) {
                try {
                  final caseItem = Case.fromJson(caseData);
                  print(
                      'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww ${caseItem.toJson()}');

                  // Translate status to Arabic
                  if (caseItem.status.toLowerCase() == 'active' ||
                      caseItem.status.toLowerCase() == 'approved') {
                    caseItem.status = 'موافق عليه';
                  }

                  approvedCases.add(caseItem);
                  print(
                      'CaseManagementController: Added active case: ${caseItem.id} - ${caseItem.title}');
                } catch (e) {
                  print(
                      'CaseManagementController: Error processing active case: $e');
                }
              }
            }
          } else if (responseMap.containsKey('cases') &&
              responseMap['cases'] is List) {
            // Alternative structure with 'cases' field
            final activeCasesList = responseMap['cases'] as List<dynamic>;
            print(
                'CaseManagementController: Found cases list with ${activeCasesList.length} items');

            for (var caseData in activeCasesList) {
              if (caseData is Map<String, dynamic>) {
                try {
                  final caseItem = Case.fromJson(caseData);
                  if (caseItem.status.toLowerCase() == 'active' ||
                      caseItem.status.toLowerCase() == 'approved') {
                    caseItem.status = 'موافق عليه';
                  }
                  approvedCases.add(caseItem);
                } catch (e) {
                  print(
                      'CaseManagementController: Error processing active case: $e');
                }
              }
            }
          }
        } else if (result.data is List) {
          // If the response is already a list
          final activeCasesList = result.data as List<dynamic>;
          print(
              'CaseManagementController: Response is a List with ${activeCasesList.length} items');

          for (var caseData in activeCasesList) {
            if (caseData is Map<String, dynamic>) {
              try {
                final caseItem = Case.fromJson(caseData);
                // Translate status to Arabic
                if (caseItem.status.toLowerCase() == 'active' ||
                    caseItem.status.toLowerCase() == 'approved') {
                  caseItem.status = 'موافق عليه';
                }
                print(caseData.toString() + " lawwwwwww");
                approvedCases.add(caseItem);
              } catch (e) {
                print(
                    'CaseManagementController: Error processing active case: $e');
              }
            }
          }
        }

        print(
            'CaseManagementController: Final approvedCases count: ${approvedCases.length}');
        if (approvedCases.isEmpty) {
          print('CaseManagementController: No active cases found');
        } else {
          print(
              'CaseManagementController: First case: ${approvedCases[0].title}');
        }
      } else if (result is DataFailed) {
        print('CaseManagementController: API call failed: ${result.error}');
        throw Exception('Failed to fetch active cases: ${result.error}');
      } else {
        print('CaseManagementController: API call returned null data');
      }
    } catch (e) {
      print('CaseManagementController: Error in fetchActiveCases: $e');
      rethrow;
    }
  }

  Future<void> fetchClosedCases() async {
    try {
      print('CaseManagementController: Calling getClosedCases API...');
      final result = await _clientRepo.getClosedCases();
      print('CaseManagementController: API call completed');

      if (result is DataSuccess && result.data != null) {
        print('CaseManagementController: API call successful');
        print(
            'CaseManagementController: Raw API response type: ${result.data.runtimeType}');
        print('CaseManagementController: Raw API response: ${result.data}');

        // Clear existing data
        closedCases.clear();

        // Handle different response formats
        if (result.data is Map<String, dynamic>) {
          final responseMap = result.data as Map<String, dynamic>;
          print(
              'CaseManagementController: Response is a Map with keys: ${responseMap.keys.toList()}');

          // Check for nested data structure
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            final closedCasesList = responseMap['data'] as List<dynamic>;
            print(
                'CaseManagementController: Found data list with ${closedCasesList.length} items');

            // Process each closed case
            for (var caseData in closedCasesList) {
              if (caseData is Map<String, dynamic>) {
                try {
                  final caseItem = Case.fromJson(caseData);
                  print(
                      'CaseManagementController: Created Case object: id=${caseItem.id}, title=${caseItem.title}, status=${caseItem.status}');

                  // Translate status to Arabic
                  if (caseItem.status.toLowerCase() == 'closed') {
                    caseItem.status = 'مغلق';
                  }

                  closedCases.add(caseItem);
                  print(
                      'CaseManagementController: Added closed case: ${caseItem.id} - ${caseItem.title}');
                } catch (e) {
                  print(
                      'CaseManagementController: Error processing closed case: $e');
                }
              }
            }
          } else if (responseMap.containsKey('cases') &&
              responseMap['cases'] is List) {
            // Alternative structure with 'cases' field
            final closedCasesList = responseMap['cases'] as List<dynamic>;
            print(
                'CaseManagementController: Found cases list with ${closedCasesList.length} items');

            for (var caseData in closedCasesList) {
              if (caseData is Map<String, dynamic>) {
                try {
                  final caseItem = Case.fromJson(caseData);
                  if (caseItem.status.toLowerCase() == 'closed') {
                    caseItem.status = 'مغلق';
                  }
                  closedCases.add(caseItem);
                } catch (e) {
                  print(
                      'CaseManagementController: Error processing closed case: $e');
                }
              }
            }
          }
        } else if (result.data is List) {
          // If the response is already a list
          final closedCasesList = result.data as List<dynamic>;
          print(
              'CaseManagementController: Response is a List with ${closedCasesList.length} items');

          for (var caseData in closedCasesList) {
            if (caseData is Map<String, dynamic>) {
              try {
                final caseItem = Case.fromJson(caseData);
                // Translate status to Arabic
                if (caseItem.status.toLowerCase() == 'closed') {
                  caseItem.status = 'مغلق';
                }
                closedCases.add(caseItem);
              } catch (e) {
                print(
                    'CaseManagementController: Error processing closed case: $e');
              }
            }
          }
        }

        print(
            'CaseManagementController: Final closedCases count: ${closedCases.length}');
        if (closedCases.isEmpty) {
          print('CaseManagementController: No closed cases found');
        } else {
          print(
              'CaseManagementController: First case: ${closedCases[0].title}');
        }
      } else if (result is DataFailed) {
        print('CaseManagementController: API call failed: ${result.error}');
        throw Exception('Failed to fetch closed cases: ${result.error}');
      } else {
        print('CaseManagementController: API call returned null data');
      }
    } catch (e) {
      print('CaseManagementController: Error in fetchClosedCases: $e');
      rethrow;
    }
  }

  Future<void> fetchCaseOffers() async {
    isLoading.value = true;

    try {
      print('CaseManagementController: Calling getCaseOffers API...');
      final result = await _clientRepo.getCaseOffers();
      print('CaseManagementController: API call completed');

      if (result is DataSuccess && result.data != null) {
        print('CaseManagementController: API call successful');
        print(
            'CaseManagementController: Raw API response type: ${result.data.runtimeType}');
        print('CaseManagementController: Raw API response: ${result.data}');

        // Clear existing data
        caseOffers.clear();

        // Handle different response formats
        if (result.data is List) {
          // If the response is already a list
          final offersList = result.data as List<dynamic>;
          print(
              'CaseManagementController: Response is a List with ${offersList.length} items');

          for (var offerData in offersList) {
            if (offerData is Map<String, dynamic>) {
              try {
                final offer = CaseOffer.fromJson(offerData);
                caseOffers.add(offer);
                print(
                    'CaseManagementController: Added case offer: ${offer.id} - ${offer.caseType}');
              } catch (e) {
                print(
                    'CaseManagementController: Error processing case offer: $e');
              }
            }
          }
        } else if (result.data is Map<String, dynamic>) {
          final responseMap = result.data as Map<String, dynamic>;
          print(
              'CaseManagementController: Response is a Map with keys: ${responseMap.keys.toList()}');

          // Check for nested data structure
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            final offersList = responseMap['data'] as List<dynamic>;
            print(
                'CaseManagementController: Found data list with ${offersList.length} items');

            // Process each case offer
            for (var offerData in offersList) {
              if (offerData is Map<String, dynamic>) {
                try {
                  final offer = CaseOffer.fromJson(offerData);
                  caseOffers.add(offer);
                  print(
                      'CaseManagementController: Added case offer: ${offer.id} - ${offer.caseType}');
                } catch (e) {
                  print(
                      'CaseManagementController: Error processing case offer: $e');
                }
              }
            }
          }
        }

        print(
            'CaseManagementController: Final caseOffers count: ${caseOffers.length}');
        if (caseOffers.isEmpty) {
          print('CaseManagementController: No case offers found');
        } else {
          print(
              'CaseManagementController: First offer: ${caseOffers[0].caseType}');
        }
      } else if (result is DataFailed) {
        print('CaseManagementController: API call failed: ${result.error}');
        throw Exception('Failed to fetch case offers: ${result.error}');
      } else {
        print('CaseManagementController: API call returned null data');
      }
    } catch (e) {
      print('CaseManagementController: Error in fetchCaseOffers: $e');
      // Keep the default mock data if API call fails
      if (caseOffers.isEmpty) {
        print('CaseManagementController: Using mock case offers data');
        caseOffers.value = [
          CaseOffer(
            id: '1',
            caseType: 'قضية جنائية',
            lawyerId: 'lawyer1',
            lawyerName: 'أسم المحامي',
            message: 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة.',
            expectedPrice: '500',
            status: 'pending',
            createdAt: DateTime.now(),
          ),
        ];
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPublishedCases() async {
    try {
      print('CaseManagementController: Starting fetchPublishedCases');

      // Clear the list first to prevent any duplicates from previous calls
      publishedCases.clear();

      // Call the API
      final result = await _clientRepo.getPublishedCases();

      if (result is DataSuccess && result.data != null) {
        // Extract the data from the API response
        List<dynamic> casesDataList = [];

        if (result.data is Map<String, dynamic>) {
          final Map<String, dynamic> responseMap = result.data;

          if (responseMap.containsKey('data')) {
            if (responseMap['data'] is List) {
              casesDataList = responseMap['data'];
            } else if (responseMap['data'] is Map &&
                responseMap['data']['data'] is List) {
              casesDataList = responseMap['data']['data'];
            }
          }
        } else if (result.data is List) {
          casesDataList = result.data;
        }

        print(
            'CaseManagementController: Found ${casesDataList.length} published cases in API response');

        // Create a Set to track unique IDs
        final Set<String> uniqueIds = {};

        // Process each case
        for (final caseData in casesDataList) {
          if (caseData is! Map<String, dynamic>) continue;

          try {
            // Get the published case ID
            final String publishedCaseId =
                caseData['published_case_id']?.toString() ?? '';
            if (publishedCaseId.isEmpty) continue;

            // Skip if we've already processed this ID
            if (uniqueIds.contains(publishedCaseId)) {
              print(
                  'CaseManagementController: Skipping duplicate published case ID: $publishedCaseId');
              continue;
            }

            // Add to the set of processed IDs
            uniqueIds.add(publishedCaseId);

            // Get the nested case data if available
            final Map<String, dynamic>? nestedCase =
                caseData['case'] is Map<String, dynamic>
                    ? caseData['case']
                    : null;

            // Extract case details
            final String caseTitle = nestedCase?['case_type']?.toString() ??
                caseData['target_specialization']?.toString() ??
                'قضية منشورة';

            final String caseDescription =
                nestedCase?['description']?.toString() ??
                    caseData['description']?.toString() ??
                    '';

            final String caseType = nestedCase?['case_type']?.toString() ??
                caseData['target_specialization']?.toString() ??
                caseTitle;

            final String caseNumber =
                nestedCase?['case_number']?.toString() ?? publishedCaseId;

            // Get the published case status
            String status = caseData['status']?.toString() ?? 'منشور';

            // Translate status to Arabic
            if (status.toLowerCase() == 'active') {
              status = 'نشط';
            } else if (status.toLowerCase() == 'closed') {
              status = 'مغلق';
            } else if (status.toLowerCase() == 'pending') {
              status = 'قيد الانتظار';
            }

            // Get lawyer info from accepted offers
            String? lawyerId;
            String? lawyerName;

            if (caseData['offers'] is List) {
              for (final offer in caseData['offers']) {
                if (offer is Map<String, dynamic> &&
                    offer['status']?.toString().toLowerCase() == 'accepted' &&
                    offer['lawyer'] is Map) {
                  final lawyer = offer['lawyer'];
                  lawyerId = lawyer['lawyer_id']?.toString();
                  lawyerName = lawyer['name']?.toString();
                  break;
                }
              }
            }

            // Create the case object
            final Case caseItem = Case(
              id: publishedCaseId,
              title: caseTitle,
              description: caseDescription,
              caseNumber: caseNumber,
              caseType: caseType,
              status: status,
              lawyerId: lawyerId,
              lawyerName: lawyerName,
              attachments: [],
            );

            // Add to the list
            publishedCases.add(caseItem);

            print(
                'CaseManagementController: Added published case: ID=${caseItem.id}, title=${caseItem.title}, status=${caseItem.status}');
          } catch (e) {
            print(
                'CaseManagementController: Error processing published case: $e');
          }
        }

        print(
            'CaseManagementController: Final published cases count: ${publishedCases.length}');
        print(
            'CaseManagementController: Unique IDs processed: ${uniqueIds.length}');
      } else {
        print('CaseManagementController: Failed to fetch published cases');
      }
    } catch (e) {
      print('CaseManagementController: Error in fetchPublishedCases: $e');
    }
  }

  List<dynamic> getFilteredItems() {
    print(
        'CaseManagementController: getFilteredItems called for tab ${currentTabIndex.value}');
    print(
        'CaseManagementController: waitingApprovalCases count: ${waitingApprovalCases.length}');
    print(
        'CaseManagementController: approvedCases count: ${approvedCases.length}');
    print('CaseManagementController: closedCases count: ${closedCases.length}');
    print('CaseManagementController: caseOffers count: ${caseOffers.length}');
    print(
        'CaseManagementController: publishedCases count: ${publishedCases.length}');

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      if (currentTabIndex.value == 3) {
        // Filter case offers by lawyer name
        return caseOffers
            .where((offer) =>
                (offer.lawyerName?.toLowerCase() ?? '').contains(query))
            .toList();
      } else {
        // Filter cases by lawyer name or case type
        final allCases = [
          ...waitingApprovalCases,
          ...approvedCases,
          ...closedCases,
          ...publishedCases,
        ];

        var list = allCases
            .where((caseItem) =>
                (caseItem.lawyerName?.toLowerCase() ?? '').contains(query) ||
                caseItem.caseType.toLowerCase().contains(query))
            .toList();
        return list;
      }
    }

    // Force refresh the list to trigger UI update
    switch (currentTabIndex.value) {
      case 0:
        if (waitingApprovalCases.isEmpty) {
          print(
              'CaseManagementController: Tab 0 is empty, may need to fetch data');
        } else {
          print(
              'CaseManagementController: Returning ${waitingApprovalCases.length} items for tab 0');
        }
        return List<Case>.from(waitingApprovalCases);
      case 1:
        print(
            approvedCases.map((e) => e.toJson()).toString() + "wqwdasdasdasd");
        return List<Case>.from(approvedCases);
      case 2:
        return List<Case>.from(closedCases);
      case 3:
        return List<CaseOffer>.from(caseOffers);
      case 4:
        // Deduplicate published cases by ID before returning
        final Map<String, Case> uniqueCases = {};
        for (var caseItem in publishedCases) {
          uniqueCases[caseItem.id] = caseItem;
        }
        final List<Case> deduplicatedCases = uniqueCases.values.toList();
        print(
            'CaseManagementController: Deduplicated published cases: ${publishedCases.length} -> ${deduplicatedCases.length}');
        return deduplicatedCases;
      default:
        return List<Case>.from(waitingApprovalCases);
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
  }

  void onClearSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearching.value = false;
  }

  Future<void> refreshActiveTab() async {
    showLoading();
    try {
      switch (currentTabIndex.value) {
        case 0:
          await fetchPendingCaseRequests();
          break;
        case 1:
          await fetchActiveCases();
          break;
        case 2:
          await fetchClosedCases();
          break;
        case 3:
          await fetchCaseOffers();
          break;
        case 4:
          await fetchPublishedCases();
          break;
        default:
          break;
      }
    } catch (e) {
      print('Error refreshing active tab: $e');
      showError('حدث خطأ أثناء تحديث البيانات');
    } finally {
      hideLoading();
    }
  }

  void navigateToPublishCase() {
    Get.toNamed(Routes.PUBLISH_CASE);
  }

  void navigateToCaseDetails(Case caseItem) {
    Get.toNamed(Routes.CASE_DETAILS, arguments: caseItem);
  }

  void navigateToOfferDetails(CaseOffer offer) {
    Get.toNamed(
      Routes.CASE_OFFER_DETAIL,
      arguments: {
        'offer': offer,
      },
    );
  }

  void acceptOffer(CaseOffer offer) async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));

      caseOffers.removeWhere((item) => item.id == offer.id);

      approvedCases.add(
        Case(
          id: offer.id,
          title: offer.caseType,
          description: offer.message,
          caseNumber: offer.id,
          caseType: offer.caseType,
          status: 'موافق عليه',
          lawyerId: offer.lawyerId,
          attachments: [],
        ),
      );

      Get.toNamed(Routes.CHAT_DETAIL, arguments: {
        // 'contactModel': contactModel,
      });
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء قبول العرض',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  void showError(String message) {
    Get.snackbar(
      'خطأ',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  void showSuccess(String message) {
    Get.snackbar(
      'تم',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Helper method to load case offers asynchronously
  void _loadCaseOffers() {
    fetchCaseOffers().catchError((error) {
      print('Error loading case offers: $error');
    });
  }

  // Helper method to load published cases asynchronously
  void _loadPublishedCases() {
    fetchPublishedCases().catchError((error) {
      print('Error loading published cases: $error');
    });
  }
}
