import 'package:flutter/material.dart';

Widget publicRoomItem(
  BuildContext context,
  List<int> speaker,
  List<int> audience,
  String roomName,
  String category,
) {
  return GestureDetector(
    onTap: () {},
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(7),
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
                        child: const Image(
                          height: 15,
                          width: 50,
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/Adel.png'),
                        ),
                      ),
                      separatorBuilder: (context, index) => Container(
                        width: 1,
                      ),
                      itemCount: speaker.length,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Column(
                    children: [
                      Text(
                        '+${speaker.length}',
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
                      Text('+${audience.length}',
                          style: Theme.of(context).textTheme.bodyText1),
                      Text('Listeners',
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
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
