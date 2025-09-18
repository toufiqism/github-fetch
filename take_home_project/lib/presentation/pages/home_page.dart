import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
        elevation: 0,
        title: Text(
          'Repositories',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(
                  'Dark mode',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isDark,
                  onChanged: (v) => context.read<ThemeCubit>().toggle(v),
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.grey : Colors.grey.shade600,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey : Colors.grey.shade600,
                  ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
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
                        return _RepoCard(item: item, isDark: isDark);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: state.status == RepoListStatus.loadingMore
                          ? state.items.length + 1
                          : state.items.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;
    
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade300,
        highlightColor: isDark ? const Color(0xFF3C3C3E) : Colors.grey.shade100,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 12),
        ),
      ),
    );
  }
}

class _RepoCard extends StatelessWidget {
  final RepositoryEntity item;
  final bool isDark;
  const _RepoCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RepositoryDetailPage(repo: item)),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name ?? 'Repository name',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.star,
                  size: 16,
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '${item.stargazersCount ?? 500}',
                  style: TextStyle(
                    color: isDark ? Colors.grey : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.ownerLogin ?? 'username',
              style: TextStyle(
                color: isDark ? Colors.grey : Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

