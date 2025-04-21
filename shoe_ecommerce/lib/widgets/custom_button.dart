import 'package:shoe_ecommerce/export.dart';


class CustomButton extends StatelessWidget {
  String text;
  void Function() onPressed;
   CustomButton({
    required this.text,
    required this.onPressed,
    super.key});

  @override
  Widget build(BuildContext context) {
    return     ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 16.sp, color:AppTheme.whiteColor),
                  ),
                )
            ;
  }
}