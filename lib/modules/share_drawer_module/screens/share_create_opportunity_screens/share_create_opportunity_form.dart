import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_repos/common_link_info.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/create_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/save_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/widgets/common_datepicker_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/common_textbox_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/common_textfield_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/event_type_dropdown.dart';
import 'package:palette/modules/share_drawer_module/model/link_meta_info.dart';
import 'package:palette/modules/share_drawer_module/model/share_detail_view_model.dart';
import 'package:palette/modules/share_drawer_module/screens/share_create_opportunity_screens/share_opportunty_recipients.dart';
import 'package:palette/modules/share_drawer_module/screens/share_detail_view.dart';
import 'package:palette/modules/share_drawer_module/services/sharedrawer_navigation_repo.dart';
import 'package:palette/modules/share_drawer_module/widgets/loading_helper.dart';
import 'package:palette/modules/share_drawer_module/widgets/share_drawer_back_button.dart';
import 'package:palette/modules/share_drawer_module/widgets/weblink_container.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareCreateOpportunityForm extends StatefulWidget {
  final String urlLink;
  ShareCreateOpportunityForm({Key? key, required this.urlLink})
      : super(key: key);

  @override
  _ShareCreateOpportunityFormState createState() =>
      _ShareCreateOpportunityFormState();
}

class _ShareCreateOpportunityFormState
    extends State<ShareCreateOpportunityForm> {
  var eventTitleController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  DateTime? expirationDate;
  String eventType = 'Event Type';

  bool errorEventDropdown = false;
  bool errorTitle = false;
  bool errorDescription = false;
  bool errorExpiratioDate = false;

  String role = 'Role';
  String? test;
  LinkMetaInfo? linkMetaInfo;
  bool isFetching = true;

  @override
  void initState() {
    super.initState();
    fetchLinkInfo();
  }

  fetchLinkInfo() async {
    linkMetaInfo =
        await CommonLinkMetaInfo().getMetaInfoOfLink(url: widget.urlLink);
    eventTitleController.text = linkMetaInfo?.title ?? "";
    eventDescriptionController.text = linkMetaInfo?.description ?? "";
    setState(() {
      isFetching = false;
    });
    var prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LoadingHelper(
      isLoading: isFetching,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SvgPicture.asset('images/bgsharedrawer.svg', height: 200),
            ),
            LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                physics: RangeMaintainingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            topRow(),
                            SizedBox(height: 20),
                            BlocListener(
                                listener: (context, state) {
                                  if (state is SaveOpportunitySuccessState) {
                                    ShareDrawerNavigationRepo.instance
                                        .shareDrawerNavigationAfterSuccess(
                                            context: context);
                                  }
                                },
                                bloc: BlocProvider.of<SaveOpportunityBloc>(
                                    context),
                                child: BlocListener(
                                    listener: (context, state) {
                                      if (state
                                          is CreateOpportunitySuccessState) {
                                        ShareDrawerNavigationRepo.instance
                                            .shareDrawerNavigationAfterSuccess(
                                                context: context);
                                      }
                                    },
                                    bloc:
                                        BlocProvider.of<CreateOpportunityBloc>(
                                            context),
                                    child: body(constraints: constraint))),
                            SizedBox(height: 20),
                          ],
                        ),
                        Container(
                          child: nextButton(context),
                          margin: EdgeInsets.only(bottom: 30),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ));
  }

  Widget topRow() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 20,
      ),
      child: Row(
        children: <Widget>[
          ShareDrawerBackButton(),
          SizedBox(
            width: 10,
          ),
          SharedWebLinkContainer(url: widget.urlLink),
        ],
      ),
    );
  }

  Widget body({required Constraints constraints}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Create opportunity',
                  style: montserratSemiBoldTextStyle.copyWith(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CommonTextFieldOpportunity(
                hintText: 'Event title',
                imagePath: 'event_title',
                inputController: eventTitleController,
                errorFlag: errorTitle,
                validFlag: true,
              ),
              SizedBox(height: 14),
              Text(
                'Set an expiration date for the opportunity',
                style: roboto700.copyWith(fontSize: 14, color: defaultDark),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  DatePickerOpportunity(
                    onDateSelected: (newDate) {
                      setState(() {
                        expirationDate = newDate;
                      });
                    },
                    errorFlag: errorExpiratioDate,
                    initialDate: expirationDate,
                    isExprireDate: true,
                  ),
                ],
              ),
              SizedBox(height: 14),
              EventTypeDropDownMenu(
                  errorDropdown: errorEventDropdown,
                  onChanged: (newValue) {
                    setState(() {
                      eventType = newValue ?? 'Event Type';
                      errorEventDropdown = false;
                    });
                  },
                  selectedValue: eventType,
                  items: [
                    'Event Type',
                    "Event - Arts",
                    "Event - Social",
                    "Event - Volunteer",
                    "Event - Sports",
                    "Education",
                    "Other",
                    "Employment"

                  ]),
              SizedBox(height: 14),
              CommonTextAreaOpportunity(
                hintText: 'Enter Description',
                controller: eventDescriptionController,
                errorFlag: errorDescription,
              ),
              SizedBox(height: 14),
            ]));
  }

  bool isValid() {
    if (eventTitleController.text.isEmpty || eventTitleController.text == '') {
      errorTitle = true;
      setState(() {});
      return false;
    }
    if (expirationDate == null) {
      errorExpiratioDate = true;
      setState(() {});
      return false;
    }
    if (eventType == 'Event Type') {
      setState(() {
        errorEventDropdown = true;
      });
      return false;
    }

    return true;
  }

  Widget nextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isValid()) {
          final detailmodel = ShareDetailViewForOppModel(
                    webUrl: widget.urlLink,
                    description: eventDescriptionController.text,
                    title: eventTitleController.text,
                    eventType: eventType,
                    expireDate: expirationDate ??
                        DateTime(DateTime.now().year , DateTime.now().month,
                            DateTime.now().day));
          // Navigation
          role.toLowerCase() == 'student' ?
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ShareDetailView(isSendToProgramSelected: false,selectedRecipientsList: [],shareDetailViewModel: detailmodel,)))
            : showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            isScrollControlled: true,
              builder: (context) => ShareSelectRecipientsForOpp(
                shareDetailViewModel: detailmodel,
                isFromCreateOpp: true,
              ),
            );
        }
      },
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
            color: purpleBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 3),
                  blurRadius: 6)
            ]),
        child: Center(
          child: Text(
            'Next'.toUpperCase(),
            style: robotoTextStyle.copyWith(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
