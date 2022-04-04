import 'package:club_cast/data_layer/sockets/sockets_io.dart';
import 'package:flutter/material.dart';

import '../../data_layer/agora/rtc_engine.dart';

Widget publicRoomItem(
    {required BuildContext context,
    required List speaker,
    required List audience,
    required String roomName,
    required String category,
    required VoidCallback click,
    required List adminData}) {
  return GestureDetector(
    onTap: click,
    child: SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Theme.of(context).backgroundColor,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.422,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image(
                          height: 15,
                          width: 50,
                          fit: BoxFit.cover,
                          image: speaker.length < 3
                              ? NetworkImage(adminData[0]['photo'])
                              : NetworkImage(speaker[index]['photo']),
                        ),
                      ),
                      separatorBuilder: (context, index) => Container(
                        width: 1,
                      ),
                      itemCount: speaker.length < 3 ? 1 : 3,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Column(
                    children: [
                      Text(
                        '${speaker.length < 3 ? 1 : speaker.length}',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text('Speaker',
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Column(
                    children: [
                      Text('${audience.length}',
                          style: Theme.of(context).textTheme.bodyText1),
                      Text('Listeners',
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'CreatedBy: ',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Text(
                    adminData[0]['name'],
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.grey,
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
}
