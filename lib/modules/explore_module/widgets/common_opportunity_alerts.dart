import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_components/common_components_link.dart';

class OpportunityAlerts extends StatelessWidget {
  final OpportunityAlertsType type;
  final OpportunityActionType actionType;
  final Function onYesTap;
  OpportunityAlerts(
      {required OpportunityAlertsType type,
      required OpportunityActionType actionType
      ,required Function onYesTap})
      : this.type = type,
        this.actionType = actionType,
        this.onYesTap = onYesTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              print('Tapped');
              Navigator.pop(context);
            },
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent),
          ),
          Center(
            child: Container(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                height: 200,
                width: 330,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _actionTypeWidget(),
                          SizedBox(width: 10),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _alertTypeHeading(),
                                SizedBox(height: 4),
                                _alertTitle()
                              ])
                        ],
                      ),
                      SizedBox(height: 18),
                      _alertDescription(),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'CANCEL',
                              style:
                                  roboto700.copyWith(color: red, fontSize: 16),
                            )),
                        TextButton(
                            onPressed: () {
                              onYesTap();
                            },
                            child: Text(
                              'YES',
                              style:
                                  roboto700.copyWith(color: green, fontSize: 16),
                            )),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _actionTypeWidget() {
    late String actionTypeImage;
    late Color actionTypeColor;
    if (actionType == OpportunityActionType.addToTodo) {
      actionTypeImage = 'images/todo_black.svg';
      actionTypeColor = purpleBlue;
    } else if (actionType == OpportunityActionType.opportunity) {
      actionTypeImage = 'images/explore_black.svg';
      actionTypeColor = red;
    }
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(8),
      child: SvgPicture.asset(
        actionTypeImage,
        color: actionTypeColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }

  Text _alertTypeHeading() {
    late String title;
    late Color color;
    switch (type) {
      case OpportunityAlertsType.create:
        title = 'Creating..';
        color = green;
        break;
      case OpportunityAlertsType.save:
        title = 'Saving..';
        color = defaultDark;
        break;
      case OpportunityAlertsType.delete:
        title = 'Deleting..';
        color = red;
        break;
      case OpportunityAlertsType.update:
        title = 'Updating..';
        color = green;
        break;
      case OpportunityAlertsType.modification:
        title = 'Submitting..';
        color = green;
        break;
      case OpportunityAlertsType.publishing:
        title = 'Publishing..';
        color = green;
        break;
      case OpportunityAlertsType.removalRequest:
        title = 'Submitting..';
        color = red;
        break;
      case OpportunityAlertsType.remove:
        title = 'Removing..';
        color = red;
        break;
      case OpportunityAlertsType.cancelModification:
        title = 'Cancelling..';
        color = red;
        break;
      case OpportunityAlertsType.cancelRemoval:
        title = 'Cancelling..';
        color = red;
        break;
      case OpportunityAlertsType.modificationInReview:
        title = 'Modification Request';
        color = red;
        break;
      case OpportunityAlertsType.removalInReview:
        title = 'Removal Request';
        color = red;
        break;
    }
    return Text(title,
        style: robotoTextStyle.copyWith(
            fontSize: 14, fontWeight: FontWeight.w600, color: color));
  }

  Text _alertTitle() {
    late String title;
    late String _actiontype;
    if (actionType == OpportunityActionType.addToTodo) {
      _actiontype = 'To-Do';
    } else if (actionType == OpportunityActionType.opportunity) {
      _actiontype = 'Opportunity';
    }
    switch (type) {
      case OpportunityAlertsType.create:
        title = 'New  $_actiontype';
        break;
      case OpportunityAlertsType.save:
        title = 'Draft $_actiontype';
        break;
      case OpportunityAlertsType.delete:
        title = 'New $_actiontype';
        break;
      case OpportunityAlertsType.update:
        title = 'Update $_actiontype';
        break;
      case OpportunityAlertsType.modification:
        title = 'Modification Request';
        break;
      case OpportunityAlertsType.publishing:
        title = 'Publish $_actiontype';
        break;
      case OpportunityAlertsType.removalRequest:
        title = 'Removal Request';
        break;
      case OpportunityAlertsType.remove:
        title = '$_actiontype';
        break;
      case OpportunityAlertsType.cancelModification:
        title = 'Modification Request';
        break;
      case OpportunityAlertsType.cancelRemoval:
        title = 'Removal Request';
        break;
      case OpportunityAlertsType.modificationInReview:
        title = 'Already In Review';
        break;
      case OpportunityAlertsType.removalInReview:
        title = 'Already In Review';
        break;
    }
    return Text(title,
        style: robotoTextStyle.copyWith(
            fontSize: 20, fontWeight: FontWeight.w600, color: defaultDark));
  }

  Text _alertDescription() {
    late String desc;
    late String _actiontype;
    if (actionType == OpportunityActionType.addToTodo) {
      _actiontype = 'To-Do';
    } else if (actionType == OpportunityActionType.opportunity) {
      _actiontype = 'Opportunity';
    }
    switch (type) {
      case OpportunityAlertsType.create:
        desc = 'Are you sure you want to create this $_actiontype?';
        break;
      case OpportunityAlertsType.save:
        desc = 'Are you sure you want to save this opportunity to drafts?';
        break;
      case OpportunityAlertsType.delete:
        desc = 'Are you sure you want to delete this new $_actiontype?';
        break;
      case OpportunityAlertsType.update:
        desc = 'Are you sure you want to Update this $_actiontype?';
        break;
      case OpportunityAlertsType.modification:
        desc = 'Are you sure you want to submit a modification request for this $_actiontype?';
        break;
      case OpportunityAlertsType.publishing:
        desc = 'Are you sure you want to publish this $_actiontype?';
        break;
      case OpportunityAlertsType.removalRequest:
        desc = 'Are you sure you want to submit a removal request for this $_actiontype?';
        break;
      case OpportunityAlertsType.remove:
        desc = 'Are you sure you want to remove this $_actiontype?';
        break;
      case OpportunityAlertsType.cancelModification:
        desc = 'Your modification request is in review.\n\nWould you like to CANCEL the Request?';
        break;
      case OpportunityAlertsType.cancelRemoval:
        desc = 'Your removal request is in review.\n\nWould you like to CANCEL the Request?';
        break;
      case OpportunityAlertsType.modificationInReview:
        desc = 'If you submit a removal request now, the existing modification request will be canceled.';
        break;
      case OpportunityAlertsType.removalInReview:
        desc = 'If you submit a modification request now, the existing removal request will be canceled.';
        break;
    }
    return Text(desc,
        style: robotoTextStyle.copyWith(
            fontSize: 16, fontWeight: FontWeight.w500, color: defaultDark));
  }
}

