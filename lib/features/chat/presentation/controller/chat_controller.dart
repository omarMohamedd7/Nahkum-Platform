import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/fcm_service.dart';
import 'package:nahkum/features/chat/data/models/contact_model.dart';
import 'package:nahkum/features/chat/data/models/conversation_model.dart';
import 'package:nahkum/features/chat/data/repo/chat_repo.dart';

class ChatController extends GetxController {
  ChatRepo chatRepo = ChatRepo();

  final ContactModel contactModel = Get.arguments['contactModel'];

  final ScrollController scrollController = ScrollController();

  RxList<Message> messages = RxList.empty(growable: true);
  RxBool isLoading = false.obs;
  Future<void> getConversations() async {
    isLoading.value = true;
    final dataState = await chatRepo.getConversations(contactModel.id);
    if (dataState is DataSuccess<ConversationModel>) {
      messages.value = dataState.data!.messages;
    } else {
      showMessage(dataState.error.toString());
    }
    isLoading.value = false;
  }

  TextEditingController textController = TextEditingController();
  Future<void> sendMessage() async {
    messages.add(Message(
      date: DateTime.now(),
      receiverId: contactModel.id,
      message: textController.text,
      isSending: true,
    ));
    textController.clear();
    final dataState = await chatRepo.sendMessage(
      message: messages.last.message.toString(),
      receiverId: contactModel.id.toString(),
    );
    if (dataState is DataSuccess<Message>) {
      Message message = messages.removeLast();
      message.isSending = false;
      messages.add(message);
    } else {
      messages.removeLast();
      showMessage(dataState.error.toString(), isError: true);
    }
  }

  void receiveMessage(RemoteMessage message) {
    try {
      Map<String, dynamic> map = jsonDecode(message.notification?.body ?? '');
      if (contactModel.id == map['senderId']) {
        messages.add(Message.fromJson(map));
      } else {
        RemoteNotification newNotification = RemoteNotification(
          body: map['message'],
          android: message.notification!.android,
          apple: message.notification!.apple,
          bodyLocArgs: message.notification!.bodyLocArgs,
          bodyLocKey: message.notification!.bodyLocKey,
          title: message.notification!.title,
          titleLocArgs: message.notification!.titleLocArgs,
          titleLocKey: message.notification!.titleLocKey,
          web: message.notification!.web,
        );
        FcmService().displayNotification(newNotification);
      }
    } catch (e) {
      print(e.toString() + "ssssssssssssssssssssssssssss");
    }
  }

  void showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'خطأ' : 'نجاح',
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onInit() {
    getConversations();
    super.onInit();
  }
}
