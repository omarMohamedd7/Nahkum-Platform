import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/features/lawer/data/models/case_model.dart';
import 'package:nahkum/features/lawer/presentation/widgets/lawyer_app_bar.dart';
import '../controllers/clients_controller.dart';
import '../widgets/client_card.dart';
import '../widgets/lawyer_bottom_navigation_bar.dart';

class ClientsView extends GetView<ClientsController> {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: Column(
            children: [
              44.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LawyerAppBar(title: 'الموكلين'),
              ),
              // Clients List
              Expanded(
                child: _buildClientsListView(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const LawyerBottomNavigationBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildClientsListView() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFC8A45D)),
        );
      }

      if (controller.clients.isEmpty) {
        return const Center(
          child: Text(
            'لا يوجد موكلين',
            style: TextStyle(color: Color(0xFF737373), fontFamily: 'Almarai'),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: controller.clients.length,
        itemBuilder: (context, index) {
          final client = controller.clients[index];

          CaseModel? clientCase = _findCaseForClient(client.client!.clientId);

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClientCard(
              client: client.client!,
              caseItem: clientCase,
              onTap: () {},
            ),
          );
        },
      );
    });
  }

  CaseModel? _findCaseForClient(int clientId) {
    try {
      return controller.clients
          .firstWhere((caseItem) => caseItem.caseId == clientId);
    } catch (e) {
      return null;
    }
  }
}
