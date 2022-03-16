import 'package:bloc/bloc.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/components/theme/app_theme.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
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
  token = CachHelper.getData(key: 'token');
  isDark = CachHelper.getData(key: 'isDark');
  Widget startApp;
  print(token);
  // print(UserLoginModel.getUserPhoto());
  if (token != null) {
    startApp = LayoutScreen();
  } else {
    startApp = LoginScreen();
  }
  runApp(MyApp(startApp));
}

class MyApp extends StatelessWidget {
  final Widget startApp;

  MyApp(this.startApp);
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
            ..getAllPodcast(token: token)
            ..getUserData(token: token)
            ..getAllCategory(),
        )
      ],
      child: BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var cubit = GeneralAppCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PodLand',
            theme: isDark ? darkMode : lightMode,
            themeMode: ThemeMode.system,
            home: startApp,
          );
        },
      ),
    );
  }
}
