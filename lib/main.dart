import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/widgets/components/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'data_layer/bloc/login_cubit/login_cubit.dart';
import 'data_layer/bloc/login_cubit/login_states.dart';
import 'data_layer/bloc/room_cubit/room_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          create: (context) => GeneralAppCubit(),
        ),
      ],
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PodLand',
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: ThemeMode.light,
            home: LayoutScreen(),
          );
        },
      ),
    );
  }
}
