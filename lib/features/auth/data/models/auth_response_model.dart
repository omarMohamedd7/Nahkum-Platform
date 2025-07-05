import 'package:nahkum/features/auth/data/models/user/user_model.dart';

class AuthResponseModel {
  final UserModel userModel;
  final String token;

  const AuthResponseModel({
    required this.userModel,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    json = json['data'];
    return AuthResponseModel(
      userModel: UserModel.fromJson(json['data'] ?? json['user']),
      token: json['token'] as String,
    );
  }
}
