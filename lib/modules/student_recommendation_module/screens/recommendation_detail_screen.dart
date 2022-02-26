import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/call_button.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/link_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_pendo_repo.dart';
import 'package:palette/modules/student_recommendation_module/widgets/conflict_bottom_sheet.dart';
import 'package:palette/modules/student_recommendation_module/widgets/consider_opp_bottom_action.dart';
import 'package:palette/modules/student_recommendation_module/widgets/consider_opp_button_bar.dart';
import 'package:palette/modules/student_recommendation_module/widgets/event_options_popup.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

bool viewIcons = false;
typedef void RejectOpportunityCallBack(RecommendedByData recommendedItem);

class RecommendationDetail extends StatefulWidget {
  final RecommendedByData recommendation;
  final RejectOpportunityCallBack? deleteCallback;
  RecommendationDetail(this.recommendation, {required this.deleteCallback});

  @override
  _RecommendationDetailState createState() => _RecommendationDetailState();
}

class _RecommendationDetailState extends State<RecommendationDetail>
    with TickerProviderStateMixin<RecommendationDetail> {
  String sfid = '';
  String sfuuid = '';
  String role = '';
  bool otherOptionsClicked = false;
  var isTopRowOpen = false;

  @override
  void initState() {
    super.initState();
    setSfid();
    setRole();
  }

  setSfid() async {
    var prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant) ?? '';
    sfuuid = prefs.getString(saleforceUUIDConstant) ?? '';
  }

  setRole() async {
    var prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role') ?? '';
  }

  Widget topRow() {
    return Container(
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.recommendation.event!.name ?? '',
          style: kalam700.copyWith(
            color: defaultDark,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget eventTitleRow() {
    return Wrap(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.location_on_outlined,
            color: defaultDark.withOpacity(0.50), size: 20),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.recommendation.event!.venue ?? '',
                style: kalamLight.copyWith(
                    color: defaultDark.withOpacity(0.50), fontSize: 14),
              ),
              Text(
                CustomDateFormatter.dateIn_DDMMMYYYY(
                    widget.recommendation.event!.startDate ?? ''),
                style: TextStyle(
                    color: defaultDark.withOpacity(0.50), fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getImageStringForEvent({required String type}) {
    if (type == 'Event - Arts') {
      return 'images/arts_WM.svg';
    } else if (type == 'Event - Volunteer') {
      return 'images/volunteerWM.svg';
    } else if (type == 'Event - Social') {
      return 'images/social_WM.svg';
    } else if (type == 'Event - Sports') {
      return 'images/sports_WM.svg';
    }
    else if (type == 'Education') {
      return "images/education_WM.svg";
    }
    else if (type == 'Employment') {
      return 'images/employment.svg';
    } else {
      return 'images/genericVM.svg';
    }
  }

  Widget _expandableRow({required BuildContext context}) {
    return Positioned(
      top: 10,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        width: isTopRowOpen
            ? MediaQuery.of(context).size.width * 0.6
            : MediaQuery.of(context).size.width * 0.14,
        height: 50,
        decoration: BoxDecoration(
          color: pureblack,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: isTopRowOpen
              ? [
                  GestureDetector(
                    onTap: () {
                      _launchCall(
                        'tel:${widget.recommendation.event!.phone}',
                        context,
                      );
                    },
                    child: SvgPicture.asset(
                      'images/call_icon.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(context);
                    },
                    child: Icon(
                      Icons.launch,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  conflictButton(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTopRowOpen = false;
                      });
                    },
                    child: SvgPicture.asset(
                      'images/close_expand_mycreat.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ]
              : [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTopRowOpen = true;
                      });
                    },
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: white,
                      ),
                    ),
                  )
                ],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: IconButton(
            icon: RotatedBox(
                quarterTurns: 1, child: SvgPicture.asset('images/dropdown.svg')),
            onPressed: () {
              Navigator.of(context).pop();
              viewIcons = false;
            }),
      ),
    );
  }

  @override
  void dispose() {
    viewIcons = false;
    super.dispose();
  }

  void _launchURL(BuildContext context) async {
    String url = widget.recommendation.event!.website!;

    RecommendationPendoRepo.trackVisitedUrlInRecommendationDetailScreen(
      context: context,
      url: url,
      event: widget.recommendation.event,
    );

    if (url.isNotEmpty) {
      if (url.startsWith('https://')) {
        url = url;
      } else {
        url = "https://$url";
      }
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _launchCall(String phoneNo, BuildContext context) async {
    if (await canLaunch(phoneNo)) {
      RecommendationPendoRepo
          .trackTappingPhoneButtonInRecommendationDetailScreen(
        context: context,
        phone: phoneNo,
        event: widget.recommendation.event,
      );
      await launch(phoneNo);
    } else {
      throw 'Could not launch $phoneNo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return TextScaleFactorClamper(
          child: Stack(
            children: [
              Scaffold(
                appBar: appBar(context),
                backgroundColor: white,
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: LayoutBuilder(builder: (context, constraint) {
                    return _singleChildScrollView(
                      context: context,
                      constraint: constraint,
                    );
                  }),
                ),
              ),
              otherOptionsClicked
                  ? EventOptionsPopup(
                      recommendation: widget.recommendation,
                      rejectOpportunityCallBack:
                          (RecommendedByData recommendedItem) {
                        widget.deleteCallback!(recommendedItem);
                      },
                    )
                  : Container(),
              _expandableRow(context: context),
            ],
          ),
        );
      }),
    );
  }

  Widget _singleChildScrollView({
    required BuildContext context,
    required BoxConstraints constraint,
  }) {
    return SingleChildScrollView(
      physics: RangeMaintainingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraint.maxHeight),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eventTypeRow(),
              SizedBox(
                height: 10,
              ),
              topRow(),
              SizedBox(
                height: 10,
              ),
              eventTitleRow(),
              SizedBox(
                height: 35,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      widget.recommendation.event!.description != null
                          ? Scrollbar(
                              child: Container(
                                height: 310,
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Text(
                                      widget.recommendation.event!
                                              .description ??
                                          '',
                                      style: montserratNormal.copyWith(
                                          color: defaultDark,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            )
                          : Container(),
                      Positioned(
                        bottom: -75,
                        left: 2,
                        child: AnimatedSize(
                          vsync: this,
                          duration: const Duration(milliseconds: 250),
                          child: viewIcons
                              ? Container(
                                  height: 180,
                                  child: Column(
                                    children: [
                                      openLinkButton(onTap: () {
                                        _launchURL(context);
                                      }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      callButton(onTap: () {
                                        _launchCall(
                                          'tel:${widget.recommendation.event!.phone}',
                                          context,
                                        );
                                      }),
                                    ],
                                  ),
                                ): Container(),
                              )
                            ),
                        Positioned(
                          bottom: -75,
                          left: 2,
                          child: AnimatedSize(
                            vsync: this,
                            duration: const Duration(milliseconds: 250),
                            child: viewIcons
                                ? Container(
                                    height: 180,
                                    child: Column(
                                      children: [
                                        openLinkButton(onTap: () {
                                          _launchURL(context);
                                        }),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        callButton(onTap: () {
                                          _launchCall(
                                            'tel:${widget.recommendation.event!.phone}',
                                            context,
                                          );
                                        }),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
              SizedBox(height: 5),
              ConsiderOppButtonBar(
                sfid: sfid,
                role: role,
                sfuuid: sfuuid,
                recommendation: widget.recommendation,
                rejectOpportunityCallBack: (item) {
                  widget.deleteCallback!(item);
                },
                otherOptionsClicked: otherOptionsClicked,
                otherOptionsClickedCallback: () {
                  setState(() {
                    otherOptionsClicked = !otherOptionsClicked;
                  });
                },
                setter: (val) {
                  setState(() {});
                },
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget conflictButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return ConflictBottomSheet();
            },
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            backgroundColor: Colors.black54,
            elevation: 2);
      },
      child: SvgPicture.asset(
        'images/conflict_icon.svg',
        color: Colors.white,
        height: 24,
        width: 24,
      ),
    );
  }

  Widget eventTypeRow() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 22,
              width: 18,
              child: SvgPicture.asset(_getImageStringForEvent(
                  type: widget.recommendation.event!.category ?? ''),color: iconEvent,)),
          SizedBox(
            width: 3,
          ),
          Container(
            child: Text(
              widget.recommendation.event!.category ?? '',
              style: kalam700.copyWith(color: iconEvent, fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
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
