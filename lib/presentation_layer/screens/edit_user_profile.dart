import 'package:club_cast/components/components.dart';
import 'package:flutter/material.dart';

class EditUserProfileScreen extends StatelessWidget {
  const EditUserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: ()
          {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),

        ),
        title: Text(
          'Edit Your Profile Details',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children:
          [
            Center(
              child: userProfileImage(
                image: 'assets/images/Adel.png',
                size: 75,
              ),
            ),
            SizedBox(
              height: 22.0,
            ),
            Container(
              width: 322.0,
              child: TextFormField(
                controller: TextEditingController(),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  prefixIcon: Icon(
                    Icons.person,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 322.0,
              child: TextFormField(
                controller: TextEditingController(),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 322.0,
              height: 45.0,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      5.0),
                ),
                onPressed: ()
                {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    isScrollControlled: true,
                    builder: (context) =>
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    'Change Password',
                                      style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(
                                    height: 28.0,
                                  ),
                                  Container(
                                    width: 322.0,
                                    child: TextFormField(
                                      controller: TextEditingController(),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Old Password',
                                        prefixIcon: Icon(
                                          Icons.lock,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: (){},
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Container(
                                    width: 322.0,
                                    child: TextFormField(
                                      controller: TextEditingController(),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'New Password',
                                        prefixIcon: Icon(
                                          Icons.lock,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: (){},
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Container(
                                    width: 322.0,
                                    child: TextFormField(
                                      controller: TextEditingController(),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Confirm Password',
                                        prefixIcon: Icon(
                                          Icons.lock,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: (){},
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35.0,
                                  ),
                                  Container(
                                    width: 322.0,
                                    height: 45.0,
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            5.0),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        'Change',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      color: Color(0xff5ADAAC),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  );
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 322.0,
              height: 45.0,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      5.0),
                ),
                onPressed: () {},
                child: Text(
                  'Confirm',
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
          ],
        ),
      ),
    );
  }
}
