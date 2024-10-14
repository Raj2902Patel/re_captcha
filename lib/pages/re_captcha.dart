import 'package:flutter/material.dart';
import 'dart:math';

class ReCaptchaPage extends StatefulWidget {
  const ReCaptchaPage({super.key});

  @override
  State<ReCaptchaPage> createState() => _ReCaptchaPageState();
}

class _ReCaptchaPageState extends State<ReCaptchaPage> {
  String randomString = "";
  String verificationText = "";
  bool isVerified = false;
  bool showVerificationIcon = false;

  TextEditingController captchaController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildCaptcha();
  }

  void buildCaptcha() {
    const letters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const length = 6;
    final random = Random();
    randomString = String.fromCharCodes(List.generate(
        length, (index) => letters.codeUnitAt(random.nextInt(letters.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Text("Re Captcha Demo"),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    randomString,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      buildCaptcha();
                    });
                  },
                  icon: const Icon(
                    Icons.refresh_outlined,
                    size: 30.0,
                  ),
                )
              ],
            ),
            Container(
              decoration: const BoxDecoration(),
              margin: const EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    isVerified = false;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.blueGrey,
                      width: 1.5,
                    ),
                  ),
                  hintText: "Enter Captcha",
                ),
                controller: captchaController,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: showVerificationIcon,
                  child: const Icon(Icons.verified),
                ),
                const SizedBox(
                  width: 5,
                ),
                isVerified
                    ? Text(
                        verificationText,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        verificationText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.6),
              ),
              onPressed: () {
                isVerified = captchaController.text == randomString;

                if (isVerified) {
                  verificationText = "Verified!";
                  showVerificationIcon = true;
                } else {
                  verificationText = "Please Enter Correct Characters!";
                  showVerificationIcon = false;
                }

                setState(() {});
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
