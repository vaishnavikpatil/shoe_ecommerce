
import 'package:provider/provider.dart';
import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/provider/auth_provider.dart';
import 'package:shoe_ecommerce/utils/constants/textStyle.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProvider.login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (error == null) {
     context.push(RouteNames.home,  extra: 0,);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }
void clearFields() {
  emailController.clear();
  passwordController.clear();
}
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return CustomScaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 100.sp),
            Text("Hello Again!", style: AppTextStyle.signInHeading),
            SizedBox(height: 20.sp),
            Text("Welcome Back You've Been Missed!", style: AppTextStyle.signInDescription),
            SizedBox(height: 30.sp),
            CustomTextField(
              controller: emailController,
              title: "Email Address",
              hintText: "Enter Email",
              validator: (val) {
                if (val == null || val.isEmpty) return 'Email is required';
                if (!val.contains('@')) return 'Invalid email';
                return null;
              },
            ),
            SizedBox(height: 30.sp),
            CustomTextField(
              controller: passwordController,
              title: "Password",
              hintText: "Enter Password",
              isPassword: true,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Password is required';
                if (val.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            GestureDetector(
              onTap: () {
                context.push(RouteNames.forgotPassword);
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: Text("Forgot Password", style: TextStyle(fontFamily: "AirbnbCereal", color: AppTheme.textcolor)),
              ),
            ),
            SizedBox(height: 30.sp),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomButton(
                text: authProvider.isLoading ? "Signing In..." : "Sign In",
                onPressed: (){authProvider.isLoading ? null : handleLogin();},
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't Have An Account?", style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  onTap: () {
                    context.push(RouteNames.signUp);
                  },
                  child: const Text("Sign Up For Free", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
