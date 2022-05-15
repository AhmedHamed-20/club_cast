import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/components/theme/app_theme.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/screens/splash_onboarding/onboarding_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data_layer/bloc/bloc_observer/bloc_observer.dart';
import 'data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'data_layer/bloc/login_cubit/login_cubit.dart';
import 'data_layer/bloc/room_cubit/room_cubit.dart';
import 'data_layer/notification/local_notification.dart';
import 'presentation_layer/screens/splash_onboarding/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();

  DioHelper.init();
  await CachHelper.init();
  Bloc.observer = MyBlocObserver();
  bool? isDark;
  token = CachHelper.getData(key: 'token');
  if (await CachHelper.getData(key: 'isDark') == null) {
    isDark = false;
  } else {
    isDark = CachHelper.getData(key: 'isDark');
  }
  Widget startApp;

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
            ..getAllRoomsData(context)
            ..getMyFollowingPodcast(token, context)
            ..getUserData(token: token)
            ..getAllCategory()
            ..getDark(isDark!)
            ..getMyEvents()
            ..getMyFollowingEvents(context),
        ),
      ],
      child: BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        builder: (context, state) {
          var cubit = GeneralAppCubit.get(context);
          //  cubit.isDark = isDark;
          //isDark == null ? isDark = false : SizedBox();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'club cast',
            theme: cubit.isDark! ? darkMode : lightMode,
            home: SplashScreen(),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
