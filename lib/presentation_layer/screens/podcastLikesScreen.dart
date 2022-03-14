import 'package:club_cast/components/components.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/models/podCastLikesUserModel.dart';
import 'package:club_cast/presentation_layer/screens/profile_detailes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PodCastLikesScreen extends StatelessWidget {
  const PodCastLikesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Likes',
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: GetPodCastUsersLikesModel
                        .getAllPodCastLikes!['data'].length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: ()
                        {
                          navigateTo(context, ProfileDetailsScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  GetPodCastUsersLikesModel.getPhotoUrltName(
                                      index)),
                            ),
                            title: Text(
                              GetPodCastUsersLikesModel.getUserName(index),
                              style: Theme.of(context).textTheme.bodyText1,
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
