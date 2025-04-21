import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/screens/home_screen.dart';
import 'package:shoe_ecommerce/screens/profile/profile_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  int selectedIndex=0;
   BottomNavBarScreen({required this.selectedIndex,super.key});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
      final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const HomeScreen(),
    FavouriteScreen(),
    const Center(child: Text('Shop Screen', style: TextStyle(fontSize: 24))),
    NotificationScreen(),
   const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }
String _getTitleForIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Favourites';
    case 2:
      return 'Shop';
    case 3:
      return 'Notifications';
    case 4:
      return 'Profile';
    default:
      return '';
  }
}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
         key: scaffoldKey,
        resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.backgroundColor,
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.sp),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
          child: CustomAppbar(
            
            leading:CustomIconButton(
                    icon: Icons.more_horiz_outlined,
                    onTap: (){ scaffoldKey.currentState!.openDrawer();}
                      
                  ),
       
            trailing:CustomIconButton(icon:  Icons.shopping_cart_outlined, onTap: (){context.push(RouteNames.cart);})
            ,
            apptitle:widget.selectedIndex==0?null: _getTitleForIndex(widget.selectedIndex),
            centerWidget: widget.selectedIndex==0? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Store location",
            style: TextStyle(
                fontFamily: "AirbnbCereal",
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
                color: Colors.black54),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: AppTheme.redColor,
              ),
              Text(
                "Mondolibug, Sylhet",
                style: TextStyle(
                    fontFamily: "AirbnbCereal",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ):null,
            centerTitle: true,
          ),
        ),
      ),
    
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: _pages[widget.selectedIndex]),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(width, 80),
            painter: WavePainter(),
            child: SizedBox(
              height: 80,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.shopping_bag,
                        color: Colors.transparent,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.notifications_none), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline), label: ''),
                ],
                currentIndex: widget.selectedIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                showSelectedLabels: false,
                showUnselectedLabels: false,
              ),
            ),
          ),
          Positioned(
            bottom: 60.sp, // Lowered a bit more
            left: width / 2 - 30.sp, // Adjusted for better centering
            child: Transform.translate(
              offset: const Offset(0, 10), // Moves the FAB slightly down
              child: GestureDetector(
                onTap: () {
                  _onItemTapped(2);
                },
                child: Container(
                  width: 55.sp, // Ensures circular shape
                  height: 55.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 4,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shopping_bag, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppTheme.whiteColor
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height - 100);
    path.lineTo(size.width / 2.6, size.height - 80);
    path.lineTo(size.width / 2.6, size.height - 50);
    path.lineTo(size.width / 2.4, size.height - 40);
    path.lineTo(size.width * 0.56, size.height - 40);
    path.lineTo(size.width * 0.60, size.height - 50);
    path.lineTo(size.width * 0.60, size.height - 80);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
