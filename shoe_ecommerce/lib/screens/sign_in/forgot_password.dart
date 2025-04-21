import 'package:provider/provider.dart';
import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/provider/auth_provider.dart';
import 'package:shoe_ecommerce/utils/constants/textStyle.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();

  void handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProvider.forgotPassword(
      _emailController.text.trim(),
      _newPasswordController.text,
    );

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successful")),
      );
      context.go(RouteNames.signIn);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
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
            Text("Recovery Password", style: AppTextStyle.signInHeading),
            SizedBox(height: 20.sp),
            Text(
              "Please Enter Your Email Address To\nReset Your Password",
              style: AppTextStyle.signInDescription,
              textAlign: TextAlign.center,
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
              title: "New Password",
              hintText: "Enter New Password",
              controller: _newPasswordController,
              isPassword: true,
              validator: (value) =>
                  value == null || value.length < 6 ? "Minimum 6 characters" : null,
            ),
            SizedBox(height: 30.sp),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomButton(
                text: authProvider.isLoading ? "Processing..." : "Continue",
                onPressed: () {
                  authProvider.isLoading ? null : handleForgotPassword();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
