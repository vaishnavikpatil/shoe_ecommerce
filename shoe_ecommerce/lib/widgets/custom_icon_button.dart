import 'package:shoe_ecommerce/export.dart';

class CustomIconButton extends StatelessWidget {
  void Function()? onTap;
  IconData icon;
  CustomIconButton({required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 4.sp),
         height: 40.sp, 
        width: 40.sp,
        alignment: Alignment.center,
        
        decoration:
            const BoxDecoration(color: AppTheme.whiteColor, shape: BoxShape.circle),
        child: Icon(
          icon,
          color: AppTheme.textcolor,
          size: 15.sp,
        ),
      ),
    );
  }
}
