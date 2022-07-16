import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit_states.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:club_cast/presentation_layer/components/constant/constant.dart';
import 'package:club_cast/presentation_layer/models/downloaded_podcasts_moder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../widgets/modelsheetcreate_room.dart';

class UploadPodCastScreen extends StatelessWidget {
  const UploadPodCastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    var cubit = GeneralAppCubit?.get(context);

    return BlocConsumer<GeneralAppCubit, GeneralAppStates>(
        builder: (context, state) {
          var cubit = GeneralAppCubit.get(context);
          //   print(cubit.podcastFile!.path);
          return WillPopScope(
            onWillPop: () async {
              cubit.previewIsplaying
                  ? cubit.assetsAudioPlayer.stop()
                  : const SizedBox();
              cubit.podcastFile = null;
              nameController.clear();
              cubit.cancelToken.isCancelled
                  ? cubit.cancelToken.cancel()
                  : const SizedBox();
              cubit.selectedCategoryItem = 'ai';
              Navigator.of(context).pop();
              return false;
            },
            child: Scaffold(
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
                    cubit.previewIsplaying
                        ? cubit.assetsAudioPlayer.stop()
                        : const SizedBox();
                    cubit.podcastFile = null;
                    nameController.clear();
                    cubit.selectedCategoryItem = 'ai';
                    cubit.cancelToken.isCancelled
                        ? cubit.cancelToken.cancel()
                        : const SizedBox();
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
                      const SizedBox(
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
                            cubit.pausePreview();
                            cubit.pickPocCastFile();
                          },
                          context: context,
                          text: cubit.podcastFile == null
                              ? 'Pick File'
                              : 'Change Picked File'),
                      const SizedBox(
                        height: 25,
                      ),
                      cubit.podcastFile == null
                          ? const SizedBox()
                          : ListTile(
                              title: Text(
                                cubit.podcastFile!.path.split('/').last,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  cubit.previewIsplaying
                                      ? cubit.pausePreview()
                                      : cubit.playPreviewPodcast(
                                          cubit.podcastFile!.path);
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
                          : cubit.isUploading
                              ? Column(
                                  children: [
                                    LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                      value: cubit.uploadProgress,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    defaultButton(
                                      onPressed: () {
                                        cubit.cancelToken.cancel();
                                        cubit.cancelToken.isCancelled
                                            ? cubit.cancelToken =
                                                new CancelToken()
                                            : const SizedBox();
                                        // cubit.cancelToken.requestOptions
                                      },
                                      context: context,
                                      text: 'cancel',
                                      width: 150,
                                    )
                                  ],
                                )
                              : cubit.isLoadPodCast
                                  ? LinearProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : defaultButton(
                                      onPressed: () {
                                        cubit.previewIsplaying
                                            ? cubit.assetsAudioPlayer.stop()
                                            : const SizedBox();
                                        cubit.uploadPodCast(
                                            token,
                                            nameController.text,
                                            cubit.selectedCategoryItem,
                                            cubit.podcastFile!.path,
                                            context);
                                      },
                                      context: context,
                                      text: 'Upload')
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
