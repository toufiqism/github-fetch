import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/repositories/github_repository.dart';
import '../../domain/usecases/search_repositories.dart';

part 'repo_list_state.dart';

class RepoListCubit extends Cubit<RepoListState> {
  final SearchRepositories searchRepositories;
  final int perPage;

  String _query = 'flutter';
  int _page = 1;
  bool _isLastPage = false;
  final _searchSubject = BehaviorSubject<String>();
  late final StreamSubscription<String> _searchSub;

  RepoListCubit({required this.searchRepositories, this.perPage = 20})
      : super(const RepoListState.initial()) {
    _searchSub = _searchSubject
        .debounceTime(const Duration(milliseconds: 400))
        .listen((q) {
      _query = q.isEmpty ? 'flutter' : q;
      refresh();
    });
  }

  void onSearchChanged(String value) => _searchSubject.add(value);

  Future<void> refresh() async {
    _page = 1;
    _isLastPage = false;
    emit(state.copyWith(status: RepoListStatus.loading, items: [], isFromCache: false));
    final res = await searchRepositories(query: _query, page: _page, perPage: perPage);
    if (res is Success<PagedRepositories>) {
      final items = res.data.items;
      _isLastPage = items.length < perPage;
      emit(state.copyWith(status: RepoListStatus.success, items: items, isFromCache: res.data.isFromCache));
    } else {
      emit(state.copyWith(status: RepoListStatus.error, errorMessage: res.asError.error.toString()));
    }
  }

  Future<void> loadMore() async {
    if (_isLastPage || state.status == RepoListStatus.loadingMore) return;
    emit(state.copyWith(status: RepoListStatus.loadingMore));
    final next = _page + 1;
    final res = await searchRepositories(query: _query, page: next, perPage: perPage);
    if (res is Success<PagedRepositories>) {
      final items = List<RepositoryEntity>.from(state.items)..addAll(res.data.items);
      _page = next;
      _isLastPage = res.data.items.length < perPage;
      emit(state.copyWith(status: RepoListStatus.success, items: items, isFromCache: res.data.isFromCache));
    } else {
      emit(state.copyWith(status: RepoListStatus.error, errorMessage: res.asError.error.toString()));
    }
  }

  @override
  Future<void> close() {
    _searchSub.cancel();
    _searchSubject.close();
    return super.close();
  }
}

