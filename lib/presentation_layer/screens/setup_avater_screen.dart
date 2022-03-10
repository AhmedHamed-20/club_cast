import 'package:club_cast/data_layer/bloc/login_cubit/login_cubit.dart';
import 'package:club_cast/data_layer/bloc/login_cubit/login_states.dart';
import 'package:club_cast/presentation_layer/layout/layout_screen.dart';
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
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                navigatePushANDRemoveRout(
                    context: context, navigateTo: LayoutScreen());
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/signPhoto.png'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                defaultButton(
                  context: context,
                  onPressed: () {},
                  text: 'Let\'s go',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
