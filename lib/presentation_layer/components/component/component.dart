import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
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
  int maxLine = 1,
  TextDirection textDirection = TextDirection.ltr,
  required BuildContext context,
}) {
  return TextFormField(
    cursorColor: Theme.of(context).primaryColor,
    maxLines: maxLine,
    textDirection: textDirection,
    style: Theme.of(context).textTheme.bodyText1,
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
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Theme.of(context).primaryColor,
    ),
    child: MaterialButton(
      onPressed: onPressed,
      child: Text(
        isUpperCase ? text.toString().toUpperCase() : '$text',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Theme.of(context).textTheme.bodyText1?.color,
            fontSize: 18,
            fontWeight: FontWeight.w100),
      ),
    ),
  );
}

void navigatePushTo({
  required BuildContext context,
  required Widget navigateTo,
}) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => navigateTo));
}

void navigatePushANDRemoveRout({
  required BuildContext context,
  required Widget navigateTo,
}) {
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
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

Widget userProfileImage({
  required double size,
  required String image,
}) =>
    CircleAvatar(
      backgroundImage: NetworkImage(image),
      radius: size,
    );

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

Widget statusNumberProfile({
  required String number,
  required String statusType,
}) =>
    Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15.0,
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        Text(
          statusType,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ],
    );

void logOut({
  required BuildContext context,
}) {
  CachHelper.deleteData("token").then((value) {
    var cubit = GeneralAppCubit.get(context);
    print(value);
    token = null;
    cubit.search?.clear();
    cubit.activePodCastId = null;
    cubit.currentOlayingDurathion = null;
    cubit.currentPostionDurationInsec = 0;
    cubit.isPlaying ? cubit.assetsAudioPlayer.stop() : const SizedBox();
    if (token == null) {
      navigatePushANDRemoveRout(context: context, navigateTo: LoginScreen());
    }
  });
}
