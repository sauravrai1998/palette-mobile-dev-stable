import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/explore_module/blocs/get_my_creations_bloc/get_my_creations_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/edit_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/get_recipients_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/save_opportunity_bloc.dart';
import 'package:palette/modules/explore_module/models/create_opportunity_model.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
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

class EditOpportunityPage extends StatefulWidget {
  final OppCreatedByMeModel opportunity;
  EditOpportunityPage({required this.opportunity});

  @override
  _EditOpportunityPageState createState() => _EditOpportunityPageState();
}

class _EditOpportunityPageState extends State<EditOpportunityPage> {
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
  bool _isSendToProgramSelected = false;
  bool _isRecipientsloaded = false;
  List<ContactsData> recipientsList = [];
  bool isRecipientsListEnabled = false;
  bool isLoading = false;
  bool isDraft = false;

  void loadData() {
    eventTitleController.text = widget.opportunity.eventName;
    if (widget.opportunity.description != null) {
      eventDescriptionController.text = widget.opportunity.description!;
    }
    if (widget.opportunity.phoneNumber != null &&
        widget.opportunity.phoneNumber != 'phone') {
      phoneController.text = widget.opportunity.phoneNumber!;
    }
    if (widget.opportunity.website != null &&
        widget.opportunity.website != 'website') {
      weblinkController.text = widget.opportunity.website!;
    }
    if (widget.opportunity.venue != null) {
      eventVenueController.text = widget.opportunity.venue!;
    }
    if (widget.opportunity.eventDate != null) {
      eventDate = DateTime.parse(widget.opportunity.eventDate!);
      eventTime =
          TimeOfDay.fromDateTime(DateTime.parse(widget.opportunity.eventDate!));
    }
    if (widget.opportunity.expirationDate != null) {
      expiratioDate = DateTime.parse(widget.opportunity.expirationDate!);
    }
    for (int i = 0; i < eventTypes.length; i++) {
      if (widget.opportunity.type == eventTypes[i]) {
        eventType = eventTypes[i];
      }
    }
    if (widget.opportunity.opportunityScope != null) {
      if (widget.opportunity.opportunityScope == 'Global') {
        print('global');
        _isSendToProgramSelected = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    print('widget.opportunity.type ${widget.opportunity.type}');
  }

  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    role = pendoState.role;
    isDraft = widget.opportunity.status?.toLowerCase() == 'draft';
    return BlocBuilder<GetContactsBloc, GetContactsState>(
      builder: (context, state) {
        if (state is GetContactsLoadingState) {}
        if (state is GetContactsSuccessState) {
          print('sdfsdf');
          List<ContactsData> recipientsData = state.contactsResponse.contacts;
          if (!isRecipientsListEnabled) {
            recipientsData.forEach((element) {
              if (element.canCreateOpportunity) {
                element.isSelected = false;
                recipientsList.add(element);
              }
            });
          }
          isRecipientsListEnabled = true;
          //loading Assigned Recipients
          if (!_isSendToProgramSelected) {
            if (!_isRecipientsloaded) {
              if (widget.opportunity.assignees != null) {
                List<String> selectedRecipientsIds =
                    widget.opportunity.assignees!;
                recipientsList.forEach((element) {
                  if (selectedRecipientsIds.contains(element.sfid)) {
                    element.isSelected = true;
                    if (!_selectedRecipientsList.contains(element)) {
                      _selectedRecipientsList.add(element);
                    }
                  }
                  selectedRecipientsName =
                      _selectedRecipientsList.map((e) => e.name).join(', ');
                });
              }
              _isRecipientsloaded = true;
            }
          }
        }
        if (state is GetContactsFailureState) {
          print('GetRecipientsFailure ${state.errorMessage}');
          isRecipientsListEnabled = true;
        }

        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: BlocListener<SaveOpportunityBloc, SaveOpportunityState>(
                listener: (context, state) {
                  if (state is SaveOpportunitySuccessState) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Helper.showToast('Opportunity Saved successfully');
                    final _bloc = BlocProvider.of<GetMyCreationsBloc>(context);
                    _bloc..add(GetMyCreationsFetchEvent());
                  } else if (state is SaveOpportunityFailureState) {
                    Navigator.pop(context);
                    Helper.showToast(state.errorMessage);
                  } else if (state is SaveOpportunityLoadingState) {
                    isLoading = true;
                  }
                },
                child: BlocListener<EditOpportunityBloc, EditOpportunityState>(
                    listener: (context, state) {
                      if (state is EditOpportunitySuccessState) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        final _bloc =
                            BlocProvider.of<GetMyCreationsBloc>(context);
                        _bloc.add(GetMyCreationsFetchEvent());
                        // if (isDraft) {
                        //   _updateDraftOpportunityToLive();
                        // }
                      } else if (state is EditOpportunityFailureState) {
                        Helper.showBottomSnackBar(state.errorMessage, context);
                      } else if (state is EditOpportunityLoadingState) {
                        isLoading = true;
                      }
                    },
                    child: Column(
                      children: [
                        topRow(),
                        SizedBox(height: 20),
                        body(),
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
            'Edit an opportunity',
            style: robotoTextStyle.copyWith(
                fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget body() {
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
                  items: eventTypes),
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
                    )
                  : Container(),
              SizedBox(height: 20),
            ]));
  }

  Widget submitButton({required Function onPressed}) {
    return Container(
      width: 90,
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
                      color: green,
                      size: 20,
                    ),
                  )
                : Container(
                    width: 40,
                    child: Row(children: [
                      Text(isDraft ? 'SUBMIT' : 'UPDATE',
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
          // SizedBox(width: 5),
          // cancelButton(onPressed: () {
          //   _showAlert(
          //       alertType: OpportunityAlertsType.delete,
          //       actionType: OpportunityActionType.saveToDraft,
          //       onYesTap: () {
          //         print('yes');
          //         Navigator.pop(context);
          //         Navigator.pop(context);
          //       });
          // }),
          // SizedBox(width: 10),
          submitButton(onPressed: () {
            if (isValid()) {
              _isSendToProgramSelected
                  ? _showAlert(
                      alertType: isDraft
                          ? OpportunityAlertsType.create
                          : OpportunityAlertsType.modification,
                      actionType: OpportunityActionType.opportunity,
                      onYesTap: () {
                        print('yes');
                        Navigator.pop(context);
                        isDraft
                            ? _updateDraftOpportunityToLive()
                            : _editOpporunity();
                      })
                  : _showAlert(
                      alertType: isDraft
                          ? OpportunityAlertsType.publishing
                          : OpportunityAlertsType.update,
                      actionType: OpportunityActionType.opportunity,
                      onYesTap: () {
                        print('yes');
                        Navigator.pop(context);
                        isDraft
                            ? _updateDraftOpportunityToLive()
                            : _editOpporunity();
                      });
            }
          }),
          if (isDraft) SizedBox(width: 10),
          if (isDraft)
            saveButton(onPressed: () {
              if (_saveVaildation()) {
                _showAlert(
                    alertType: OpportunityAlertsType.save,
                    actionType: OpportunityActionType.opportunity,
                    onYesTap: () {
                      print('yes');
                      Navigator.pop(context);
                      // Edited for Sprint 2
                      // _editOpporunity();
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
      setState(() {
        errorEventDropdown = true;
      });
      return false;
    }
    if (eventTitleController.text.isEmpty || eventTitleController.text == '') {
      errorTitle = true;
      setState(() {});
      return false;
    }
    if (expiratioDate == null) {
      errorExpiratioDate = true;
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
      setState(() {});
      return false;
    }
    if (eventType == 'Event Type') {
      setState(() {});
      return false;
    }
    setState(() {});
    return true;
  }

  void _editOpporunity() {
    final state = BlocProvider.of<PendoMetaDataBloc>(context).state;

    ExplorePendoRepo.trackEditOpportunity(
      eventId: widget.opportunity.id,
      eventTitle: widget.opportunity.eventName,
      pendoState: state,
      eventScope: _isSendToProgramSelected ? 'Global' : 'Discrete',
    );

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
      eventType: eventType,
      eventTitle: eventTitleController.text,
      phone: phoneController.text == '' ? ' ' : phoneController.text,
      website: weblinkController.text == '' ? ' ' : weblinkController.text,
      venue: eventVenueController.text == '' ? ' ' : eventVenueController.text,
      expirationDateTime: expiratioDate ?? DateTime.now(),
    );
    //role.toLowerCase() == 'student' ||
    !_isSendToProgramSelected
        ? BlocProvider.of<EditOpportunityBloc>(context)
            .add(EditOpportunityForDiscreteEvent(
            opportunitiesInfoDto: _opportunityModel,
            recipientIds: _assignesId,
            opportunityId: widget.opportunity.id,
          ))
        : BlocProvider.of<EditOpportunityBloc>(context)
            .add(EditOpportunityForGlobalEvent(
            opportunitiesInfoDto: _opportunityModel,
            opportunityId: widget.opportunity.id,
          ));
  }

  void _updateDraftOpportunityToLive() {
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
      eventType: eventType,
      eventTitle: eventTitleController.text,
      phone: phoneController.text == '' ? ' ' : phoneController.text,
      website: weblinkController.text == '' ? ' ' : weblinkController.text,
      venue: eventVenueController.text == '' ? ' ' : eventVenueController.text,
      expirationDateTime: expiratioDate ?? DateTime.now(),
    );
    BlocProvider.of<EditOpportunityBloc>(context).add(
        EditDraftOpporunityToLiveEvent(
            opportunityId: widget.opportunity.id,
            opportunitiesInfoDto: _opportunityModel,
            recipientIds: _assignesId,
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
      eventType: eventType,
      eventTitle: eventTitleController.text,
      phone: phoneController.text == '' ? ' ' : phoneController.text,
      website: weblinkController.text == '' ? ' ' : weblinkController.text,
      venue: eventVenueController.text == '' ? ' ' : eventVenueController.text,
      expirationDateTime: expiratioDate != null ? expiratioDate : null,
    );
    BlocProvider.of<SaveOpportunityBloc>(context).add(
        SaveEditedOpportunityEvent(
            opportunityId: widget.opportunity.id,
            opportunitiesModel: _opportunityModel,
            assigneesId: _assignesId,
            isGlobal: _isSendToProgramSelected,
            context: context));
  }
}
