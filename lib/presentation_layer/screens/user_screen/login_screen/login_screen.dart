import 'package:club_cast/data_layer/bloc/login_cubit/login_cubit.dart';
import 'package:club_cast/data_layer/bloc/login_cubit/login_states.dart';
import 'package:club_cast/data_layer/cash/cash.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/models/login_model.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/forget_password_screen/forget_password_screen.dart';
import 'package:club_cast/presentation_layer/screens/user_screen/register_screen/sign_up_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (BuildContext context, state) {
        if (state is UserLoginSuccessState) {
          CachHelper.setData(key: 'token', value: UserLoginModel.token);
        }
      },
      builder: (BuildContext context, Object? state) {
        var cubit = LoginCubit.get(context);

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.33,
                        child: const Image(
                          image: AssetImage('assets/images/handy-browser.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        'ClubCast',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 55,
                            ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035,
                      ),
                      defaultTextFormField(
                        context: context,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: "Email",
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email Address must not be empty ';
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      defaultTextFormField(
                          context: context,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          labelText: "password",
                          suffixIcon: IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            onPressed: () {
                              cubit.loginVisibleEyeOrNot();
                            },
                            icon: cubit.suffix,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          obscureText: cubit.loginObSecure,
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          radius: 10,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context);
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password must not be empty ';
                            }
                          }),
                      Align(
                        alignment: Alignment.topRight,
                        child: defaultTextButton(
                          onPressed: () {
                            navigatePushANDRemoveRout(
                              context: context,
                              navigateTo: ForgetPasswordScreen(),
                            );
                          },
                          child: Text(
                            'Forget Password?',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      ConditionalBuilder(
                        condition: state is! UserLoginLoadingState,
                        builder: (context) => defaultButton(
                          context: context,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context,
                              );
                            }
                          },
                          text: 'Login',
                        ),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ? ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          defaultTextButton(
                            onPressed: () {
                              navigatePushANDRemoveRout(
                                  context: context,
                                  navigateTo: RegisterScreen());
                            },
                            child: Text(
                              'SignUp',
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
          ),
        );
      },
    );
  }
}
