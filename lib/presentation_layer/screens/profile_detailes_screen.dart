import '../../data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/get_userId_model.dart';
import 'package:club_cast/presentation_layer/models/podCastLikesUserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

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
              'Profile Details',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: cubit.isLoading
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
                      Center(
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage('${cubit.userId!.data!.photo}'),
                          radius: 75.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${cubit.userId!.data!.name}',
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
                          statusNumberProfile(
                            number: '${cubit.userId!.data!.followers}',
                            statusType: 'Followers',
                          ),
                          // cubit.userId!.data!.followers
                          const SizedBox(
                            width: 22.0,
                          ),
                          statusNumberProfile(
                            number: '${cubit.userId!.data!.following}',
                            statusType: 'Following',
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
                          onPressed: () {},
                          child: const Text(
                            'Follow',
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
