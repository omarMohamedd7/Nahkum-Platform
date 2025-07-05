import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nahkum/features/auth/data/models/user/user_model.dart';

class ProfileModel extends UserModel {
  XFile? imageToEdit;

  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.profileImageUrl,
    super.profileImageFullUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.profileInfo,
    this.imageToEdit,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    json = json['data'];
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profileImageUrl: json['profile_image_url'],
      profileImageFullUrl: json['profile_image_full_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      profileInfo: ProfileInfo.fromJson(json['profile_info']),
    );
  }

  Future<Map<String, dynamic>> editToJson() async => {
        'email': email,
        'name': name,
        if (imageToEdit != null)
          'image': await MultipartFile.fromFile(
            imageToEdit!.path,
            filename: imageToEdit!.path.split('/').last,
          ),
      };
}
