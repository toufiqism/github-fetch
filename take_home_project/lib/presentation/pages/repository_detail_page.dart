import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/repository_entity.dart';

class RepositoryDetailPage extends StatelessWidget {
  final RepositoryEntity repo;
  const RepositoryDetailPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(repo.fullName ?? 'Repository')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: repo.ownerAvatarUrl != null
                        ? CachedNetworkImageProvider(repo.ownerAvatarUrl!)
                        : null,
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(repo.ownerLogin ?? '-', style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(repo.description ?? '-'),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star),
                  const SizedBox(width: 4),
                  Text('${repo.stargazersCount ?? 0}'),
                  const SizedBox(width: 16),
                  const Icon(Icons.call_split),
                  const SizedBox(width: 4),
                  Text('${repo.forksCount ?? 0}'),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: repo.htmlUrl == null
                      ? null
                      : () => launchUrl(Uri.parse(repo.htmlUrl!), mode: LaunchMode.externalApplication),
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Open in GitHub'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

