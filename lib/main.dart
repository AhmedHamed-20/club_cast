import 'package:bloc/bloc.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/components/theme/app_theme.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/edit_user_profile.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_layer/bloc/bloc_observer/bloc_observer.dart';
import 'data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'data_layer/bloc/login_cubit/login_cubit.dart';
import 'data_layer/bloc/room_cubit/room_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CachHelper.init();
  Bloc.observer = MyBlocObserver();
  bool? isDark;
  token = CachHelper.getData(key: 'token');
  //print('mainValue:${isDark}');
  if (await CachHelper.getData(key: 'isDark') == null) {
    isDark = false;
  } else {
    isDark = CachHelper.getData(key: 'isDark');
  }
  Widget startApp;
  print(token);

  if (await CachHelper.getData(key: 'token') != null) {
    startApp = LayoutScreen();
  } else {
    token = '';
    startApp = LoginScreen();
  }
  runApp(MyApp(startApp, isDark));
}

class MyApp extends StatelessWidget {
  final Widget startApp;
  bool? isDark;
  MyApp(this.startApp, this.isDark);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RoomCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => GeneralAppCubit()
            ..getMyFollowingPodcast(token)
            ..getUserData(token: token)
            ..getAllCategory()
            ..getDark(isDark!)
            ..getMyEvents()
            ..getMyFollowingEvents(),
        ),
      ],
      child: BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        builder: (context, state) {
          var cubit = GeneralAppCubit.get(context);
          //  cubit.isDark = isDark;
          //isDark == null ? isDark = false : SizedBox();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PodLand',
            theme: cubit.isDark! ? darkMode : lightMode,
            home: startApp,
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
