import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe_ecommerce/export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fullName;
  String? email;
  String? phone;
  String? gender;
  String? dob;
  String? profileImage;
  List<Map<String, dynamic>> addresses = [];

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fullName = prefs.getString('userName') ?? '';
      email = prefs.getString('userEmail') ?? '';
      phone = prefs.getString('userPhone') ?? '';
      gender = prefs.getString('userGender') ?? '';
      dob = prefs.getString('userDob') ?? '';
      profileImage = prefs.getString('userProfileImage');

      final addressList = prefs.getStringList('userAddresses') ?? [];
      addresses = addressList
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 140.sp,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60.r,
                  backgroundImage: profileImage != null &&
                          profileImage!.isNotEmpty
                      ? NetworkImage(profileImage!) as ImageProvider
                      : const AssetImage("assets/images/user.jpeg"),
                ),
              ),
              Positioned(
                child: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  radius: 15.r,
                  child: Icon(
                    Icons.photo,
                    color: Colors.white,
                    size: 15.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.sp),
          CustomTextField(title: "Full Name", hintText: fullName ?? ''),
          SizedBox(height: 20.sp),
          CustomTextField(title: "Email Address", hintText: email ?? ''),
          SizedBox(height: 20.sp),
          CustomTextField(title: "Phone Number", hintText: phone ?? ''),
      
          SizedBox(height: 20.sp),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "Update",
              onPressed: () {
                // Update logic here
              },
            ),
          ),
        ],
      ),
    );
  }
}
