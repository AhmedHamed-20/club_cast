import 'package:club_cast/data_layer/bloc/login_cubit/login_cubit.dart';
import 'package:club_cast/data_layer/bloc/login_cubit/login_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login_screen/login_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

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
                navigatePushANDRemoveRout(
                    context: context, navigateTo: LoginScreen());
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: const Image(
                        image:
                            AssetImage('assets/images/handy-downloading.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    ConditionalBuilder(
                      condition: state is! UserForgetPasswordLoadingState,
                      builder: (context) => defaultButton(
                        context: context,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit.forgetPassword(email: emailController.text);
                          }
                        },
                        text: 'Forget',
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
          ),
        );
      },
    );
  }
}
