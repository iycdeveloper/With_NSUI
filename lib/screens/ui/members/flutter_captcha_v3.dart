import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'dart:io' show Platform;

class ReCaptchaScreen extends StatefulWidget {
  const ReCaptchaScreen();

  @override
  State<ReCaptchaScreen> createState() => _ReCaptchaScreenState();
}

class _ReCaptchaScreenState extends State<ReCaptchaScreen> {
  String _clientState = "NOT INITIALIZED";
  String _token = "NO TOKEN";

  void initClient() async {
    String siteKey = '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';
        // '6Ldo1CAqAAAAAD6eNXmvBf3hCWByH5xNbkuIwD5d';
        // 'AIzaSyAsk6NU3XTRuZIhLxrPBMepheQifWFEnl4';

    var result = false;
    var errorMessage = "failure";

    try {
      result = await RecaptchaEnterprise.initClient(siteKey, timeout: 10000);
    } on PlatformException catch (err) {
      debugPrint('Caught platform exception on init: $err');
      errorMessage = 'Code: ${err.code} Message ${err.message}';
    } catch (err) {
      debugPrint('Caught exception on init: $err');
      errorMessage = err.toString();
    }

    setState(() {
      _clientState = result ? "ok" : errorMessage;
    });
  }

  void execute({custom = false}) async {
    String result;

    try {
      result = custom
          ? await RecaptchaEnterprise.execute(RecaptchaAction.custom('foo'),
          timeout: 10000)
          : await RecaptchaEnterprise.execute(RecaptchaAction.LOGIN());
    } on PlatformException catch (err) {
      debugPrint('Caught platform exception on execute: $err');
      result = 'Code: ${err.code} Message ${err.message}';
    } catch (err) {
      debugPrint('Caught exception on execute: $err');
      result = err.toString();
    }

    setState(() {
      _token = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('reCAPTCHA Example'),
          ),
          body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                const Text('reCAPTCHA Client:\n '),
                Text(_clientState, key: const Key('clientState')),
              ]),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              const Text('reCAPTCHA Token:\n '),
              SizedBox(
                width: 300,
                child: Text(_token,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 12,
                    key: const Key('token')),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextButton(
                onPressed: () {
                  initClient();
                },
                key: const Key('initButton'),
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    'Init',
                    style: TextStyle(color: Colors.white, fontSize: 13.0),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  execute();
                },
                key: const Key('executeButton'),
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    'Execute',
                    style: TextStyle(color: Colors.white, fontSize: 13.0),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  execute(custom: true);
                },
                key: const Key('executeButtonCustom'),
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: const Text(
                    'ExecuteCustom',
                    style: TextStyle(color: Colors.white, fontSize: 13.0),
                  ),
                ),
              ),
            ]),
          ]),
        );
  }
}