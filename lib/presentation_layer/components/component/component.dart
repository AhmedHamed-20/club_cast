import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  required BuildContext context,
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
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
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
      color: Theme.of(context).primaryColor,
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

void showToast({
  required String message,
  required ToastState toastState,
}) {
  Fluttertoast.showToast(
    msg: message,
    fontSize: 16,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 5,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: toastColor(toastState),
    textColor: Colors.white,
  );
}

enum ToastState { SUCCESS, WARNING, ERROR }

Color toastColor(ToastState state) {
  Color? color;

  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
    case ToastState.ERROR:
      color = Colors.deepOrange;
  }
  return color;
}

void logOut({
  required BuildContext context,
}) {
  CachHelper.deleteData("token").then((value) {
    print(value);
    token = null;
    if (token == null) {
      navigatePushANDRemoveRout(context: context, navigateTo: LoginScreen());
    }
  });
}
