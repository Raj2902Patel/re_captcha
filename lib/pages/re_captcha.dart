import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class ReCaptchaPage extends StatefulWidget {
  const ReCaptchaPage({super.key});

  @override
  State<ReCaptchaPage> createState() => _ReCaptchaPageState();
}

class _ReCaptchaPageState extends State<ReCaptchaPage> {
  final FlutterTts flutterTts = FlutterTts();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSpeaking = false; // Track speaking status

  speak(String text) async {
    setState(() {
      isSpeaking = true; // Set speaking status to true
    });

    await flutterTts.setLanguage("en-US");

    for (int i = 0; i < text.length; i++) {
      String character = text[i];

      // Check if the character is uppercase
      if (character == character.toUpperCase() && character != ' ') {
        await flutterTts.setPitch(1.5); // Set a higher pitch for uppercase
        await flutterTts.setSpeechRate(
            0.7); // Set a slightly faster speech rate for uppercase
      } else {
        await flutterTts.setPitch(1.0); // Normal pitch for lowercase
        await flutterTts.setSpeechRate(0.5); // Normal speech rate for lowercase
      }

      await flutterTts.speak(character);
      await Future.delayed(
          const Duration(seconds: 1)); // Slight delay between characters
    }

    // After speaking is done, set speaking status to false
    setState(() {
      isSpeaking = false;
    });
  }

  String randomString = "";
  String verificationText = "";
  bool isVerified = false;
  bool showVerificationIcon = false;

  TextEditingController captchaController = TextEditingController();

  @override
  void initState() {
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
        child: Form(
          key: _formKey,
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
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: isSpeaking
                        ? null
                        : () => setState(() {
                              buildCaptcha();
                            }),
                    icon: isSpeaking
                        ? Icon(Icons.block)
                        : const Icon(
                            Icons.refresh_outlined,
                            size: 30.0,
                          ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: isSpeaking
                        ? null
                        : () => speak(randomString), // Disable if speaking
                    icon: isSpeaking
                        ? const Icon(Icons.volume_off_outlined)
                        : const Icon(Icons.volume_up_outlined),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(25.0),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      isVerified = false;
                    });
                    _formKey.currentState?.validate(); // Dynamically validate
                  },
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(fontSize: 15.0),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Captcha is required';
                    } else if (value != randomString) {
                      return 'Incorrect Captcha';
                    }
                    return null; // No error if captcha is correct
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.6),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If form is valid, verify captcha
                    setState(() {
                      verificationText = "Verified!";
                      showVerificationIcon = true;
                      captchaController.clear();
                    });

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: LottieBuilder.asset(
                          'assets/verified.json',
                          height: 120,
                        ),
                        content: Container(
                          child: const Text(
                            textAlign: TextAlign.center,
                            "reCaptcha Verified!",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                buildCaptcha();
                                captchaController.clear();
                                verificationText = "";
                                isVerified = false;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    setState(() {
                      verificationText = "Please Enter Correct Characters!";
                      showVerificationIcon = false;
                    });
                  }
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
      ),
    );
  }
}
