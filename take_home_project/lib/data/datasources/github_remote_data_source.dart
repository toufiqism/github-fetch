import 'package:dio/dio.dart';
import '../models/repository_model.dart';

abstract class GithubRemoteDataSource {
  Future<SearchResponseModel> searchRepositories({
    required String query,
    required int page,
    int perPage = 20,
  });
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  final Dio client;
  GithubRemoteDataSourceImpl(this.client);

  @override
  Future<SearchResponseModel> searchRepositories({
    required String query,
    required int page,
    int perPage = 20,
  }) async {
    final response = await client.get(
      'https://api.github.com/search/repositories',
      queryParameters: {
        'q': query,
        'sort': 'stars',
        'order': 'desc',
        'per_page': perPage,
        'page': page,
      },
      options: Options(
        headers: {
          'Accept': 'application/vnd.github+json',
        },
      ),
    );
    return SearchResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}

