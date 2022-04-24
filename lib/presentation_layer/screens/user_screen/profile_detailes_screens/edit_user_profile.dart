import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/data_layer/bloc/login_cubit/login_cubit.dart';
import 'package:club_cast/data_layer/bloc/login_cubit/login_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/user_model.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data_layer/bloc/intial_cubit/general_app_cubit.dart';

TextEditingController? userNameController = TextEditingController();
TextEditingController? emailController = TextEditingController();
TextEditingController? bioController = TextEditingController();
TextEditingController? emptyController = TextEditingController();

class EditUserProfileScreen extends StatelessWidget {
  EditUserProfileScreen({Key? key}) : super(key: key);

  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  bool isPassword1 = true;
  IconData suffix1 = Icons.visibility_outlined;
  bool isPassword2 = true;
  IconData suffix2 = Icons.visibility_outlined;
  bool isUpdatePhoto = false;

  // var token = CachHelper.getData(key: 'token');
  @override
  Widget build(BuildContext context) {
    userNameController?.text = GetUserModel.getUserName();
    emailController?.text = GetUserModel.getUserEmail();
    bioController?.text = GetUserModel.getUserBio()!;
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        String token = CachHelper.getData(key: 'token');
        var cubit = GeneralAppCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            cubit.profileAvatar = null;
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                onPressed: () {
                  cubit.profileAvatar = null;
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              title: Text(
                'Edit Your Profile Details',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: cubit.profileAvatar != null
                                ? Image.file(
                                    cubit.profileAvatar!,
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    image: NetworkImage(
                                        '${GetUserModel.getUserPhoto()}'),
                                    height: 180,
                                    width: 180,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {
                              cubit.pickImage();
                              isUpdatePhoto = true;
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: 35,
                              ),
                              child: Container(
                                width: 37,
                                height: 37,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius:
                                      BorderRadiusDirectional.circular(200),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                      defaultTextFormField(
                        context: context,
                        controller: userNameController,
                        labelText: 'User Name',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'name must not be empty ';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                        context: context,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "Email",
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        onChanged: (value) {},
                        onSubmit: (value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email Address must not be empty ';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                      defaultTextFormField(
                        context: context,
                        controller: bioController,
                        labelText: 'Bio',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 322.0,
                        height: 45.0,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80),
                              ),
                              isScrollControlled: true,
                              builder: (context) => modalSheet(context),
                            );
                          },
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      cubit.isUploadPhoto
                          ? CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            )
                          : cubit.isUpdateUserData
                              ? CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                )
                              : Container(
                                  width: 322.0,
                                  height: 45.0,
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    onPressed: () {
                                      isUpdatePhoto
                                          ? cubit.setAvatar(context)
                                          : formKey.currentState!.validate()
                                              ? GeneralAppCubit.get(context)
                                                  .updateUserData(
                                                  name1:
                                                      userNameController!.text,
                                                  email1: emailController!.text,
                                                  bio1: bioController!.text,
                                                  token: token,
                                                )
                                              : null;
                                      isUpdatePhoto = false;
                                    },
                                    child: const Text(
                                      'Confirm',
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
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget modalSheet(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        String token = CachHelper.getData(key: 'token');
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Change Password',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: 28.0,
                  ),
                  Container(
                    width: 322.0,
                    child: defaultTextFormField(
                        context: context,
                        controller: currentPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "Current Password",
                        obscureText: isPassword,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          onPressed: () {
                            setState(() => changePasswordVisibility());
                          },
                          icon: Icon(suffix),
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        radius: 10,
                        onChanged: (value) {},
                        onSubmit: (value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password must not be empty ';
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    width: 322.0,
                    child: defaultTextFormField(
                        context: context,
                        controller: newPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "New Password",
                        obscureText: isPassword1,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          onPressed: () {
                            setState(() => changePasswordVisibility1());
                          },
                          icon: Icon(suffix1),
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        radius: 10,
                        onChanged: (value) {},
                        onSubmit: (value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password must not be empty ';
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    width: 322.0,
                    child: defaultTextFormField(
                        context: context,
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isPassword2,
                        labelText: "Confirm Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        suffixIcon: IconButton(
                          // padding: const EdgeInsets.symmetric(horizontal: 15),
                          onPressed: () {
                            setState(() => changePasswordVisibility2());
                          },
                          icon: Icon(suffix2),
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        radius: 10,
                        onChanged: (value) {},
                        onSubmit: (value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password must not be empty ';
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  Container(
                    width: 322.0,
                    height: 45.0,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      onPressed: () {
                        GeneralAppCubit.get(context)
                            .updatePassword(
                          password_Current: currentPasswordController.text,
                          password_New: newPasswordController.text,
                          password_Confirm: confirmPasswordController.text,
                          token: token,
                        )
                            .then((value) {
                          Navigator.of(context).pop();
                          currentPasswordController.clear();
                          newPasswordController.clear();
                          confirmPasswordController.clear();
                        });
                      },
                      child: const Text(
                        'Change',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
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

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  }

  void changePasswordVisibility1() {
    isPassword1 = !isPassword1;
    suffix1 =
        isPassword1 ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  }

  void changePasswordVisibility2() {
    isPassword2 = !isPassword2;
    suffix2 =
        isPassword2 ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  }
}
