import 'package:flutter/material.dart';

Widget defaultTextFormField({
  TextEditingController? controller,
  TextInputType? keyboardType,
  String? labelText,
  double radius = 10,
  TextStyle? labelStyle,
  Widget? suffixIcon,
  Widget? prefixIcon,
  ValueChanged<String>? onChanged,
  FormFieldValidator<String>? validator,
  ValueChanged<String>? onSubmit,
  bool obscureText = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      contentPadding: const EdgeInsetsDirectional.all(20),
      labelText: labelText,
      labelStyle: labelStyle,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: Colors.blue,
        ),
      ),
    ),
    obscureText: obscureText,
    onChanged: onChanged,
    validator: validator,
    onFieldSubmitted: onSubmit,
  );
}

Widget defaultTextButton({
  required VoidCallback onPressed,
  required Widget child,
}) {
  return TextButton(
    onPressed: onPressed,
    child: child,
  );
}

Widget defaultButton({
  required VoidCallback onPressed,
  String? text,
  bool isUpperCase = false,
  double height = 50,
  double width = double.infinity,
  double radius = 10,
  required BuildContext context,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: const Color(0xff5ADAAC),
    ),
    child: MaterialButton(
      onPressed: onPressed,
      child: Text(
        isUpperCase ? text.toString().toUpperCase() : '$text',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

void navigatePushTo({
  required BuildContext context,
  required Widget navigateTo,
}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => navigateTo));
}

void navigatePushANDRemoveRout({
  required BuildContext context,
  required Widget navigateTo,
}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => navigateTo,
      ),
      (route) => false);
}
