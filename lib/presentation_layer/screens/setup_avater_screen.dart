import 'package:club_cast/data_layer/bloc/login_cubit/login_cubit.dart';
import 'package:club_cast/data_layer/bloc/login_cubit/login_states.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
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
                            : UserLoginModel.getUserPhoto() != null
                                ? Image(
                                    image: NetworkImage(
                                        UserLoginModel.getUserPhoto()
                                            .toString()),
                                    height: 180,
                                    width: 180,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                      GestureDetector(
                        onTap: () {
                          cubit.pickImage();
                        },
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 10,
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadiusDirectional.circular(200),
                            ),
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
                        cubit.setAvatar(context);
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
