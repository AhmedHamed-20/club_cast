
import 'package:club_cast/components/components.dart';
import 'package:flutter/material.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

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
          'Profile Details',
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
                statusNumberProfile(
                  number: '95',
                  statusType: 'Followers',
                ),
                SizedBox(
                  width: 22.0,
                ),
                statusNumberProfile(
                  number: '225',
                  statusType: 'Following',
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
                {},
                child: Text(
                  'Follow',
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
