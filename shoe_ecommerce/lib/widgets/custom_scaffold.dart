import 'package:shoe_ecommerce/export.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final String? apptitle;
  final Widget? centerWidget;
  final bool centerTitle;
  final VoidCallback? onLeadingTap;
  final VoidCallback? onTrailingTap;
  final bool showDrawer;

  const CustomScaffold({
    super.key,
    required this.body,
    this.leadingIcon,
    this.trailingIcon,
    this.apptitle,
    this.centerWidget,
    this.centerTitle = false,
    this.onLeadingTap,
    this.onTrailingTap,
    this.showDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: showDrawer ? const CustomDrawer() : null,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.sp),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
          child: CustomAppbar(
            leading: leadingIcon != null
                ? CustomIconButton(
                    icon: leadingIcon!,
                    onTap: showDrawer
                        ? () => scaffoldKey.currentState?.openDrawer()
                        : (onLeadingTap ?? () {}),
                  )
                : null,
            trailing: trailingIcon != null
                ? CustomIconButton(icon: trailingIcon!, onTap: onTrailingTap ?? () {})
                : null,
            apptitle: apptitle,
            centerWidget: centerTitle ? centerWidget : null,
            centerTitle: centerTitle,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: body,
      ),
    );
  }
}