enum OpportunityActionType { addToTodo, opportunity }

enum OpportunityAlertsType { create, save, delete ,update ,modification,
  publishing , remove, removalRequest, cancelModification, cancelRemoval, modificationInReview, removalInReview}


extension OpportunityActionTypeExtension on OpportunityActionType {
  String get value {
    switch (this) {
      case OpportunityActionType.addToTodo:
        return 'To-do';
      case OpportunityActionType.opportunity:
        return 'Opportunity';
    }
  }
}
extension OpportunityALertsTypeExtension on OpportunityAlertsType {
  String get title {
    switch (this) {
      case OpportunityAlertsType.create:
        return 'Create';
      case OpportunityAlertsType.save:
        return 'Save';
      case OpportunityAlertsType.delete:
        return 'Delete';
      case OpportunityAlertsType.update:
        return 'Update';
      case OpportunityAlertsType.modification:
        return 'Modification';
      case OpportunityAlertsType.publishing:
        return 'Publishing';
      case OpportunityAlertsType.removalRequest:
        return 'Removal Request';
      case OpportunityAlertsType.remove:
        return 'Removal';
      case OpportunityAlertsType.cancelModification:
        return 'Cancel Modification';
      case OpportunityAlertsType.cancelRemoval:
        return 'Cancel Removal';
      case OpportunityAlertsType.modificationInReview:
        return 'ModificationInReview';
      case OpportunityAlertsType.removalInReview:
        return 'RemovalInReview';
    }
  }
}