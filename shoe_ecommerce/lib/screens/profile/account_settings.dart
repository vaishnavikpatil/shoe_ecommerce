import 'package:flutter/material.dart';
import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/widgets/custom_scaffold.dart';


class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool enableFaceID = false;
  bool enablePushNotifications = true;
  bool enableLocationServices = true;
  bool darkMode = false;

  Widget buildListTile(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
       Icon(icon, color: Colors.grey[700]),
       SizedBox(width: 10.sp,),
         Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
         const Icon(Icons.arrow_forward_ios, size: 16),
        ]
      
       
      ),
    );
  }

Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
   Switch(
  value: value,
  onChanged: onChanged,
 activeColor: Colors.white,
            activeTrackColor: Colors.yellow,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black45,


)


      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leadingIcon: Icons.arrow_back_ios,
      onLeadingTap: (){context.pop();},
      apptitle: "Account Settings",
      centerTitle: true,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),
          const Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          buildListTile("Notification Setting", Icons.notifications, () {}),
          buildListTile("Shipping Address", Icons.shopping_cart, () {}),
          buildListTile("Payment Info", Icons.credit_card, () {}),
          buildListTile("Delete Account", Icons.delete_outline, () {}),
          const SizedBox(height: 24),
          const Text("App Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  
          buildSwitchTile("Enable Face ID For Log In", enableFaceID, (value) {
            setState(() => enableFaceID = value);
          }),
          buildSwitchTile("Enable Push Notifications", enablePushNotifications, (value) {
            setState(() => enablePushNotifications = value);
          }),
          buildSwitchTile("Enable Location Services", enableLocationServices, (value) {
            setState(() => enableLocationServices = value);
          }),
          buildSwitchTile("Dark Mode", darkMode, (value) {
            setState(() => darkMode = value);
          }),
        ],
      ),
    );
  }
}
