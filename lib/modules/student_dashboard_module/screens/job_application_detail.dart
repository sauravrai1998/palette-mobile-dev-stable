import 'package:flutter_svg/svg.dart';
import 'package:palette/modules/student_dashboard_module/models/job_application_list_model.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/pallete_activity_color_status.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common_components/common_components_link.dart';

class JobApplicationDetail extends StatefulWidget {
  final JobInfo info;
  JobApplicationDetail({required this.info});

  @override
  _JobApplicationDetailState createState() => _JobApplicationDetailState();
}

class _JobApplicationDetailState extends State<JobApplicationDetail> {
  Widget acceptButton() {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            color: ActivityStatus.getColor(
                    widget.info.applicationStatus.toLowerCase())
                .withOpacity(0.17),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: 292,
        height: 57,
        child: Center(
            child: Text(
          widget.info.applicationStatus.toUpperCase(),
          style: lightTextFieldStyle.copyWith(
              color: ActivityStatus.getColor(
                  widget.info.applicationStatus.toLowerCase())),
        )),
      ),
    );
  }

  Widget topHeaderRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset('images/buildings.svg'),
        SizedBox(
          width: 15,
        ),
        Text(
          widget.info.organizationName,
          style: kalamLight.copyWith(color: defaultDark, fontSize: 24),
        ),
      ],
    );
  }

  PreferredSizeWidget appBar() {
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
        'Career',
        style: kalamLight.copyWith(color: defaultDark, fontSize: 24),
      ),
    );
  }

  Widget checkIcon() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ActivityStatus.getColor(
            widget.info.applicationStatus.toLowerCase()),
      ),
      child: Icon(
        Icons.check,
        color: white,
      ),
    );
  }

  Widget uncheckIcon() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ActivityStatus.getColor(
            widget.info.applicationStatus.toLowerCase()),
      ),
      child: Icon(
        Icons.circle,
        color: white,
      ),
    );
  }

  Widget vectorIcon() {
    return SvgPicture.asset(
      'images/bullet_point.svg',
      width: 20,
      height: 20,
    );
  }

  Widget progressStatusWidget() {
    var width = MediaQuery.of(context).size.width - 120;
    var halfWidth = width / 2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.info.appliedDate == null ? uncheckIcon() : checkIcon(),
        Container(
          height: 1,
          width: halfWidth,
          color: ActivityStatus.getColor(
                  widget.info.applicationStatus.toLowerCase())
              .withOpacity(0.52),
        ),
        widget.info.applicationDecisionDate == null
            ? uncheckIcon()
            : checkIcon(),
        Container(
          height: 1,
          width: halfWidth,
          color: ActivityStatus.getColor(
                  widget.info.applicationStatus.toLowerCase())
              .withOpacity(0.52),
        ),
        widget.info.creationdate == null ? uncheckIcon() : checkIcon(),
      ],
    );
  }

  Widget progressStatusTexts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              'Applied',
              style: montserratNormal.copyWith(
                  color: ActivityStatus.getColor(
                      widget.info.applicationStatus.toLowerCase())),
            ),
            Builder(builder: (context) {
              if (widget.info.appliedDate == null) return SizedBox();
              return Text(
                CustomDateFormatter.stringDateIntoDDMMYY(
                    widget.info.appliedDate!),
                style: montserratNormal.copyWith(
                    color: ActivityStatus.getColor(
                        widget.info.applicationStatus.toLowerCase())),
              );
            })
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Text(
                'Employer Decision',
                style: montserratNormal.copyWith(
                    color: ActivityStatus.getColor(
                        widget.info.applicationStatus.toLowerCase())),
                textAlign: TextAlign.end,
              ),
              Builder(builder: (context) {
                if (widget.info.applicationDecisionDate == null)
                  return SizedBox();
                return Text(
                  CustomDateFormatter.dateIntoIntoDDMMYY(
                      widget.info.applicationDecisionDate!),
                  style: montserratNormal.copyWith(
                      color: ActivityStatus.getColor(
                          widget.info.applicationStatus.toLowerCase())),
                );
              })
            ],
          ),
        ),
        Column(
          children: [
            Text(
              'My Response',
              style: montserratNormal.copyWith(
                  color: ActivityStatus.getColor(
                      widget.info.applicationStatus.toLowerCase())),
            ),
            Builder(builder: (context) {
              if (widget.info.creationdate == null) return SizedBox();
              return Text(
                CustomDateFormatter.stringDateIntoDDMMYY(
                    widget.info.creationdate!),
                style: montserratNormal.copyWith(
                    color: ActivityStatus.getColor(
                        widget.info.applicationStatus.toLowerCase())),
              );
            })
          ],
        ),
      ],
    );
  }

  Widget bulletPoints(String? step) {
    return step != '' && step != null
        ? Row(
            children: [
              vectorIcon(),
              SizedBox(
                width: 12,
              ),
              Flexible(
                  child: Text(
                step,
                style: montserratNormal.copyWith(fontWeight: FontWeight.w700),
                maxLines: 2,
              )),
            ],
          )
        : Container();
  }

  Widget stepsToTakeList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: 300,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.info.stepsToTake?.length,
          itemBuilder: (context, index) {
            var step = widget.info.stepsToTake![index];
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: bulletPoints(step),
            );
          }),
    );
  }

  void _launchURL() async {
    String url = widget.info.applicationLink;
    if (url.isNotEmpty) {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Widget buildWidgetTree() {
    return SafeArea(
      child: Semantics(
        label:
            "Welcome to your dashboard. Here you can navigate between different pages related to your profile using the bottom navigation bar below. You can also switch to the explore view with similar pages and bottom navigation bar by swiping across the bottom from right to left. A left to right swipe on the bottom in the explore view will bring you back to the current profile view",
        child: Scaffold(
          body: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: appBar(),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 33,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 47.5, right: 22, bottom: 58),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            topHeaderRow(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.info.position,
                              style: lightTextFieldStyle.copyWith(
                                color: defaultDark.withOpacity(0.56),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              widget.info.description,
                              style: lightTextFieldStyle.copyWith(
                                color: profileCardBackgroundColor
                                    .withOpacity(0.85),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 17,
                            ),
                          ],
                        ),
                      ),
                      acceptButton(),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            progressStatusWidget(),
                            progressStatusTexts()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text('Steps to take',
                          style: montserratNormal.copyWith(fontSize: 18)),
                      stepsToTakeList(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    _launchURL();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: ActivityStatus.getColor(
                        widget.info.applicationStatus.toLowerCase()),
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    child: Text(
                      'Visit Website',
                      style: montserratNormal.copyWith(
                          color: white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildWidgetTree();
  }
}
