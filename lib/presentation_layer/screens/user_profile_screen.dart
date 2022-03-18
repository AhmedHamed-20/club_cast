import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/edit_user_profile.dart';
import 'package:club_cast/presentation_layer/screens/followers_screen.dart';
import 'package:club_cast/presentation_layer/screens/following_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, index) {},
      builder: (context, index) {
        var cubit = GeneralAppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            title: Text(
              'Your Profile Details',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: cubit.isLoadProfile
              ? Center(
                  child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Stack(
                        children:
                        [
                          Center(
                            child: CircleAvatar(
                              backgroundImage:
                              NetworkImage('${GetUserModel.getUserPhoto()}'),
                              radius: 75.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${GetUserModel.getUserName()}',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 22.0,
                            ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          statusNumberProfile(
                            number: '0',
                            statusType: 'Podcasts',
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigatePushTo(
                                context: context,
                                navigateTo: FollowersScreen(),
                              );
                            },
                            child: statusNumberProfile(
                              number: '${GetUserModel.getUserFollowers()}',
                              statusType: 'Followers',
                            ),
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigatePushTo(
                                context: context,
                                navigateTo: FollowingScreen(),
                              );
                            },
                            child: statusNumberProfile(
                              number: '${GetUserModel.getUserFollowing()}',
                              statusType: 'Following',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 17.0,
                      ),
                      Container(
                        width: 280.0,
                        height: 45.0,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () {
                            navigatePushTo(
                                context: context,
                                navigateTo: EditUserProfileScreen());
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Podcasts',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22.0,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
