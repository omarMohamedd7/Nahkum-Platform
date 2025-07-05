import 'package:nahkum/core/data/data_service.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/features/chat/data/models/contacts_list_model.dart';
import 'package:nahkum/features/chat/data/models/conversation_model.dart';

class ChatRepo {
  DataService dataService = injector();

  Future<DataState<ContactsModel>> getContacts() async {
    return await dataService.getData(
      endPoint: '/contacts',
      fromJson: ContactsModel.fromJson,
    );
  }

  Future<DataState<ConversationModel>> getConversations(int receiverId) async {
    return await dataService.getData(
      endPoint: '/chat/$receiverId',
      fromJson: ConversationModel.fromJson,
    );
  }

  Future<DataState<Message>> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    return await dataService.postData(
      endPoint: '/messages',
      fromJson: Message.sendFromJson,
      data: {
        'receiver_id': receiverId,
        'message': message,
      },
    );
  }
}
