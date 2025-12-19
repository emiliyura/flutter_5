// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProviderModel _$UserProviderModelFromJson(Map<String, dynamic> json) =>
    UserProviderModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      registrationDate: json['registrationDate'] == null
          ? null
          : DateTime.parse(json['registrationDate'] as String),
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$UserProviderModelToJson(UserProviderModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'city': instance.city,
      'registrationDate': instance.registrationDate?.toIso8601String(),
      'avatarUrl': instance.avatarUrl,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProviderHash() => r'154288a3ab255b0997bda126185c75eedbc4a003';

/// See also [UserProvider].
@ProviderFor(UserProvider)
final userProviderProvider =
    AutoDisposeNotifierProvider<UserProvider, UserStateSnapshot>.internal(
      UserProvider.new,
      name: r'userProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserProvider = AutoDisposeNotifier<UserStateSnapshot>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
