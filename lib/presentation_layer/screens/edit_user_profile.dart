import 'package:club_cast/components/components.dart';
import 'package:flutter/material.dart';

class EditUserProfileScreen extends StatelessWidget {
  const EditUserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
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
          children: [
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelText: 'User Name',
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelText: 'Email',
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
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
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
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
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    labelText: 'Old Password',
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      onPressed: () {},
                                    ),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color!),
                                    ),
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
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    labelText: 'New Password',
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      onPressed: () {},
                                    ),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color!),
                                    ),
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
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    labelText: 'Confirm Password',
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      onPressed: () {},
                                    ),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color!),
                                    ),
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
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Change',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  color: Theme.of(context).primaryColor,
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
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () {},
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                color: Theme.of(context).primaryColor,
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
