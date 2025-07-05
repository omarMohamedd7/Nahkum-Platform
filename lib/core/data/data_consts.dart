import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:dio/dio.dart';

class DataConsts {
  // static const String domain = 'http://10.173.20.108:8000';
  // static const String domain = 'http://192.168.43.120:8000';
  static const String domain = 'http://192.168.213.39:8000';
  // static const String domain = 'http://10.0.2.2:8000';
  static const String apiBaseURL = '$domain/api';
  static const String imageBaseURL = '$domain/';
}

Options options() => Options(
      headers: {
        'Authorization': 'Bearer ${cache.read(CacheHelper.token)}',
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
