import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/create_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/save_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/widgets/common_opportunity_alerts.dart';
import 'package:palette/modules/share_drawer_module/model/share_detail_view_model.dart';
import 'package:palette/modules/share_drawer_module/screens/share_create_opportunity_screens/share_opportunty_recipients.dart';
import 'package:palette/modules/share_drawer_module/services/sharedrawer_navigation_repo.dart';
import 'package:palette/modules/share_drawer_module/services/sharedrawer_pendo_repo.dart';
import 'package:palette/modules/share_drawer_module/widgets/entire_school_item.dart';
import 'package:palette/modules/share_drawer_module/widgets/weblink_container.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareDetailView extends StatefulWidget {
  final ShareDetailViewForOppModel shareDetailViewModel;
  final List<ContactsData> selectedRecipientsList;
  final bool isSendToProgramSelected;

  ShareDetailView(
      {Key? key,
      required this.shareDetailViewModel,
      required this.selectedRecipientsList,
      required this.isSendToProgramSelected})
      : super(key: key);

  @override
  _ShareDetailViewState createState() => _ShareDetailViewState();
}

class _ShareDetailViewState extends State<ShareDetailView> {
  String role = '';
  UserInfoModelForPendo? userInfoModelForPendo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setRole();
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    userInfoModelForPendo = await ShareDrawerPendoRepo.fetchUserInfo();
  }

  void setRole() async {
    var prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role').toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SvgPicture.asset('images/bgsharedrawer.svg', height: 200),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    topRow(),
                    SizedBox(height: 15),
                    BlocListener(
                        listener: (context, state) {
                          if (state is SaveOpportunitySuccessState) {
                            ShareDrawerNavigationRepo.instance
                                .shareDrawerNavigationAfterSuccess(
                                    context: context);
                          }
                          if (state is SaveOpportunityFailureState) {
                            Helper.showToast(state.errorMessage);
                          }
                        },
                        bloc: BlocProvider.of<SaveOpportunityBloc>(context),
                        child: BlocListener(
                            listener: (context, state) {
                              if (state is CreateOpportunitySuccessState) {
                                ShareDrawerNavigationRepo.instance
                                    .shareDrawerNavigationAfterSuccess(
                                        context: context);
                              }
                              if (state is CreateOpportunityFailureState) {
                                Helper.showToast(state.errorMessage);
                              }
                            },
                            bloc:
                                BlocProvider.of<CreateOpportunityBloc>(context),
                            child: body())),
                  ],
                ),
                Column(
                  children: [
                    buttonRow(),
                    SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget topRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Preview',
            style: roboto700.copyWith(fontSize: 24, color: pureblack),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'images/edit_mycreat.svg',
              color: pureblack,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: SharedWebLinkContainer(
                  url: widget.shareDetailViewModel.webUrl)),
          SizedBox(height: 8),
          eventType(),
          SizedBox(height: 5),
          Text(widget.shareDetailViewModel.title,
              style: montserratBoldTextStyle.copyWith(
                  fontSize: 24, color: defaultDark)),
          SizedBox(height: 16),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Text(widget.shareDetailViewModel.description,
                style: montserratNormal.copyWith(
                    fontSize: 16, color: defaultDark)),
          ),
          SizedBox(height: 8),
          Visibility(
              visible: role.toLowerCase() != 'student', child: recipients())
        ],
      ),
    );
  }

  Widget eventType() {
    return Container(
      //width: 160,
      height: 40,
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: purpleBlue,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'images/event_type.svg',
            color: white,
            height: 25,
          ),
          SizedBox(width: 8),
          Text(
            '${widget.shareDetailViewModel.eventType}',
            style: kalam700.copyWith(fontSize: 18, color: white),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget recipients() {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recipients',
                  style: montserratBoldTextStyle.copyWith(
                      fontSize: 24, color: pureblack),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
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
                        shareDetailViewModel: widget.shareDetailViewModel,
                        isFromCreateOpp: false,
                      ),
                    );
                  },
                  child: Text('See All',
                      style: montserratBoldTextStyle.copyWith(
                          fontSize: 16, color: pureblack)),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          purpleBlue.withOpacity(0.3))),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: widget.isSendToProgramSelected ? 74 : 45,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return widget.isSendToProgramSelected
                    ? EntireSchoolItem()
                    : _avatar(index: index);
              },
              itemCount: widget.isSendToProgramSelected
                  ? 1
                  : widget.selectedRecipientsList.length,
              //itemCount: widget.selectedRecipientsList.length,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }

  Widget _avatar({required int index}) {
    var recipient = widget.selectedRecipientsList[index];
    var initials =
        recipient.name.split(' ').map((e) => e.substring(0, 1)).join();
    var imageUrl = recipient.profilePicture;
    return Container(
      height: 45,
      width: 45,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: aquaBlue),
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: imageUrl == null
            ? Text(initials,
                style: darkTextFieldStyle.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w700, color: aquaBlue))
            : CachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircleAvatar(
                    radius:
                        // widget.screenHeight <= 736 ? 35 :
                        29,
                    backgroundColor: Colors.white,
                    child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Text(initials,
                    style: darkTextFieldStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: aquaBlue)),
              ),
      ),
    );
  }

  Widget buttonRow() {
    return Container(
      height: 60,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(-2, 6), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 5),
          cancelButton(onPressed: () {
            _showAlert(
                alertType: OpportunityAlertsType.delete,
                actionType: OpportunityActionType.opportunity,
                onYesTap: () {
                  print('yes');
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
          }),
          SizedBox(width: 10),
          submitButton(onPressed: () {
            _showAlert(
                alertType: OpportunityAlertsType.create,
                actionType: OpportunityActionType.opportunity,
                onYesTap: () {
                  print('yes');
                  Navigator.pop(context);
                  _submitOpporunity();
                });
          }),
          SizedBox(width: 10),
          saveButton(onPressed: () {
            _showAlert(
                alertType: OpportunityAlertsType.save,
                actionType: OpportunityActionType.opportunity,
                onYesTap: () {
                  print('yes');
                  Navigator.pop(context);
                  _saveOpporunity();
                });
          }),
        ],
      ),
    );
  }

  Widget submitButton({required Function onPressed}) {
    return Container(
      width: 90,
      height: 40,
      child: BlocBuilder<CreateOpportunityBloc, CreateOpportunityState>(
          builder: (context, state) {
        return IgnorePointer(
          ignoring: state is CreateOpportunityLoadingState,
          child: GestureDetector(
            onTap: () {
              onPressed();
            },
            child: state is CreateOpportunityLoadingState
                ? Center(
                    child: SpinKitChasingDots(
                      color: green,
                      size: 20,
                    ),
                  )
                : Container(
                    width: 40,
                    child: Row(children: [
                      Text('SUBMIT',
                          style: robotoTextStyle.copyWith(
                              color: Color(0xFF44A13B),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 5),
                      Icon(Icons.done_all, color: Color(0xFF44A13B), size: 20)
                    ]),
                  ),
          ),
        );
      }),
    );
  }

  Widget saveButton({required Function onPressed}) {
    return BlocBuilder<SaveOpportunityBloc, SaveOpportunityState>(
        builder: (context, saveState) {
      return GestureDetector(
        onTap: () =>
            saveState is SaveOpportunityLoadingState ? () {} : onPressed(),
        child: Container(
          width: 65,
          child: saveState is SaveOpportunityLoadingState
              ? Center(
                  child: SpinKitChasingDots(
                    color: greyishGrey,
                    size: 20,
                  ),
                )
              : Row(children: [
                  Text('SAVE',
                      style: robotoTextStyle.copyWith(
                          color: greyishGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: 5),
                  Icon(Icons.bookmark_outline_outlined,
                      color: greyishGrey, size: 20)
                ]),
        ),
      );
    });
  }

  Widget cancelButton({required Function onPressed}) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Icon(Icons.cancel_outlined, color: red, size: 20),
    );
  }

  _showAlert(
      {required OpportunityAlertsType alertType,
      required OpportunityActionType actionType,
      required Function onYesTap}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OpportunityAlerts(
          type: alertType,
          actionType: actionType,
          onYesTap: () => onYesTap(),
        );
      },
      barrierDismissible: true,
    );
  }

  void _submitOpporunity() {
    //final _eventTime = eventTime ?? TimeOfDay(hour: 00, minute: 00);
    List<String> _assignesId = widget.selectedRecipientsList
        .map((recipient) => recipient.sfid)
        .toList();
    OpportunitiesModel _opportunityModel = OpportunitiesModel(
      description: widget.shareDetailViewModel.description.isEmpty
          ? ' '
          : widget.shareDetailViewModel.description,
      eventDateTime: null,
      eventType: widget.shareDetailViewModel.eventType,
      eventTitle: widget.shareDetailViewModel.title,
      phone: ' ',
      website: widget.shareDetailViewModel.webUrl,
      venue: ' ',
      expirationDateTime: widget.shareDetailViewModel.expireDate,
    );
    if (role.toLowerCase() == 'student') {
      BlocProvider.of<CreateOpportunityBloc>(context).add(
          CreateOpportunityForStudentEvent(
              opportunitiesInfoDto: _opportunityModel));
        ShareDrawerPendoRepo.trackCreateDiscreteOpp(
          pendoState: userInfoModelForPendo!);
    } else {
      BlocProvider.of<CreateOpportunityBloc>(context).add(
          CreateOpportunityForAllRolesEvent(
              opportunitiesInfoDto: _opportunityModel,
              assigneesId: _assignesId,
              isGlobal: widget.isSendToProgramSelected,
              context: context));
       if (widget.isSendToProgramSelected) {
        ShareDrawerPendoRepo.trackCreateGlobalOpp(
            pendoState: userInfoModelForPendo!);
      } else {
        ShareDrawerPendoRepo.trackCreateDiscreteOpp(
            pendoState: userInfoModelForPendo!);
      }
    }
  }

  void _saveOpporunity() {
    List<String> _assignesId = widget.selectedRecipientsList
        .map((recipient) => recipient.sfid)
        .toList();
    OpportunitiesModel _opportunityModel = OpportunitiesModel(
      description: widget.shareDetailViewModel.description.isEmpty
          ? ' '
          : widget.shareDetailViewModel.description,
      eventDateTime: null,
      eventType: widget.shareDetailViewModel.eventType,
      eventTitle: widget.shareDetailViewModel.title,
      phone: ' ',
      website: widget.shareDetailViewModel.webUrl,
      venue: ' ',
      expirationDateTime: widget.shareDetailViewModel.expireDate,
    );
    if (role.toLowerCase() == 'student') {
      BlocProvider.of<SaveOpportunityBloc>(context).add(
          SaveOpportunityForStudentEvent(
              opportunitiesModel: _opportunityModel));
      ShareDrawerPendoRepo.trackSaveDiscreteOpp(
          pendoState: userInfoModelForPendo!);
    } else {
      BlocProvider.of<SaveOpportunityBloc>(context).add(
          SaveOpportunityForOtherRolesEvent(
              opportunitiesModel: _opportunityModel,
              assigneesId: _assignesId,
              context: context,
              isGlobal: widget.isSendToProgramSelected));
      if (widget.isSendToProgramSelected) {
        ShareDrawerPendoRepo.trackSaveGlobalOpp(
            pendoState: userInfoModelForPendo!);
      } else {
        ShareDrawerPendoRepo.trackSaveDiscreteOpp(
            pendoState: userInfoModelForPendo!);
      }
    }
  }
}
