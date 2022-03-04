import 'package:audio_wave/audio_wave.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivePodCastScreen extends StatelessWidget {
  const ActivePodCastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Graduation Project',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'AhmedHamed',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  AudioWave(
                    height: 32,
                    width: 88,
                    spacing: 2.5,
                    alignment: 'top',
                    animationLoop: 2,
                    bars: [
                      AudioWaveBar(
                        height: 77,
                        color: Theme.of(context).primaryColor,
                      ),
                      AudioWaveBar(
                        height: 77,
                        color: Theme.of(context).primaryColor,
                      ),
                      AudioWaveBar(
                        height: 77,
                        color: Theme.of(context).primaryColor,
                      ),
                      AudioWaveBar(
                        height: 77,
                        color: Theme.of(context).primaryColor,
                      ),
                      AudioWaveBar(
                        height: 33,
                        color: Theme.of(context).primaryColor,
                      ),
                      AudioWaveBar(
                        height: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                      AudioWaveBar(
                        height: 60,
                        color: Theme.of(context).primaryColor,
                      ),
                      AudioWaveBar(height: 55, color: Colors.grey[300]!),
                      AudioWaveBar(height: 33, color: Colors.grey[300]!),
                    ],
                  ),
                  Text(
                    '55:33:10',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Card(
                      elevation: 10,
                      color: Theme.of(context).backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12,
                          top: 40,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Graduation Project',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.skip_previous,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                                Card(
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.skip_next,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
