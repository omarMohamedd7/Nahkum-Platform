import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/models/lawyer.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/widgets/custom_button.dart';
import 'package:nahkum/core/widgets/custom_search_text_field.dart';
import 'package:nahkum/features/client/home/presentation/controllers/home_controller.dart';
import 'package:nahkum/features/client/home/presentation/widgets/bottom_navigation_bar.dart';
import 'package:nahkum/features/client/home/presentation/widgets/lawyer_card.dart';

class LawyersListingPage extends StatefulWidget {
  const LawyersListingPage({super.key});

  @override
  State<LawyersListingPage> createState() => _LawyersListingPageState();
}

class _LawyersListingPageState extends State<LawyersListingPage> {
  final HomeController _homeController = Get.find<HomeController>();
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialization = 'الكل';
  String _selectedCity = 'الكل';
  String _searchQuery = '';
  final List<String> _specializations = [
    'الكل',
    'قانون مدني',
    'قانون جنائي',
    'قانون تجاري',
    'قانون الأسرة'
  ];

  final List<String> _cities = [
    'الكل',
    'دمشق',
    'حمص',
    'حلب',
    'حماه',
    'اللاذقية',
  ];

  @override
  void initState() {
    super.initState();
    _homeController.fetchAllLawyers();
  }

  List<Lawyer> get filteredLawyers {
    return _homeController.allLawyers.where((lawyer) {
      final nameMatches =
          lawyer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              _searchQuery.isEmpty;

      final specializationMatches = _selectedSpecialization == 'الكل' ||
          lawyer.specialization == _selectedSpecialization;

      final cityMatches =
          _selectedCity == 'الكل' || lawyer.location == _selectedCity;

      return nameMatches && specializationMatches && cityMatches;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.screenBackground,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'المحامين المتاحين',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.arrowRight,
              color: AppColors.primary,
            ),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomSearchTextField(
                controller: _searchController,
                hintText: 'ابحث عن محامي...',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onFilterPressed: () {
                  _showFilterBottomSheet(context);
                },
              ),
            ),
          ),
          SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8, bottom: 8),
                    child: const Text(
                      'المدينة:',
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  ..._cities.map(
                    (city) => _buildFilterChip(
                      label: city,
                      isSelected: _selectedCity == city,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCity = city;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (_homeController.isAllLawyersLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final lawyers = filteredLawyers;

              if (lawyers.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد محامين بالمواصفات المطلوبة',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: lawyers.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                reverse: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: LawyerCard(
                      lawyer: lawyers[index],
                      onConsultTap: () => Get.toNamed(
                        Routes.CONSULTATION_REQUEST,
                        arguments: lawyers[index],
                      ),
                      onRepresentTap: () {
                        print(
                            'LawyersListingPage: Lawyer ID before processing: "${lawyers[index].id}", type: ${lawyers[index].id.runtimeType}');

                        // Use the HomeController to check for duplicate requests
                        _homeController.goToDirectCaseRequest(lawyers[index]);
                      },
                      fullWidth: true,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        key: const ValueKey('lawyers_listing_bottom_nav'),
        currentIndex: 2,
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 13,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تصفية حسب التخصص',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _specializations.map((spec) {
                      return _buildFilterChip(
                        label: spec,
                        isSelected: _selectedSpecialization == spec,
                        onSelected: (selected) {
                          setState(() {
                            _selectedSpecialization = spec;
                          });

                          this.setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: 'تطبيق',
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
