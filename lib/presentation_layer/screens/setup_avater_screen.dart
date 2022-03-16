import 'dart:io';

import 'package:club_cast/data_layer/bloc/login_cubit/login_cubit.dart';
import 'package:club_cast/data_layer/bloc/login_cubit/login_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/data_layer/dio/dio_setup.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../components/component/component.dart';

class SetUpAvatarScreen extends StatelessWidget {
  SetUpAvatarScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = LoginCubit.get(context);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: cubit.profileAvatar != null
                            ? Image.file(
                                cubit.profileAvatar!,
                                height: 180,
                                width: 180,
                                fit: BoxFit.cover,
                              )
                            : Image(
                                image: AssetImage('assets/images/default.jpg'),
                                height: 180,
                                width: 180,
                                fit: BoxFit.cover,
                              ),
                      ),
                      InkWell(
                        onTap: () {
                          cubit.pickImage();
                        },
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: 15,
                            bottom: 5,
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  ConditionalBuilder(
                    condition: state is! UserSetAvatarLoadingState,
                    builder: (context) => defaultButton(
                      context: context,
                      onPressed: () {
                        // DioHelper.uploadImage(
                        //   url: updateProfile,
                        //   image: cubit.profileAvatar,
                        //   token: CachHelper.getData(key: 'token'),
                        // );
                        cubit.setAvatar();
                      },
                      text: 'Let\'s go',
                    ),
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
