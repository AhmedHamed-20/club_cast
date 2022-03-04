import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cybit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/login_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/login_states.dart';
import 'package:club_cast/presentation_layer/screens/active_podcast_screen.dart';
import 'package:club_cast/presentation_layer/screens/followers_screen.dart';
import 'package:club_cast/presentation_layer/screens/following_screen.dart';
import 'package:club_cast/presentation_layer/screens/room_user_view_admin.dart';
import 'package:club_cast/presentation_layer/screens/room_user_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data_layer/bloc/room_cubit/room_cubit.dart';
import 'presentation_layer/screens/edit_user_profile.dart';
import 'presentation_layer/screens/login_screen.dart';
import 'presentation_layer/screens/profile_detailes_screen.dart';
import 'presentation_layer/screens/user_profile_screen.dart';

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
          create: (context) => GeneralAppcubit(),
        ),
      ],
      child: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Podland',
            theme: ThemeData(
              appBarTheme: AppBarTheme(color:Theme.of(context).scaffoldBackgroundColor),
              backgroundColor: Colors.white,
              textTheme: TextTheme(
                bodyText1: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Color(0xff59675B),
                ),
                bodyText2: GoogleFonts.rubik(
                  color: Color(0xff59675B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              iconTheme: IconThemeData(
                color: Color(0xff59675B),
              ),
              scaffoldBackgroundColor: Color(0xffF6F9F4),
              primaryColor: Color(0xff5ADAAC),
              primarySwatch: Colors.green,
              //  backgroundColor: Color(0xffF6F9F4),
            ),
            darkTheme: ThemeData(
              backgroundColor: Colors.grey[800],
              textTheme: TextTheme(
                bodyText1: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 18,
                ),
                bodyText2: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              scaffoldBackgroundColor: Color(0x2BE5E5E5),
              primaryColor: Color(
                0xff6A4CFF,
              ),
            ),
            themeMode: ThemeMode.light,
            home: const UserProfileScreen(),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
