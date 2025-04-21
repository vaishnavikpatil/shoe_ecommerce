import 'package:provider/provider.dart';
import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/provider/auth_provider.dart';
import 'package:shoe_ecommerce/provider/network_provider.dart';
import 'package:shoe_ecommerce/screens/network_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final router = await AppRouter.getRouter();

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NetworkManager()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, child) {
          return Consumer<NetworkManager>(
            builder: (context, network, _) {
              final isOnline = network.isOnline;

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Shoe Ecommerce',
                theme: AppTheme.lightTheme,
                routerConfig: isOnline
                    ? router
                    : GoRouter(
                        routes: [
                          GoRoute(
                            path: '/',
                            builder: (_, __) => const NoNetworkScreen(),
                          )
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
