import 'dart:convert';
import 'package:shoe_ecommerce/model/user_model.dart';
import 'package:shoe_ecommerce/utils/constants/apihelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await ApiHelper.post('auth/login', {
      'email': email,
      'password': password,
    });

    if (res['success']) {
      final token = res['data']['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      await getUser();

      return {'user': UserDetails.fromJson(res['data']['user']), 'token': token};
    } else {
      return {'error': res['error']};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final res = await ApiHelper.post('auth/register', {
      'userName': name,
      'email': email,
      'password': password,
    });

    if (res['success']) {
      final token = res['data']['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      await getUser();

      return {'user': UserDetails.fromJson(res['data']['user']), 'token': token};
    } else {
      return {'error': res['error']};
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email, String newPassword) async {
    final res = await ApiHelper.post('auth/forgot-password', {
      'email': email,
      'newPassword': newPassword,
    });

    return res['success']
        ? {'message': res['data']['message']}
        : {'error': res['error']};
  }

  static Future<void> getUser() async {
    final res = await ApiHelper.get('auth/profile');

    if (res['success']) {
      final user = UserDetails.fromJson(res['data']['user']);
      SharedPreferences prefs = await SharedPreferences.getInstance();


      prefs.setString('userName', user.name ?? '');
      prefs.setString('userEmail', user.email );
      prefs.setString('userPhone', user.phone ?? '');
      prefs.setString('userProfileImage', user.profileImage ?? '');
      prefs.setString('userGender', user.gender ?? '');
      prefs.setString('userDob', user.dob ?? '');
      prefs.setStringList('userAddresses',
          user.addresses?.map((a) => jsonEncode(a.toJson())).toList() ?? []);
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? userName,
    String? email,
    String? phone,
    String? profileImage,
    String? gender,
    String? dob,
    String? fullName,
    List<AddressModel>? addresses,
  }) async {
    final Map<String, dynamic> data = {};

    if (userName != null) data['userName'] = userName;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (profileImage != null) data['profileImage'] = profileImage;
    if (gender != null) data['gender'] = gender;
    if (dob != null) data['dob'] = dob;
    if (fullName != null) data['fullName'] = fullName;
    if (addresses != null) {
      data['addresses'] = addresses.map((a) => a.toJson()).toList();
    }

    final res = await ApiHelper.put('auth/update-profile', data);

    if (res['success']) {
      final updatedUser = UserDetails.fromJson(res['data']['user']);
      await getUser();
      return {'user': updatedUser};
    } else {
      return {'error': res['error']};
    }
  }
}
