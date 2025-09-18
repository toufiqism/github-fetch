import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/repository_entity.dart';

part 'repository_model.g.dart';

@JsonSerializable()
class OwnerModel {
  final String? login;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  OwnerModel({required this.login, required this.avatarUrl});

  factory OwnerModel.fromJson(Map<String, dynamic> json) => _$OwnerModelFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerModelToJson(this);
}

@JsonSerializable()
class RepositoryModel {
  final int? id;
  final String? name;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final OwnerModel? owner;
  final String? description;
  @JsonKey(name: 'stargazers_count')
  final int? stargazersCount;
  @JsonKey(name: 'forks_count')
  final int? forksCount;
  @JsonKey(name: 'html_url')
  final String? htmlUrl;

  RepositoryModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.owner,
    required this.description,
    required this.stargazersCount,
    required this.forksCount,
    required this.htmlUrl,
  });

  RepositoryEntity toEntity() => RepositoryEntity(
        id: id,
        name: name,
        fullName: fullName,
        ownerLogin: owner?.login,
        ownerAvatarUrl: owner?.avatarUrl,
        description: description,
        stargazersCount: stargazersCount,
        forksCount: forksCount,
        htmlUrl: htmlUrl,
      );

  factory RepositoryModel.fromEntity(RepositoryEntity e) => RepositoryModel(
        id: e.id,
        name: e.name,
        fullName: e.fullName,
        owner: OwnerModel(login: e.ownerLogin, avatarUrl: e.ownerAvatarUrl),
        description: e.description,
        stargazersCount: e.stargazersCount,
        forksCount: e.forksCount,
        htmlUrl: e.htmlUrl,
      );

  factory RepositoryModel.fromJson(Map<String, dynamic> json) => _$RepositoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryModelToJson(this);
}

@JsonSerializable()
class SearchResponseModel {
  @JsonKey(name: 'total_count')
  final int? totalCount;
  final List<RepositoryModel>? items;

  SearchResponseModel({required this.totalCount, required this.items});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) => _$SearchResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);
}

