// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnerModel _$OwnerModelFromJson(Map<String, dynamic> json) => OwnerModel(
  login: json['login'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$OwnerModelToJson(OwnerModel instance) =>
    <String, dynamic>{
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
    };

RepositoryModel _$RepositoryModelFromJson(Map<String, dynamic> json) =>
    RepositoryModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fullName: json['full_name'] as String?,
      owner: json['owner'] == null
          ? null
          : OwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      description: json['description'] as String?,
      stargazersCount: (json['stargazers_count'] as num?)?.toInt(),
      forksCount: (json['forks_count'] as num?)?.toInt(),
      htmlUrl: json['html_url'] as String?,
    );

Map<String, dynamic> _$RepositoryModelToJson(RepositoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'owner': instance.owner,
      'description': instance.description,
      'stargazers_count': instance.stargazersCount,
      'forks_count': instance.forksCount,
      'html_url': instance.htmlUrl,
    };

SearchResponseModel _$SearchResponseModelFromJson(Map<String, dynamic> json) =>
    SearchResponseModel(
      totalCount: (json['total_count'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => RepositoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchResponseModelToJson(
  SearchResponseModel instance,
) => <String, dynamic>{
  'total_count': instance.totalCount,
  'items': instance.items,
};
