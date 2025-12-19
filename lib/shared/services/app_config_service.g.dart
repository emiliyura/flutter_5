// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigService _$AppConfigServiceFromJson(Map<String, dynamic> json) =>
    AppConfigService(
      appName: json['appName'] as String,
      appVersion: json['appVersion'] as String,
      apiBaseUrl: json['apiBaseUrl'] as String,
      isDebugMode: json['isDebugMode'] as bool,
    );

Map<String, dynamic> _$AppConfigServiceToJson(AppConfigService instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'appVersion': instance.appVersion,
      'apiBaseUrl': instance.apiBaseUrl,
      'isDebugMode': instance.isDebugMode,
    };
