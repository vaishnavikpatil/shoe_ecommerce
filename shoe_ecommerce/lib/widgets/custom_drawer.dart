

import 'package:shoe_ecommerce/export.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A2530),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/user.jpeg'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  const Text('Hey, 👋', style: TextStyle(color: Colors.grey)),
                  Text(userName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildDrawerItem(context, Icons.person, 'Profile',
                () => context.go(RouteNames.home, extra: 4)),
            _buildDrawerItem(context, Icons.home, 'Home Page',
                () => context.go(RouteNames.home, extra: 0)),
            _buildDrawerItem(context, Icons.shopping_cart, 'My Cart',
                () => context.push(RouteNames.cart)),
            _buildDrawerItem(context, Icons.favorite_border, 'Favorite',
                () => context.go(RouteNames.home, extra: 1)),
            _buildDrawerItem(context, Icons.local_shipping, 'Orders', () {}),
            _buildDrawerItem(context, Icons.notifications_none, 'Notifications',
                () => context.go(RouteNames.home, extra: 3)),
            _buildDrawerItem(context, Icons.settings, 'Account Settings', () {
              // context.push(RouteNames.settings);
            }),
            const Spacer(),
            const Divider(),
            _buildDrawerItem(context, Icons.logout, 'Sign Out', () {
              _signOut(context);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        context.pop(); // Close the drawer
        onTap(); // Then do the action
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    context.go(RouteNames.signIn);
  }
}
