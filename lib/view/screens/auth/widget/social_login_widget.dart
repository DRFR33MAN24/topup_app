import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:giftme/data/model/response/social_login_model.dart';
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/google_sign_in_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/view/screens/dashboard/dashboard_screen.dart';

//import 'otp_verification_screen.dart';

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  SocialLoginWidgetState createState() => SocialLoginWidgetState();
}

class SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel socialLogin = SocialLoginModel();
  route(bool isRoute, String? token, String? temporaryToken,
      String? errorMessage) async {
    if (isRoute) {
      if (token != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false);
      } else if (temporaryToken != null && temporaryToken.isNotEmpty) {
        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .emailVerification!) {
          Provider.of<AuthProvider>(context, listen: false)
              .checkEmail(socialLogin.email.toString(), temporaryToken)
              .then((value) async {
            if (value.isSuccess) {
              Provider.of<AuthProvider>(context, listen: false)
                  .updateEmail(socialLogin.email.toString());
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => VerificationScreen(
              //             temporaryToken, '', socialLogin.email.toString())),
              //     (route) => false);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (route) => false);
            }
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Text(errorMessage!),
            backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Text(errorMessage!),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Provider.of<SplashProvider>(context, listen: false)
        //         .configModel!
        //         .socialLogin![0]
        //         .status!
        //     ? Provider.of<SplashProvider>(context, listen: false)
        //             .configModel!
        //             .socialLogin![1]
        //             .status!
        //         ? Center(child: Text(getTranslated('social_login', context)!))
        //         : Center(child: Text(getTranslated('social_login', context)!))
        //     : const SizedBox(),
        Container(
          color: Provider.of<ThemeProvider>(context).darkTheme
              ? Theme.of(context).canvasColor
              : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .socialLogin![0]
                      .status!
                  ? SignInButton(Buttons.GoogleDark, onPressed: () async {
                      await Provider.of<GoogleSignInProvider>(context,
                              listen: false)
                          .login();
                      String? id, token, email, medium;
                      if (context.mounted) {}
                      if (Provider.of<GoogleSignInProvider>(context,
                                  listen: false)
                              .googleAccount !=
                          null) {
                        id = Provider.of<GoogleSignInProvider>(context,
                                listen: false)
                            .googleAccount!
                            .id;

                        email = Provider.of<GoogleSignInProvider>(context,
                                listen: false)
                            .googleAccount!
                            .email;
                        token = Provider.of<GoogleSignInProvider>(context,
                                listen: false)
                            .auth
                            .accessToken;
                        medium = 'google';
                        if (kDebugMode) {
                          print('eemail =>$email token =>$token');
                        }
                        socialLogin.email = email;
                        socialLogin.medium = medium;
                        socialLogin.token = token;
                        socialLogin.uniqueId = id;

                        await Provider.of<AuthProvider>(context, listen: false)
                            .socialLogin(socialLogin, route);
                      }
                    })
                  // ? InkWell(
                  //     onTap: () async {
                  //       await Provider.of<GoogleSignInProvider>(context,
                  //               listen: false)
                  //           .login();
                  //       String? id, token, email, medium;
                  //       if (context.mounted) {}
                  //       if (Provider.of<GoogleSignInProvider>(context,
                  //                   listen: false)
                  //               .googleAccount !=
                  //           null) {
                  //         id = Provider.of<GoogleSignInProvider>(context,
                  //                 listen: false)
                  //             .googleAccount!
                  //             .id;

                  //         email = Provider.of<GoogleSignInProvider>(context,
                  //                 listen: false)
                  //             .googleAccount!
                  //             .email;
                  //         token = Provider.of<GoogleSignInProvider>(context,
                  //                 listen: false)
                  //             .auth
                  //             .accessToken;
                  //         medium = 'google';
                  //         if (kDebugMode) {
                  //           print('eemail =>$email token =>$token');
                  //         }
                  //         socialLogin.email = email;
                  //         socialLogin.medium = medium;
                  //         socialLogin.token = token;
                  //         socialLogin.uniqueId = id;

                  //         await Provider.of<AuthProvider>(context,
                  //                 listen: false)
                  //             .socialLogin(socialLogin, route);
                  //       }
                  //     },
                  //     child: Ink(
                  //       color: const Color(0xFF397AF3),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(6),
                  //         child: Card(
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Wrap(
                  //               crossAxisAlignment: WrapCrossAlignment.center,
                  //               children: [
                  //                 Container(
                  //                     decoration: const BoxDecoration(
                  //                         color: Colors.white,
                  //                         borderRadius: BorderRadius.all(
                  //                             Radius.circular(5))),
                  //                     height: 30,
                  //                     width: 30,
                  //                     child: Image.asset(Images
                  //                         .google)), // <-- Use 'Image.asset(...)' here
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
