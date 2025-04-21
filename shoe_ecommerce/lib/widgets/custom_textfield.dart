import 'package:shoe_ecommerce/export.dart';
import 'package:shoe_ecommerce/utils/constants/textStyle.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool isPassword;
  final String? title;
  final String hintText;
  final IconData? leadingIcon;
  final bool autofocus;
  final bool? enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted; 

  const CustomTextField({
    super.key,
    this.controller,
    this.isPassword = false,
    this.title,
    required this.hintText,
    this.leadingIcon,
    this.enabled,
    this.autofocus = false,
    this.validator,
    this.onSubmitted, 
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(widget.title!, style: AppTextStyle.textFieldTitle),
          SizedBox(height: 15.sp),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          validator: widget.validator,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          textInputAction: TextInputAction.done, 
          onFieldSubmitted: widget.onSubmitted, 
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF707B81),
              fontFamily: "AirbnbCereal",
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none,
            ),
            prefixIcon: widget.leadingIcon != null ? Icon(widget.leadingIcon) : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
