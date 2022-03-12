import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/presentation_layer/widgets/modelsheetcreate_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import '../components/component/component.dart';
import '../screens/setup_avater_screen.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var cubit = GeneralAppCubit.get(context);
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Rooms',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 25),
              ),
              actions: [
                IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    logOut(context: context);
                  },
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    navigatePushANDRemoveRout(
                        context: context, navigateTo: SetUpAvatarScreen());
                  },
                  child: const CircleAvatar(
                    radius: 23,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    cubit.toggleDark();
                  },
                  icon: Icon(
                    Icons.dark_mode,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavBarItem,
              backgroundColor: Theme.of(context).backgroundColor,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).iconTheme.color,
              currentIndex: cubit.bottomNavIndex,
              onTap: (index) {
                cubit.changeBottomNAvIndex(index);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                modalBottomSheetItem(context);
              },
              elevation: 15,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            body: cubit.screen[cubit.bottomNavIndex],
          );
        });
  }
}
