import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../entities/repository_entity.dart';

class PagedRepositories {
  final List<RepositoryEntity> items;
  final bool isFromCache;
  const PagedRepositories({required this.items, required this.isFromCache});
}

abstract class GithubRepository {
  Future<Result<PagedRepositories>> searchRepositories({
    required String query,
    required int page,
    int perPage = 20,
  });
}

