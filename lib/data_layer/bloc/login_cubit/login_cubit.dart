import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialLoginStates());
  static LoginCubit get(context) => BlocProvider.of(context);
  ////////////variable//////////////

  bool obSecure = true;
  Widget suffix = const Icon(
    Icons.visibility_off,
  );

  ////////////Methods///////////////

  void visibleEyeOrNot() {
    obSecure = !obSecure;
    suffix = obSecure
        ? const Icon(
            Icons.visibility_off,
          )
        : const Icon(
            Icons.visibility,
          );
    emit(ChangeEyeSecureState());
  }
}
