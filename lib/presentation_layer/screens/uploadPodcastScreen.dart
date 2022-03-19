import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/modelsheetcreate_room.dart';

class UploadPodCastScreen extends StatelessWidget {
  const UploadPodCastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        builder: (context, state) {
          var cubit = GeneralAppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Upload Your Podcast',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    defaultTextFormField(
                      context: context,
                      controller: nameController,
                      labelText: 'PodcastName',
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      radius: 15,
                      prefixIcon: Icon(
                        Icons.text_snippet,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PodCast Category',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        buildCategoryDropDownButton(context: context),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    defaultButton(
                        onPressed: () {
                          cubit.pickPocCastFile();
                        },
                        context: context,
                        text: 'PickFile'),
                    const SizedBox(
                      height: 25,
                    ),
                    cubit.podcastFile == null
                        ? SizedBox()
                        : ListTile(
                            title: Text(
                              cubit.podcastFile!.path.split('/').last,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                cubit.previewIsplaying
                                    ? cubit.pausePreview()
                                    : cubit.playPreviewPodcast();
                              },
                              icon: Icon(
                                cubit.previewIsplaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    cubit.podcastFile == null
                        ? const SizedBox()
                        : defaultButton(
                            onPressed: () {}, context: context, text: 'Upload')
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
