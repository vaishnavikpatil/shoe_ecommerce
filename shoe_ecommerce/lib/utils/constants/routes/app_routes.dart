

import 'package:shoe_ecommerce/export.dart';

import 'package:shoe_ecommerce/screens/order/checkout_screen.dart';
import 'package:shoe_ecommerce/screens/order/order_list.dart';



class AppRouter {
  // Create a reusable route template function
  static GoRoute _createRoute({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<RouteBase> routes = const <RouteBase>[],
  }) {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: builder(context, state),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Use SlideTransition instead of FadeTransition
            const begin = Offset(1.0, 0.0); // Start from right
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          barrierColor: Colors.white),
      routes: routes,
    );
  }

  static Future<String> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return (token != null && token.isNotEmpty)
        ? RouteNames.home
        :RouteNames.onboarding
         ;
  }

  static Future<GoRouter> getRouter() async {
    final initialRoute = await getInitialRoute();

    return GoRouter(
      initialLocation: initialRoute,
      debugLogDiagnostics: true,
      routes: [
      
        _createRoute(
          path: RouteNames.onboarding,
          name: RouteNames.onboarding,
          builder: (context, state) =>  const OnboardingScreen(),
        ),
         _createRoute(
          path: RouteNames.search,
          name: RouteNames.search,
          builder: (context, state) =>  const SearchScreen(),
        ),
          _createRoute(
          path: RouteNames.signIn,
          name: RouteNames.signIn,
          builder: (context, state) => const SignIn(),
        ),
          _createRoute(
          path: RouteNames.signUp,
          name: RouteNames.signUp,
          builder: (context, state) => const SignUp(),
        ),
          _createRoute(
          path: RouteNames.forgotPassword,
          name: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPassword(),
        ),

    _createRoute(
  path: RouteNames.home,
  name: RouteNames.home,
  builder: (context, state) {
    final index = state.extra as int? ?? 0;
    return BottomNavBarScreen(selectedIndex: index);
  },
),

         
          _createRoute(
          path: RouteNames.settings,
          name: RouteNames.settings,
          builder: (context, state) =>   AccountSettingsScreen(),
        ),
          _createRoute(
          path: RouteNames.checkout,
          name: RouteNames.checkout,
          builder: (context, state) =>   const CheckoutScreen(),
        ),
           _createRoute(
          path: RouteNames.cart,
          name: RouteNames.cart,
          builder: (context, state) =>   const CartScreen(),
        ),
           _createRoute(
          path: RouteNames.orderList,
          name: RouteNames.orderList,
          builder: (context, state) =>   const OrderListScreen(),
        ),
   _createRoute(
  path: RouteNames.productDetails,
  name: RouteNames.productDetails,
  builder: (context, state) {
    final product = state.extra as Product;
    return ProductDetails(product: product);
  },
),

    
      ],
      errorBuilder: (context, state) => const ErrorScreen(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(child: Text('The requested page does not exist.')),
    );
  }
}
