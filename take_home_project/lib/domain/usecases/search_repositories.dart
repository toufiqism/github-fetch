import '../../core/utils/result.dart';
import '../entities/repository_entity.dart';
import '../repositories/github_repository.dart';

class SearchRepositories {
  final GithubRepository repository;
  const SearchRepositories(this.repository);

  Future<Result<PagedRepositories>> call({
    required String query,
    required int page,
    int perPage = 20,
  }) {
    return repository.searchRepositories(query: query, page: page, perPage: perPage);
  }
}

