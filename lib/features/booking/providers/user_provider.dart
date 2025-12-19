import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/service_locator.dart';
import '../../../shared/state/user_state.dart';

part 'user_provider.g.dart';

@JsonSerializable()
class UserProviderModel {
  final String name;
  final String email;
  final String phone;
  final String city;
  final DateTime? registrationDate;
  final String? avatarUrl;

  UserProviderModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    this.registrationDate,
    this.avatarUrl,
  });

  factory UserProviderModel.fromJson(Map<String, dynamic> json) =>
      _$UserProviderModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProviderModelToJson(this);
}

class UserStateSnapshot {
  final String name;
  final String email;
  final String phone;
  final String city;
  final DateTime? registrationDate;
  final String? avatarUrl;

  UserStateSnapshot({
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    this.registrationDate,
    this.avatarUrl,
  });

  factory UserStateSnapshot.fromUserState(UserState userState) {
    return UserStateSnapshot(
      name: userState.name,
      email: userState.email,
      phone: userState.phone,
      city: userState.city,
      registrationDate: userState.registrationDate,
      avatarUrl: userState.avatarUrl,
    );
  }
}

@riverpod
class UserProvider extends _$UserProvider {
  UserState? _userState;

  @override
  UserStateSnapshot build() {
    _userState = getIt<UserState>();
    _userState!.addListener(_onUserStateChanged);
    ref.onDispose(() {
      _userState?.removeListener(_onUserStateChanged);
    });
    return UserStateSnapshot.fromUserState(_userState!);
  }

  void _onUserStateChanged() {
    if (_userState != null) {
      state = UserStateSnapshot.fromUserState(_userState!);
    }
  }

  String getUserName() => state.name;

  String getUserEmail() => state.email;

  String getUserPhone() => state.phone;

  String getUserCity() => state.city;

  void updateUserName(String userName) {
    _userState?.updateName(userName);
  }

  void updateUserPhone(String phone) {
    _userState?.updatePhone(phone);
  }

  void updateUserCity(String city) {
    _userState?.updateCity(city);
  }
}
