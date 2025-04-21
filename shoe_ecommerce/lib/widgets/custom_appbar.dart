import 'package:shoe_ecommerce/export.dart';

class CustomAppbar extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String? apptitle;
  final Widget? centerWidget;
  final bool centerTitle;

  const CustomAppbar({
    this.leading,
    this.trailing,
    this.apptitle,
    this.centerWidget,
    this.centerTitle = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if ( leading != null) leading!,
          if (centerTitle && centerWidget != null)
            Expanded(child: Center(child: centerWidget!))
          else if (apptitle != null)
            Expanded(
              child: Text(
                apptitle!,
                textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textcolor,
                  fontFamily: "AirbnbCereal"
                ),
              ),
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
