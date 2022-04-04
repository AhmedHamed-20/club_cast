import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:club_cast/presentation_layer/components/component/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/constant/constant.dart';

modalBottomSheetItem(BuildContext context, VoidCallback createClick) {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).backgroundColor,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (context) => buildSheet(context, createClick),
  );
}

Widget buildSheet(BuildContext context, VoidCallback createClick) {
  var cubit = GeneralAppCubit.get(context);
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Form(
            child: Column(
              children: [
                Text(
                  'Create Your Room',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                defaultTextFormField(
                  controller: cubit.roomNameController,
                  labelText: 'Room Name',
                  keyboardType: TextInputType.text,
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  onChanged: (value) {},
                  onSubmit: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "You Must Enter Your Room Name!";
                    }
                  },
                  context: context,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Row(
                  children: [
                    Text(
                      'Category',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    buildCategoryDropDownButton(context: context),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: cubit.isPublicRoom
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Public',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                    ),
                                    Text('Any one Can Enter The Room',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ))
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Private',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                    ),
                                    Text('Only people have link can enter',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ))
                                  ],
                                ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.11,
                        ),
                        Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor,
                          activeTrackColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          value: cubit.isPublicRoom,
                          onChanged: (value) {
                            setState(() => cubit.isPublicRoom = value);
                            print("PublicRoom:${cubit.isPublicRoom}");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Record and Save as PodCast',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.049,
                        ),
                        Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor,
                          activeTrackColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          value: cubit.isRecordRoom,
                          onChanged: (value) {
                            setState(() => cubit.isRecordRoom = value);
                            print("recordRoom:${cubit.isRecordRoom}");
                          },
                        ),
                      ],
                    ),
                    Text('The room will be saved in Your Profile as PodCast ',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 14,
                              color: Colors.grey[500],
                            )),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                defaultButton(
                  onPressed: createClick,
                  context: context,
                  text: 'Create',
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildCategoryDropDownButton({required BuildContext context}) {
  var cubit = GeneralAppCubit.get(context);
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(10),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: cubit.selectedCategoryItem,
              dropdownColor: Theme.of(context).backgroundColor,
              onChanged: (value) {
                setState(() {
                  cubit.selectedCategoryItem = value!;
                });
              },
              items: GeneralAppCubit.category
                  .map(
                    (item) => DropdownMenuItem<String>(
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      value: item,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    },
  );
}
