import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/avatar_config.dart';

class UserProvider with ChangeNotifier {
  String _userName = '';
  bool _isOnboarded = false;
  bool _isLoading = true;
  AvatarConfig _avatarConfig = AvatarConfig.defaults();

  String get userName => _userName;
  bool get isOnboarded => _isOnboarded;
  bool get isLoading => _isLoading;
  AvatarConfig get avatarConfig => _avatarConfig;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? '';
    _isOnboarded = prefs.getBool('isOnboarded') ?? false;
    final avatarString = prefs.getString('avatarConfig');
    if (avatarString != null) {
      try {
        final decoded = jsonDecode(avatarString) as Map<String, dynamic>;
        _avatarConfig = AvatarConfig.fromJson(decoded);
      } catch (_) {
        _avatarConfig = AvatarConfig.random();
      }
    } else {
      final generated = AvatarConfig.random();
      _avatarConfig = generated;
      await prefs.setString('avatarConfig', jsonEncode(generated.toJson()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    _isOnboarded = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setBool('isOnboarded', true);

    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    _userName = name;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);

    notifyListeners();
  }

  Future<void> updateAvatarConfig(AvatarConfig config) async {
    _avatarConfig = config;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarConfig', jsonEncode(config.toJson()));
    notifyListeners();
  }
}
