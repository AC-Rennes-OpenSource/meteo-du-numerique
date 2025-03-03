// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      date: json['date'] as String?,
      isUrgent: json['isUrgent'] as bool? ?? false,
      isVisible: json['isVisible'] as bool? ?? true,
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date,
      'isUrgent': instance.isUrgent,
      'isVisible': instance.isVisible,
    };
