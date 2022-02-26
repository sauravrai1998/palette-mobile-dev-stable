import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/explore_module/blocs/get_my_creations_bloc/get_my_creations_bloc.dart';
import 'package:palette/modules/explore_module/blocs/modification_removal_request_bloc/modification_removal_request_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/edit_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/get_modification_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/get_recipients_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/save_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/models/modification_request_model.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/widgets/common_datepicker_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/common_opportunity_alerts.dart';
import 'package:palette/modules/explore_module/widgets/common_textbox_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/common_textfield_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/common_timepicker_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/event_type_dropdown.dart';
import 'package:palette/modules/explore_module/widgets/select_recipients_button.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class ModificationRequestPage extends StatefulWidget {
  final OppCreatedByMeModel opportunity;
  ModificationRequestPage({required this.opportunity});

  @override
  _ModificationRequestPageState createState() => _ModificationRequestPageState();
}

class _ModificationRequestPageState extends State<ModificationRequestPage> {
  var eventTitleController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  var phoneController = TextEditingController();
  var weblinkController = TextEditingController();
  var eventVenueController = TextEditingController();
  DateTime? eventDate;
  DateTime? expiratioDate;
  TimeOfDay? eventTime;
  String eventType = 'Event Type';
  List<String> eventTypes = [
    'Event Type',
    "Event - Arts",
    "Event - Social",
    "Event - Volunteer",
    "Event - Sports",
    "Education",
    "Other",
    "Employment"
  ];

  bool errorEventDropdown = false;
  bool errorTitle = false;
  bool errorDescription = false;
  bool errorPhone = false;
  bool errorWeblink = false;
  bool errorVenue = false;
  bool errorDate = false;
  bool errorTime = false;
  bool errorExpiratioDate = false;
  bool errorRecipients = false;
  late String role;
  String selectedRecipientsName = '';
  List<ContactsData> _selectedRecipientsList = [];
  bool _isSendToProgramSelected = true;
  List<ContactsData> recipientsList = [];
  bool isRecipientsListEnabled = false;
  bool isLoading = false;
  bool isDraft = false;

  void loadData(ModificationRequest modificationRequest) {
    eventTitleController.text = modificationRequest.eventName;
    if (modificationRequest.description != null) {
      eventDescriptionController.text = modificationRequest.description!;
    }
    if (modificationRequest.phoneNumber != null &&
        modificationRequest.phoneNumber != 'phone') {
      phoneController.text = modificationRequest.phoneNumber!;
    }
    if (modificationRequest.website != null &&
        modificationRequest.website != 'website') {
      weblinkController.text = modificationRequest.website!;
    }
    if (modificationRequest.venue != null) {
      eventVenueController.text = modificationRequest.venue!;
    }
    if (modificationRequest.eventDate != null) {
      eventDate = DateTime.parse(modificationRequest.eventDate!);
      eventTime =
          TimeOfDay.fromDateTime(DateTime.parse(modificationRequest.eventDate!));
    }
    if (modificationRequest.expirationDate != null) {
      expiratioDate = DateTime.parse(modificationRequest.expirationDate!);
    }
    for (int i = 0; i < eventTypes.length; i++) {
      if (modificationRequest.type == eventTypes[i]) {
        eventType = eventTypes[i];
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    role = pendoState.role;
    isDraft = widget.opportunity.status?.toLowerCase() == 'draft';
    return BlocListener<CancelRequestBloc, CancelRequestState>(
      listener: (context, state) {
        if (state is CancelRequestLoadingState) {}
        if (state is CancelRequestSuccessState) {
          final _bloc = BlocProvider.of<GetMyCreationsBloc>(context);
          _bloc.add(GetMyCreationsFetchEvent());
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        if (state is CancelRequestFailureState) {}
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<ModificationDetailBloc, ModificationDetailState>(
            builder: (context, state) {
              if (state is FetchModificationDetailLoadingState) {
                print('loading');
                return _getLoadingIndicator();
              }
              if (state is FetchModificationDetailSuccessState) {
                print('sdfsdf');
                final modification = state.modification.modificationDetail;
                loadData(modification);
                return SafeArea(
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          topRow(),
                          SizedBox(height: 20),
                          body(),
                          // cancelRequest(),
                          buttonRow(),
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                );
              }
              else if (state is FetchModificationDetailFailureState) {
                print('GetRecipientsFailure ${state.error}');
              }
              return _failedStateResponseWidget();
            },
          ),
        ),
      ),
    );
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomPaletteLoader()),
    );
  }

  Widget _failedStateResponseWidget() {
    return Container(
      child: Center(
        child: Text(
          'Something went wrong',
          style: TextStyle(color: defaultDark),
        ),
      ),
    );
  }

