import '../../core/network/network_info.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/github_local_data_source.dart';
import '../datasources/github_remote_data_source.dart';
import '../models/repository_model.dart';

class GithubRepositoryImpl implements GithubRepository {
  final GithubRemoteDataSource remote;
  final GithubLocalDataSource local;
  final NetworkInfo networkInfo;

  GithubRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  String _cacheKey(String q, int page, int perPage) => 'q=$q&page=$page&per=$perPage';

  @override
  Future<Result<PagedRepositories>> searchRepositories({
    required String query,
    required int page,
    int perPage = 20,
  }) async {
    final key = _cacheKey(query, page, perPage);
    final online = await networkInfo.isConnected;

    if (online) {
      try {
        final remoteRes = await remote.searchRepositories(query: query, page: page, perPage: perPage);
        await local.cacheSearchResult(cacheKey: key, data: remoteRes);
        final items = (remoteRes.items ?? const <RepositoryModel>[])
            .map((e) => e.toEntity())
            .toList(growable: false);
        return Success(PagedRepositories(items: items, isFromCache: false));
      } catch (e) {
        // Try cache fallback
        final cached = await local.getCachedSearchResult(key);
        if (cached != null) {
          final items = (cached.items ?? const <RepositoryModel>[])
              .map((e) => e.toEntity())
              .toList(growable: false);
          return Success(PagedRepositories(items: items, isFromCache: true));
        }
        return Error(e);
      }
    } else {
      final cached = await local.getCachedSearchResult(key);
      if (cached != null) {
        final items = (cached.items ?? const <RepositoryModel>[])
            .map((e) => e.toEntity())
            .toList(growable: false);
        return Success(PagedRepositories(items: items, isFromCache: true));
      }
      return Error(StateError('No connection and no cached data'));
    }
  }
}

