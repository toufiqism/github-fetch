import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/repository_model.dart';

abstract class GithubLocalDataSource {
  Future<void> cacheSearchResult({required String cacheKey, required SearchResponseModel data});
  Future<SearchResponseModel?> getCachedSearchResult(String cacheKey);
}

class GithubLocalDataSourceImpl implements GithubLocalDataSource {
  static const String prefix = 'cache_search_';
  final SharedPreferences prefs;
  GithubLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheSearchResult({required String cacheKey, required SearchResponseModel data}) async {
    await prefs.setString(prefix + cacheKey, jsonEncode(data.toJson()));
  }

  @override
  Future<SearchResponseModel?> getCachedSearchResult(String cacheKey) async {
    final str = prefs.getString(prefix + cacheKey);
    if (str == null) return null;
    return SearchResponseModel.fromJson(jsonDecode(str) as Map<String, dynamic>);
  }
}

