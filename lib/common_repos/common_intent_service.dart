import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette/common_repos/common_user_service.dart';
import 'package:palette/common_repos/navigator_service.dart';
import 'package:palette/modules/share_drawer_module/bottom_sheets/shared_bottom_sheet.dart';
import 'package:palette/modules/share_drawer_module/screens/login_message.dart';
import 'package:palette/modules/share_drawer_module/screens/share_screen_view.dart';

class CommonIntentService {
  late StreamSubscription _intentDataStreamSubscription;
  StreamController<String> _sharedLinkController =
      StreamController<String>.broadcast();
  static Stream<String>? _streamLink;
  static const EventChannel _eChannelLink =
      const EventChannel("receive_sharing_intent/events-text");
  static const MethodChannel _mChannel =
      const MethodChannel('receive_sharing_intent/messages');

  getTextStream() {
    if (_streamLink == null) {
      _streamLink = _eChannelLink.receiveBroadcastStream("text").cast<String>();
    }
    return _streamLink!;
  }

  static Future<String?> getInitialText() async {
    String? data = await _mChannel.invokeMethod('getInitialText');
    log("Received Data at initial is:$data");
    return data;
  }

  void handleIntentService() {
    if (Platform.isAndroid) {
      log("Handle Intent Service Started");
      getTextStream().listen((String value) {
        log("Received text:$value");
        _sharedLinkController.add(value);
      }, onError: (error) {
        print("getLinkStream error: $error");
      });

      getInitialText().then((value) {
        log("Received text:$value");
        _sharedLinkController.add(value ?? "");
      }, onError: (error) {});
      handleStream(NavigatorService.navigatorKey.currentContext!);
    }
  }

  void disposeStreams() {
    log("Disposing Intent Service");
    _intentDataStreamSubscription.cancel();
  }

  Stream listenStream() {
    return _sharedLinkController.stream;
  }

  void showUi(BuildContext context, String event) {
    var urlPattern =
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    var match = RegExp(urlPattern, caseSensitive: false).hasMatch('$event');
    if (match) {
      CommonUserService().isUserLoggedIn().then((value) {
        if (value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ShareScreenView(urlLink: event)));
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginMessage(
                        urlLink: event,
                      )),
              (_) => true);
        }
      });
    } else {
      showModalBottomSheet(
          elevation: 100,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          context: context,
          builder: (context) =>
              sharedBottomSheet(context, text: event, isLink: match));
    }
  }

  void handleStream(BuildContext context) async {
    log("Started Handling Streams");
    listenStream().listen((event) {
      if (event != "" && event != "") {
        log("Fetched Message is:$event");
        showUi(context, event);
      }
    });
  }
}
