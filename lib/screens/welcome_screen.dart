import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:beet/constants.dart';
import 'package:beet/services/dynamic_links_services.dart';
import 'package:beet/screens/login_screen.dart';
import 'package:beet/screens/register_screen.dart';
import 'package:beet/utilities/will_pop_callback.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    DynamicLinksServices().promptLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopCallback,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        RotateAnimatedText(
                          'beet',
                          textStyle: TextStyle(
                            fontFamily: 'MPLUS1p',
                            fontSize: 96.0,
                            fontWeight: FontWeight.w900,
                            color: kPrimaryColor,
                          ),
                          transitionHeight: 300.0,
                          duration: Duration(milliseconds: 2400),
                          rotateOut: false,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 96.0),
              Container(
                height: 56.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: kPrimaryColor,
                    primary: Colors.white38,
                  ),
                  child: Text(
                    'ログイン',
                    style: TextStyle(
                      color: Color(0xFFf5f5f5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 56.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey[800],
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'アカウントを作成',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
