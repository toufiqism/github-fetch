import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/repository_entity.dart';
import '../bloc/repo_list_cubit.dart';
import '../bloc/theme_cubit.dart';
import 'repository_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RepoListCubit>().refresh();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<RepoListCubit>().loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
        actions: [
          Row(children: [
            const Text('Dark mode'),
            Switch(
              value: isDark,
              onChanged: (v) => context.read<ThemeCubit>().toggle(v),
            ),
          ])
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                onChanged: (v) => context.read<RepoListCubit>().onSearchChanged(v),
              ),
            ),
            Expanded(
              child: BlocConsumer<RepoListCubit, RepoListState>(
                listener: (context, state) {
                  if (state.status == RepoListStatus.error && state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        action: SnackBarAction(
                          label: 'Retry',
                          onPressed: () => context.read<RepoListCubit>().loadMore(),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == RepoListStatus.loading) {
                    return _buildSkeletonList(context);
                  }
                  if (state.items.isEmpty) {
                    return const Center(child: Text('No repositories'));
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<RepoListCubit>().refresh(),
                    child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index == state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final item = state.items[index];
                        return _RepoCard(item: item);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: state.status == RepoListStatus.loadingMore
                          ? state.items.length + 1
                          : state.items.length,
                      padding: const EdgeInsets.all(12),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonList(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceVariant,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 12),
        ),
      ),
    );
  }
}

class _RepoCard extends StatelessWidget {
  final RepositoryEntity item;
  const _RepoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RepositoryDetailPage(repo: item)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name ?? 'Unnamed',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Icon(Icons.star, size: 18),
                const SizedBox(width: 4),
                Text('${item.stargazersCount ?? 0}')
              ],
            ),
            const SizedBox(height: 4),
            Text(item.ownerLogin ?? '-', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              item.description ?? '-',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

