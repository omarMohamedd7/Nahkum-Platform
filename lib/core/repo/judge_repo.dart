import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nahkum/core/data/data_service.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/features/judge/data/models/books_model.dart';
import 'package:nahkum/features/judge/data/models/prediction_model.dart';
import 'package:nahkum/features/judge/data/models/predictions_model.dart';
import 'package:nahkum/features/judge/data/models/tasks_model.dart';
import '../models/message_model.dart';

class JudgeRepo {
  final DataService _dataService = injector();

  Future<DataState<MessageModel>> addTask({
    required String title,
    required String description,
    required String date,
    required String time,
  }) async {
    return await _dataService.postData(
      endPoint: '/judge/tasks',
      data: {
        'title': title,
        'description': description,
        'date': date,
        'time': time,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<TasksModel>> getTasks() async {
    return await _dataService.getData(
      endPoint: '/judge/tasks',
      fromJson: TasksModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> updateTask({
    required int taskId,
    required String title,
    required String description,
    required String date,
    required String time,
  }) async {
    return await _dataService.putData(
      endPoint: '/judge/tasks/$taskId',
      data: {
        'title': title,
        'description': description,
        'date': date,
        'time': time,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> deleteTask({
    required int taskId,
  }) async {
    return await _dataService.deleteData(
      endPoint: '/judge/tasks/$taskId',
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<BooksModel>> getBooks() async {
    return await _dataService.getData(
      endPoint: '/legal-books',
      fromJson: BooksModel.fromJson,
    );
  }

  Future<DataState<PredictionsModel>> getPredictionsHistory() async {
    return await _dataService.getData(
      endPoint: '/video-analyses',
      fromJson: PredictionsModel.fromJson,
    );
  }

  Future<DataState<PredictionModel>> predictVideo({required File file}) async {
    return await _dataService.postData(
      endPoint: '/video-analyses',
      data: FormData.fromMap({
        'video': await MultipartFile.fromFile(file.path),
      }),
      fromJson: PredictionModel.fromJson,
    );
  }
}
