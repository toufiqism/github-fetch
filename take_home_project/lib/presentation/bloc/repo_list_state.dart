part of 'repo_list_cubit.dart';

enum RepoListStatus { initial, loading, loadingMore, success, error }

class RepoListState extends Equatable {
  final RepoListStatus status;
  final List<RepositoryEntity> items;
  final bool isFromCache;
  final String? errorMessage;

  const RepoListState({
    required this.status,
    required this.items,
    required this.isFromCache,
    required this.errorMessage,
  });

  const RepoListState.initial()
      : status = RepoListStatus.initial,
        items = const [],
        isFromCache = false,
        errorMessage = null;

  RepoListState copyWith({
    RepoListStatus? status,
    List<RepositoryEntity>? items,
    bool? isFromCache,
    String? errorMessage,
  }) {
    return RepoListState(
      status: status ?? this.status,
      items: items ?? this.items,
      isFromCache: isFromCache ?? this.isFromCache,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, isFromCache, errorMessage];
}

