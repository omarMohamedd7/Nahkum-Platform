import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nahkum/core/data/data_service.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/features/profile/data/models/profile_model.dart';

class ProfileRepo {
  final DataService _dataService = injector();

  Future<DataState<ProfileModel>> getProfile() async {
    return await _dataService.getData(
      endPoint: '/me',
      fromJson: ProfileModel.fromJson,
    );
  }

  Future<DataState<ProfileModel>> editProfile({
    required String name,
    required String email,
    required XFile? imageToEdit,
  }) async {
    return await _dataService.postData(
      data: FormData.fromMap({
        'email': email,
        'name': name,
        if (imageToEdit != null)
          'profile_picture': await MultipartFile.fromFile(
            imageToEdit.path,
            filename: imageToEdit.path.split('/').last,
          ),
      }),
      endPoint: '/profile',
      fromJson: ProfileModel.fromJson,
    );
  }
}
