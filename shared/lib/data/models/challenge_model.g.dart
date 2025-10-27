// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeModel _$ChallengeModelFromJson(Map<String, dynamic> json) =>
    ChallengeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      progressCurrent: (json['progressCurrent'] as num).toDouble(),
      progressTotal: (json['progressTotal'] as num).toDouble(),
      completed: json['completed'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChallengeModelToJson(ChallengeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'progressCurrent': instance.progressCurrent,
      'progressTotal': instance.progressTotal,
      'completed': instance.completed,
      'createdAt': instance.createdAt.toIso8601String(),
    };
