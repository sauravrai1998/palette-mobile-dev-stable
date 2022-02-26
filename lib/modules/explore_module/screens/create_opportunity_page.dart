import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/create_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/get_recipients_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/save_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/services/explore_pendo_repo.dart';
import 'package:palette/modules/explore_module/widgets/common_datepicker_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/common_opportunity_alerts.dart';
import 'package:palette/modules/explore_module/widgets/common_textbox_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/common_textfield_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/common_timepicker_opportunity.dart';
import 'package:palette/modules/explore_module/widgets/event_type_dropdown.dart';
import 'package:palette/modules/explore_module/widgets/select_recipients_button.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class CreateOpportunityPage extends StatefulWidget {
  CreateOpportunityPage({Key? key}) : super(key: key);

  @override
  _CreateOpportunityPageState createState() => _CreateOpportunityPageState();
}

class _CreateOpportunityPageState extends State<CreateOpportunityPage> {
  var eventTitleController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  var phoneController = TextEditingController();
  var weblinkController = TextEditingController();
  var eventVenueController = TextEditingController();
  DateTime? eventDate;
  DateTime? expiratioDate;
  TimeOfDay? eventTime;
  String eventType = 'Event Type';

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
  bool isLoading = false;

  //network DATA
  List<ContactsData> recipientsList = [];
  bool isRecipientsListEnabled = false;
  bool _isSendToProgramSelected = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() { });
    eventTitleController.addListener(() {
      setState(() {
        if(eventTitleController.text.isEmpty)
        {}
        else
          errorTitle = false;
      });
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    role = pendoState.role;
    return BlocBuilder<GetContactsBloc, GetContactsState>(
      builder: (context, state) {
        if (state is GetContactsLoadingState) {}
        if (state is GetContactsSuccessState) {
          print('sdfsdf');
          List<ContactsData> recipientsData = state.contactsResponse.contacts;
          if (!isRecipientsListEnabled) {
            recipientsData.forEach((element) {
              if (element.canCreateOpportunity != null && element.canCreateOpportunity) {
                element.isSelected = false;
                recipientsList.add(element);
              }
            });
          }
          isRecipientsListEnabled = true;
        }
        if (state is GetContactsFailureState) {
          print('GetRecipientsFailure ${state.errorMessage}');
          isRecipientsListEnabled = true;
        }

        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              controller: _scrollController,
              child: BlocListener<SaveOpportunityBloc, SaveOpportunityState>(
                listener: (context, state) {
                  if (state is SaveOpportunitySuccessState) {
                    Navigator.pop(context);
                    Helper.showToast('Opportunity saved to draft');
                  } else if (state is SaveOpportunityFailureState) {
                    Navigator.pop(context);
                    Helper.showToast(state.errorMessage);
                  } else if (state is SaveOpportunityLoadingState) {
                    isLoading = true;
                  }
                },
                child: BlocListener<CreateOpportunityBloc,
                        CreateOpportunityState>(
                    listener: (context, state) {
                      if (state is CreateOpportunitySuccessState) {
                        Navigator.pop(context);
                        Helper.showToast('Opportunity created successfully');
                      } else if (state is CreateOpportunityFailureState) {
                        Helper.showBottomSnackBar(state.errorMessage, context);
                      } else if (state is CreateOpportunityLoadingState) {
                        isLoading = true;
                      }
                    },
                    child: Column(
                      children: [
                        topRow(),
                        SizedBox(height: 20),
                        body(pendoState),
                        // submitButton(),
                        buttonRow(),
                        SizedBox(height: 20)
                      ],
                    )),
              ),
            ),
          ),
        );
      },
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
            'Create an opportunity',
            style: robotoTextStyle.copyWith(
                fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget body(PendoMetaDataState pendostate) {
    final getRecipientState = BlocProvider.of<GetRecipientsBloc>(context).state;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                    "Arts",
                    "Social Events",
                    "Volunteering",
                    "Sports",
                    "Education",
                    "Employment"
                  ]),
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
                  ? Builder(
                    builder: (context) {
                      return Column(
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
                                instituteName: pendostate.instituteName,
                                instituteImage: pendostate.instituteLogo,
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
                                          _selectedRecipientsList[i].name;
                                    } else {
                                      selectedRecipientsName +=
                                          _selectedRecipientsList[i].name + ', ';
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
                        );
                    }
                  )
                  : Container(),
              SizedBox(height: 20),
            ]));
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
                              color: neoGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 5),
                      Icon(Icons.done_all, color: neoGreen, size: 20)
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
      width: 300,
      //margin: EdgeInsets.only(left: 10),
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
            if (isValid()) {
              _showAlert(
                  alertType: OpportunityAlertsType.create,
                  actionType: OpportunityActionType.opportunity,
                  onYesTap: () {
                    print('yes');
                    Navigator.pop(context);
                    _submitOpporunity();
                  });
            }
          }),
          SizedBox(width: 10),
          saveButton(onPressed: () {
            if (_saveVaildation()) {
              _showAlert(
                  alertType: OpportunityAlertsType.save,
                  actionType: OpportunityActionType.opportunity,
                  onYesTap: () {
                    print('yes');
                    Navigator.pop(context);
                    _saveOpporunity();
                  });
            }
          }),
        ],
      ),
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

  bool isValid() {
    if (eventType == 'Event Type') {
      _scrollToTop();
      setState(() {
        errorEventDropdown = true;
      });
      return false;
    }
    if (eventTitleController.text.isEmpty || eventTitleController.text == '') {
      errorTitle = true;
      _scrollToTop();
      setState(() {});
      return false;
    }
    if (expiratioDate == null) {
      errorExpiratioDate = true;
      _scrollToTop();
      setState(() {});
      return false;
    }
    if (weblinkController.text != ' ' && weblinkController.text.isNotEmpty) {
      if (Helper.validateWebSite(weblinkController.text) == false) {
        Helper.showCustomSnackBar(
          'Please enter valid website link',
          context,
        );
        errorWeblink = true;
        setState(() {});
        return false;
      }
    }
    if (_isSendToProgramSelected) {
      setState(() {
        errorRecipients = false;
      });
      return true;
    }
    if (_selectedRecipientsList.isEmpty && role.toLowerCase() != 'student') {
      setState(() {
        errorRecipients = true;
      });
      return false;
    }

    return true;
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

  bool _saveVaildation() {
    if ((eventTitleController.text.isEmpty ||
        eventTitleController.text == '')) {
      errorTitle = true;
      _scrollToTop();
      setState(() {});
      return false;
    }
    if (eventType == 'Event Type') {
      errorEventDropdown = true;
      _scrollToTop();
      setState(() {});
      return false;
    }
    setState(() {});
    return true;
  }

  void _submitOpporunity() {
    final _eventTime = eventTime ?? TimeOfDay(hour: 00, minute: 00);
    List<String> _assignesId =
        _selectedRecipientsList.map((recipient) => recipient.sfid).toList();
    OpportunitiesModel _opportunityModel = OpportunitiesModel(
      description: eventDescriptionController.text.isEmpty
          ? ' '
          : eventDescriptionController.text,
      eventDateTime: eventDate != null
          ? DateTime(eventDate!.year, eventDate!.month, eventDate!.day,
              _eventTime.hour, _eventTime.minute)
          : null,
      eventType: _getEventTypeString(type: eventType),
      eventTitle: eventTitleController.text,
      phone: phoneController.text == '' ? ' ' : phoneController.text,
      website: weblinkController.text == '' ? ' ' : weblinkController.text,
      venue: eventVenueController.text == '' ? ' ' : eventVenueController.text,
      expirationDateTime: expiratioDate ?? null,
    );

    /// Pendo log
    ///
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    ExplorePendoRepo.trackCreateOpportunity(
      title: _opportunityModel.eventTitle,
      type: _opportunityModel.eventType,
      pendoState: pendoState,
      isSendToProgramSelectedFlag: _isSendToProgramSelected,
    );

    role.toLowerCase() == 'student'
        ? BlocProvider.of<CreateOpportunityBloc>(context).add(
            CreateOpportunityForStudentEvent(
                opportunitiesInfoDto: _opportunityModel))
        : BlocProvider.of<CreateOpportunityBloc>(context).add(
            CreateOpportunityForAllRolesEvent(
                opportunitiesInfoDto: _opportunityModel,
                assigneesId: _assignesId,
                isGlobal: _isSendToProgramSelected,
                context: context));
  }

  void _saveOpporunity() {
    final _eventTime = eventTime ?? TimeOfDay(hour: 00, minute: 00);
    List<String> _assignesId =
        _selectedRecipientsList.map((recipient) => recipient.sfid).toList();
    OpportunitiesModel _opportunityModel = OpportunitiesModel(
      description: eventDescriptionController.text.isEmpty
          ? ' '
          : eventDescriptionController.text,
      eventDateTime: eventDate != null
          ? DateTime(eventDate!.year, eventDate!.month, eventDate!.day,
              _eventTime.hour, _eventTime.minute)
          : null,
      eventType: _getEventTypeString(type: eventType),
      eventTitle: eventTitleController.text,
      phone: phoneController.text == '' ? ' ' : phoneController.text,
      website: weblinkController.text == '' ? ' ' : weblinkController.text,
      venue: eventVenueController.text == '' ? ' ' : eventVenueController.text,
      expirationDateTime: expiratioDate ?? null,
    );

    /// Pendo log
    ///
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    ExplorePendoRepo.trackSaveDraftOpportunity(
      title: _opportunityModel.eventTitle,
      type: _opportunityModel.eventType,
      pendoState: pendoState,
      isSendToProgramSelectedFlag: _isSendToProgramSelected,
    );

    role.toLowerCase() == 'student'
        ? BlocProvider.of<SaveOpportunityBloc>(context).add(
            SaveOpportunityForStudentEvent(
                opportunitiesModel: _opportunityModel))
        : BlocProvider.of<SaveOpportunityBloc>(context).add(
            SaveOpportunityForOtherRolesEvent(
                opportunitiesModel: _opportunityModel,
                assigneesId: _assignesId,
                isGlobal: _isSendToProgramSelected,
                context: context));
  }

  String _getEventTypeString({required String type}) {
    if (type == 'Arts') {
      return 'Event - Arts';
    } else if (type == 'Volunteering') {
      return 'Event - Volunteer';
    } else if (type == 'Social Events') {
      return 'Event - Social';
    } else if (type == 'Sports') {
      return 'Event - Sports';
    } else if (type == 'Employment') {
      return 'Employment';
    } else if (type == 'Education') {
      return 'Education';
    } else {
      return 'Other';
    }
  }
}
