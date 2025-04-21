import 'package:provider/provider.dart';
import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/provider/auth_provider.dart';
import 'package:shoe_ecommerce/utils/constants/textStyle.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (error == null) {
     context.push(RouteNames.home,  extra: 0,);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }
void clearFields() {
  _nameController.clear();
  _emailController.clear();
  _passwordController.clear();
}
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return CustomScaffold(
      leadingIcon: Icons.arrow_back_ios,
      onLeadingTap: () => context.pop(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 50.sp),
            Text("Create Account", style: AppTextStyle.signInHeading),
            SizedBox(height: 20.sp),
            Text("Let's Create Account Together", style: AppTextStyle.signInDescription),
            SizedBox(height: 30.sp),

            CustomTextField(
              title: "Your Name",
              hintText: "Enter Name",
              controller: _nameController,
              validator: (value) =>
                  value == null || value.isEmpty ? "Name is required" : null,
            ),
            SizedBox(height: 30.sp),

            CustomTextField(
              title: "Email Address",
              hintText: "Enter Email",
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) return "Email is required";
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            SizedBox(height: 30.sp),

            CustomTextField(
              title: "Password",
              hintText: "Enter Password",
              isPassword: true,
              controller: _passwordController,
              validator: (value) =>
                  value == null || value.length < 6 ? "Minimum 6 characters" : null,
            ),
            SizedBox(height: 30.sp),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomButton(
                text: authProvider.isLoading ? "Signing Up..." : "Sign Up",
                onPressed: () {
                  authProvider.isLoading ? null : handleRegister();
                },
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already Have An Account?", style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  onTap: () => context.push(RouteNames.signIn),
                  child: const Text(" Sign In", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
