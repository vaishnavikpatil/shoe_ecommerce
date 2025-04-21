import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe_ecommerce/model/user_model.dart';
import 'package:shoe_ecommerce/service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserDetails? _userDetails;
  bool _loading = false;

  UserDetails? get userDetails => _userDetails;
  bool get isLoading => _loading;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      _userDetails = UserDetails(
        name: prefs.getString('userName') ?? '',
        email: prefs.getString('userEmail') ?? '',
        phone: prefs.getString('userPhone'),
        profileImage: prefs.getString('userProfileImage'),
        gender: prefs.getString('userGender'),
        dob: prefs.getString('userDob'),
        addresses: (prefs.getStringList('userAddresses') ?? [])
            .map((e) => AddressModel.fromJson(jsonDecode(e)))
            .toList(),
      );
      notifyListeners();
    }
  }

  Future<String?> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    final result = await AuthService.login(email, password);

    _loading = false;

    if (result['user'] != null) {
      _userDetails = result['user'];
      await _saveToken(result['token']);
      await _saveUserToPrefs(_userDetails!);
      notifyListeners();
      return null;
    } else {
      return result['error'];
    }
  }

  Future<String?> register(String name, String email, String password) async {
    _loading = true;
    notifyListeners();

    final result = await AuthService.register(name, email, password);

    _loading = false;

    if (result['user'] != null) {
      _userDetails = result['user'];
      await _saveToken(result['token']);
      await _saveUserToPrefs(_userDetails!);
      notifyListeners();
      return null;
    } else {
      return result['error'];
    }
  }

  Future<String?> forgotPassword(String email, String newPassword) async {
    _loading = true;
    notifyListeners();

    final result = await AuthService.forgotPassword(email, newPassword);

    _loading = false;
    return result['message'] != null ? null : result['error'];
  }

  Future<String?> updateProfile({
    String? phone,
    String? name,
    String? email,
    String? profileImage,
    String? gender,
    String? dob,
    String? fullName,
    List<AddressModel>? addresses,
  }) async {
    _loading = true;
    notifyListeners();

    final result = await AuthService.updateProfile(
      userName: name ?? _userDetails?.name ?? '',
      email: email ?? _userDetails?.email ?? '',
      phone: phone ?? _userDetails?.phone ?? '',
      profileImage: profileImage ?? _userDetails?.profileImage ?? '',
      gender: gender ?? _userDetails?.gender ?? '',
      dob: dob ?? _userDetails?.dob ?? '',
      fullName: fullName ?? _userDetails?.name ?? '',
      addresses: addresses ?? _userDetails?.addresses,
    );

    _loading = false;

    if (result['user'] != null) {
      _userDetails = result['user'];
      await _saveUserToPrefs(_userDetails!);
      notifyListeners();
      return null;
    } else {
      return result['error'];
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _saveUserToPrefs(UserDetails userDetails) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userDetails.name ?? '');
    prefs.setString('userEmail', userDetails.email );
    prefs.setString('userPhone', userDetails.phone ?? '');
    prefs.setString('userProfileImage', userDetails.profileImage ?? '');
    prefs.setString('userGender', userDetails.gender ?? '');
    prefs.setString('userDob', userDetails.dob ?? '');
    prefs.setStringList('userAddresses',
        userDetails.addresses?.map((a) => jsonEncode(a.toJson())).toList() ?? []);
  }
}
