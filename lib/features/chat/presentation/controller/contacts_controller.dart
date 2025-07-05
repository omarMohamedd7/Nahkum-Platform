import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/features/auth/data/models/user/user_model.dart';
import 'package:nahkum/features/chat/data/models/contact_model.dart';
import 'package:nahkum/features/chat/data/repo/chat_repo.dart';

class ContactsController extends GetxController {
  ChatRepo chatRepo = ChatRepo();

  final UserModel userModel = UserModel.fromJson(cache.read(CacheHelper.user));
  
  final RxBool isLoading = false.obs;

  RxList<ContactModel> contacts = <ContactModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getContacts();
  }

  Future<void> getContacts() async {
    isLoading(true);
    final dataState = await chatRepo.getContacts();
    if (dataState is DataSuccess) {
      contacts.value = dataState.data!.contacts;
    }
    isLoading(false);
  }
}
