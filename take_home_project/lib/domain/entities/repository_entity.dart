import 'package:equatable/equatable.dart';

class RepositoryEntity extends Equatable {
  final int? id;
  final String? name;
  final String? fullName;
  final String? ownerLogin;
  final String? ownerAvatarUrl;
  final String? description;
  final int? stargazersCount;
  final int? forksCount;
  final String? htmlUrl;

  const RepositoryEntity({
    required this.id,
    required this.name,
    required this.fullName,
    required this.ownerLogin,
    required this.ownerAvatarUrl,
    required this.description,
    required this.stargazersCount,
    required this.forksCount,
    required this.htmlUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        fullName,
        ownerLogin,
        ownerAvatarUrl,
        description,
        stargazersCount,
        forksCount,
        htmlUrl,
      ];
}

