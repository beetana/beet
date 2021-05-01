import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:beet/constants.dart';
import 'package:beet/screens/use_as_guest_screen.dart';
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
    DynamicLinksServices().promptLogin(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopCallback,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                SizedBox(
                  height: 360,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          RotateAnimatedText(
                            'beet',
                            textStyle: const TextStyle(
                              fontFamily: 'MPLUS1p',
                              fontSize: 96.0,
                              fontWeight: FontWeight.w900,
                              color: kPrimaryColor,
                            ),
                            transitionHeight: 360.0,
                            duration: const Duration(milliseconds: 2400),
                            rotateOut: false,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Column(
                  children: [
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
                        child: const Text(
                          'ログイン',
                          style: TextStyle(
                            color: Colors.white,
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
                    const SizedBox(height: 12.0),
                    Container(
                      height: 56.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: kPrimaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
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
                  ],
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                TextButton(
                  child: const Text(
                    'ログインせずにセトリを作成',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kSlightlyTransparentPrimaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UseAsGuestScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
