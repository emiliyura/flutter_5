import 'package:flutter/widgets.dart';

class UserState extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _city = '';
  DateTime? _registrationDate;
  String? _avatarUrl;
  bool _isAuthenticated = false;
  
  // Хранилище пользователей для демо (в реальном приложении это будет база данных)
  final Map<String, Map<String, dynamic>> _users = {};

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get city => _city;
  DateTime? get registrationDate => _registrationDate;
  String? get avatarUrl => _avatarUrl;
  bool get isAuthenticated => _isAuthenticated;

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void updateCity(String city) {
    _city = city;
    notifyListeners();
  }

  void updateAvatarUrl(String? url) {
    _avatarUrl = url;
    notifyListeners();
  }

  void updateUser({
    String? name,
    String? email,
    String? phone,
    String? city,
    String? avatarUrl,
  }) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (city != null) _city = city;
    if (avatarUrl != null) _avatarUrl = avatarUrl;
    notifyListeners();
  }

  bool authenticate(String email, String password) {
    final user = _users[email.toLowerCase()];
    if (user != null && user['password'] == password) {
      _name = user['name'] as String;
      _email = user['email'] as String;
      _phone = user['phone'] as String? ?? '';
      _city = user['city'] as String? ?? '';
      _registrationDate = user['registrationDate'] as DateTime?;
      _avatarUrl = user['avatarUrl'] as String?;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool register(String name, String email, String password) {
    final emailLower = email.toLowerCase();
    if (_users.containsKey(emailLower)) {
      return false; // Пользователь уже существует
    }
    
    _users[emailLower] = {
      'name': name,
      'email': email,
      'password': password,
      'phone': '',
      'city': '',
      'registrationDate': DateTime.now(),
      'avatarUrl': null,
    };
    
    _name = name;
    _email = email;
    _phone = '';
    _city = '';
    _registrationDate = DateTime.now();
    _avatarUrl = null;
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _name = '';
    _email = '';
    _phone = '';
    _city = '';
    _registrationDate = null;
    _avatarUrl = null;
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  void setUserData({
    required String name,
    required String email,
    String phone = '',
    String city = '',
    DateTime? registrationDate,
  }) {
    _name = name;
    _email = email;
    _phone = phone;
    _city = city;
    _registrationDate = registrationDate;
    _isAuthenticated = true;
    notifyListeners();
  }
}

class _UserStateInherited extends InheritedWidget {
  final UserState userState;

  const _UserStateInherited({
    required this.userState,
    required super.child,
  });

  @override
  bool updateShouldNotify(_UserStateInherited oldWidget) {
    return userState != oldWidget.userState;
  }
}

class UserStateProvider extends StatefulWidget {
  final UserState userState;
  final Widget child;

  const UserStateProvider({
    super.key,
    required this.userState,
    required this.child,
  });

  static UserState of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_UserStateInherited>();
    assert(inherited != null, 'UserStateProvider not found in widget tree');
    return inherited!.userState;
  }

  @override
  State<UserStateProvider> createState() => _UserStateProviderState();
}

class _UserStateProviderState extends State<UserStateProvider> {
  @override
  void initState() {
    super.initState();
    widget.userState.addListener(_onUserStateChanged);
  }

  @override
  void dispose() {
    widget.userState.removeListener(_onUserStateChanged);
    super.dispose();
  }

  void _onUserStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _UserStateInherited(
      userState: widget.userState,
      child: widget.child,
    );
  }
}

