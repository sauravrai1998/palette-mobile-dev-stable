import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/modules/student_dashboard_module/models/event_list_model.dart';
import 'package:palette/utils/konstants.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetail extends StatelessWidget {
  final EventInfo info;
  EventDetail({required this.info});

  Widget topRow() {
    return Row(
      children: [
        SvgPicture.asset('images/eventIcon.svg'),
        SizedBox(
          width: 15,
        ),
        Text(
          info.name,
          style: kalamLight.copyWith(color: defaultDark, fontSize: 24),
        ),
      ],
    );
  }

  Widget eventTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          info.category,
          style: kalamLight.copyWith(
              color: defaultDark.withOpacity(0.50), fontSize: 23),
        ),
        Column(
          children: [
            Text(
              info.venue,
              style: kalamLight.copyWith(
                  color: defaultDark.withOpacity(0.50), fontSize: 14),
            ),
            Text(
              convertIntoString(info.startDate),
              style: kalamLight.copyWith(
                  color: defaultDark.withOpacity(0.50), fontSize: 14),
            ),
          ],
        )
      ],
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
          icon: RotatedBox(
              quarterTurns: 1, child: SvgPicture.asset('images/dropdown.svg')),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      title: Text(
        'Events',
        style: kalamLight.copyWith(color: defaultDark, fontSize: 24),
      ),
    );
  }

  void _launchURL() async {
    String url = info.website;
    if (url.isNotEmpty) {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  topRow(),
                  SizedBox(
                    height: 10,
                  ),
                  eventTitleRow(),
                  SizedBox(
                    height: 50,
                  ),
                  Text(info.description,
                      style: montserratNormal.copyWith(
                          color: defaultDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                _launchURL();
              },
              child: Container(
                alignment: Alignment.center,
                color: greenDefault,
                width: MediaQuery.of(context).size.width,
                height: 52,
                child: Text(
                  'Visit Website',
                  style: montserratNormal.copyWith(
                      color: white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String convertIntoString(DateTime date) {
    //6am, 8th March 2021
    print(DateFormat('hh:mm a, dd MMM yyyy').format(date));

    // =  DateFormat('yyyy-MMMM-dd').format("2021-05-14 00:00:00.000");
    var theDate = DateFormat('hh:mm a, dd MMM yyyy').format(date);
    return theDate;
  }
}
