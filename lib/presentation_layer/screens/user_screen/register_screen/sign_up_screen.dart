import 'package:club_cast/data_layer/bloc/login_cubit/login_cubit.dart';
import 'package:club_cast/data_layer/bloc/login_cubit/login_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/login_screen/login_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is UserSignUpSuccessState) {
            CachHelper.setData(key: 'token', value: UserLoginModel.token)
                .then((value) {})
                .catchError((error) {});
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Image(
                          image: AssetImage('assets/images/signPhoto.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      defaultTextFormField(
                        context: context,
                        controller: nameController,
                        labelText: 'Your Name',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'name must not be empty ';
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      defaultTextFormField(
                        context: context,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Email',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email must not be empty ';
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      defaultTextFormField(
                          context: context,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          labelText: "password",
                          suffixIcon: IconButton(
                            color: Theme.of(context).iconTheme.color,
                            onPressed: () {
                              cubit.signUpVisibleEyeOrNot();
                            },
                            icon: cubit.signUpSuffix,
                          ),
                          obscureText: cubit.signUpObSecure,
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          onChanged: (value) {},
                          onSubmit: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password must not be empty ';
                            }
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      defaultTextFormField(
                          context: context,
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          labelText: "Confirm Password",
                          obscureText: cubit.signUpObSecure,
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          onChanged: (value) {},
                          onSubmit: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password must not be empty ';
                            }
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      ConditionalBuilder(
                        condition: state is! UserSignUpLoadingState,
                        builder: (context) => defaultButton(
                          context: context,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.userSignUp(
                                context: context,
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                passwordConfirm: confirmPasswordController.text,
                              );
                            }
                          },
                          text: 'SignUp',
                        ),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account ? ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          defaultTextButton(
                            onPressed: () {
                              navigatePushANDRemoveRout(
                                  context: context, navigateTo: LoginScreen());
                            },
                            child: Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
