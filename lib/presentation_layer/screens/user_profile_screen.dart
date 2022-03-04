
import 'package:club_cast/components/components.dart';
import 'package:club_cast/presentation_layer/screens/edit_user_profile.dart';
import 'package:club_cast/presentation_layer/screens/followers_screen.dart';
import 'package:club_cast/presentation_layer/screens/following_screen.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          'Your Profile Details',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children:
          [
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: userProfileImage(
                  image: 'assets/images/Adel.png',
                  size: 75,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Ahmed Adel',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22.0,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                statusNumberProfile(
                  number: '1',
                  statusType: 'Podcasts',
                ),
                SizedBox(
                  width: 22.0,
                ),
                GestureDetector(
                  onTap: ()
                  {
                    navigateTo(
                      context,
                      FollowersScreen(),
                    );
                  },
                  child: statusNumberProfile(
                    number: '95',
                    statusType: 'Followers',
                  ),
                ),
                SizedBox(
                  width: 22.0,
                ),
                GestureDetector(
                  onTap: ()
                  {
                    navigateTo(
                      context,
                      FollowingScreen(),
                    );
                  },
                  child: statusNumberProfile(
                    number: '225',
                    statusType: 'Following',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 17.0,
            ),
            Container(
              width: 280.0,
              height: 45.0,
              child: MaterialButton(
              shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                  5.0),
                ),
                onPressed: ()
                {
                  navigateTo(
                      context,
                    EditUserProfileScreen(),
                  );
                },
                child: Text(
                 'Edit',
                style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            color: Color(0xff5ADAAC),

          ),


        ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children:
              [
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  'Podcasts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