  Widget topRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: SvgPicture.asset(
                'images/left_arrow.svg',
                height: 20,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Modification Request',
            style: robotoTextStyle.copyWith(
                fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget body() {
    final getRecipientState = BlocProvider.of<GetRecipientsBloc>(context).state;
    return AbsorbPointer(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EventTypeDropDownMenu(
                    errorDropdown: errorEventDropdown,
                    onChanged: (newValue) {
                      setState(() {
                        eventType = newValue ?? 'Event Type';
                        errorEventDropdown = false;
                      });
                    },
                    selectedValue: eventType,
                    items: eventTypes),
                SizedBox(height: 14),
                CommonTextFieldOpportunity(
                  hintText: 'Event title',
                  imagePath: 'event_title',
                  inputController: eventTitleController,
                  errorFlag: errorTitle,
                  validFlag: true,
                ),
                SizedBox(height: 14),
                CommonTextFieldOpportunity(
                  hintText: 'Enter Venue',
                  imagePath: 'event_venue',
                  inputController: eventVenueController,
                  errorFlag: errorVenue,
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    DatePickerOpportunity(
                      onDateSelected: (newDate) {
                        setState(() {
                          eventDate = newDate;
                        });
                      },
                      errorFlag: errorDate,
                      initialDate: eventDate,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.125),
                    TimePickerOpportunity(
                      onTimeChanged: (newTime) {
                        setState(() {
                          eventTime = newTime;
                        });
                      },
                      errorflag: errorTime,
                      initialTime: eventTime,
                    ),
                  ],
                ),
                SizedBox(height: 14),
                CommonTextFieldOpportunity(
                  hintText: 'Enter website Link',
                  imagePath: 'link',
                  inputController: weblinkController,
                  errorFlag: errorWeblink,
                  inputType: TextInputType.url,
                ),
                SizedBox(height: 14),
                CommonTextFieldOpportunity(
                  hintText: 'Enter Phone Number',
                  imagePath: 'phone_outline',
                  inputController: phoneController,
                  errorFlag: errorPhone,
                  inputType: TextInputType.phone,
                ),
                SizedBox(height: 14),
                CommonTextAreaOpportunity(
                  hintText: 'Enter Description',
                  controller: eventDescriptionController,
                  errorFlag: errorDescription,
                ),
                SizedBox(height: 14),
                role.toLowerCase() != 'student'
                    ? Column(
                  children: [
                    Text('Who do you want to create this event for?',
                        style: robotoTextStyle.copyWith(
                            fontSize: 17.5, fontWeight: FontWeight.w700)),
                    SizedBox(height: 15),
                    IgnorePointer(
                      ignoring: !isRecipientsListEnabled,
                      child: SelectRecipientButton(
                        errorFlag: errorRecipients,
                        recipientsList: recipientsList,
                        sendToProgramSelected: (isSendToProgramSelected) {
                          print(
                              'isSendToProgramSelected: $isSendToProgramSelected');
                          _isSendToProgramSelected =
                              isSendToProgramSelected;
                          setState(() {});
                        },
                        isSendToProgramSelectedFlag:
                        _isSendToProgramSelected,
                        isLoading:
                        getRecipientState is GetRecipientsLoadingState,
                        onRecipientSelected: (selectedRecipients) {
                          setState(() {
                            _selectedRecipientsList = selectedRecipients;
                            errorRecipients = false;
                          });
                          if (selectedRecipients.isEmpty) {
                            setState(() {
                              selectedRecipientsName = '';
                            });
                            return;
                          }
                          selectedRecipientsName = '';
                          _selectedRecipientsList = selectedRecipients;
                          for (var i = 0;
                          i < _selectedRecipientsList.length;
                          i++) {
                            if (i == _selectedRecipientsList.length - 1) {
                              selectedRecipientsName +=
                                  _selectedRecipientsList[i]
                                      .name;
                            } else {
                              selectedRecipientsName +=
                                  _selectedRecipientsList[i]
                                      .name +
                                      ', ';
                            }
                          }
                          setState(() {});
                        },
                        selectedRecipientsTitle: selectedRecipientsName,
                        selectedRecipients: _selectedRecipientsList,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                )
                    : Container(),
                SizedBox(height: 20),
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
                          expiratioDate = newDate;
                        });
                      },
                      errorFlag: errorExpiratioDate,
                      initialDate: expiratioDate,
                      isExprireDate: true,
                    ),
                  ],
                ),
                SizedBox(height: 14),
              ])),
    );
  }

  Widget cancelRequest({required Function onPressed}) {
    return Container(
      height: 40,
      child: BlocBuilder<EditOpportunityBloc, EditOpportunityState>(
          builder: (context, state) {
            return IgnorePointer(
              ignoring: state is EditOpportunityLoadingState,
              child: GestureDetector(
                onTap: () {
                  onPressed();
                },
                child: state is EditOpportunityLoadingState
                    ? Center(
                  child: SpinKitChasingDots(
                    color: red,
                    size: 20,
                  ),
                )
                    : Container(
                  child: Row(children: [
                    Text('CANCEL REQUEST',
                        style: robotoTextStyle.copyWith(
                            color: red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ]),
                ),
              ),
            );
          }),
    );
  }

  Widget buttonRow() {
    return Container(
      height: 60,
      width: 214,
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
          cancelRequest(onPressed: () {
              _showAlert(
                  alertType: OpportunityAlertsType.cancelModification,
                  actionType: OpportunityActionType.opportunity,
                  onYesTap: () {
                    print('yes');
                    Navigator.pop(context);
                    BlocProvider.of<CancelRequestBloc>(context).add(CancelModificationRequestEvent(opportunityId: widget.opportunity.id));
                    _cancelRequest();

                  });
          }),
        ],
      ),
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
  
  void _cancelRequest() {

  }
}
