import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/models/followers_following_model.dart';
import 'package:club_cast/presentation_layer/screens/profile_detailes_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data_layer/cash/cash.dart';
import '../components/component/component.dart';
import '../models/user_model.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        builder: (context, state) {
          var cubit = GeneralAppCubit.get(context);
          var token = CachHelper.getData(key: 'token');
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Following',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              backgroundColor: Colors.transparent,
              leading: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              elevation: 0,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: cubit.followingLoad
                ? Center(
                    child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: Following.followingModel!['data'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                cubit.getUserPodcast(
                                    token, Followers.getUserID(index));
                                cubit.getUserById(
                                    profileId: Following.getUserID(index));
                                if (Following.getUserID(index) ==
                                    GetUserModel.getUserID()) {
                                  navigatePushTo(
                                      context: context,
                                      navigateTo: UserProfileScreen());
                                } else {
                                  navigatePushTo(
                                      context: context,
                                      navigateTo: ProfileDetailsScreen(
                                          Following.getUserID(index)));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        '${Following.getUserPhoto(index)}'),
                                    radius: 30.0,
                                  ),
                                  title: Text(
                                    '${Following.getUserName(index)}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  trailing: MaterialButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {},
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Unfollow',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
          );
        },
        listener: (context, state) {});
  }
}
