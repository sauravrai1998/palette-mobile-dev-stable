import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/selected_tick_icon.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/konstants.dart';

class OppCreatedByMeListItem extends StatelessWidget {
  final OppCreatedByMeModel oppCreatedByMeModel;

  const OppCreatedByMeListItem({
    Key? key,
    required this.oppCreatedByMeModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 110,
          width: MediaQuery.of(context).size.width,
          margin: oppCreatedByMeModel.isSelected
              ? EdgeInsets.fromLTRB(34, 12, 28, 7.5)
              : EdgeInsets.fromLTRB(18, 12, 18, 7.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(11)),
            boxShadow: oppCreatedByMeModel.isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(-2, 8), // changes position of shadow
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18,
              top: 12,
              bottom: 12,
              right: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (oppCreatedByMeModel.approvalStatus != null &&
                    oppCreatedByMeModel.visibility != null)
                  _getStatusTextWidget(),
                // Row(
                //   children: [
                //     _getStatusDotWidget(),
                //     SizedBox(width: 4),
                //     _getStatusTextWidget(),
                //   ],
                // ),
                SizedBox(height: 4),
                Text(
                  oppCreatedByMeModel.eventName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: roboto700.copyWith(
                    color: defaultDark,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 6),
                if (oppCreatedByMeModel.description != null)
                  Text(
                    oppCreatedByMeModel.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: montserratNormal.copyWith(
                      fontSize: 10,
                      color: defaultDark.withOpacity(0.64),
                    ),
                  ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        oppCreatedByMeModel.isSelected
            ? Positioned(
                right: 35,
                top: 24,
                child: Container(
                  width: 22,
                  height: 26,
                  child: SvgPicture.asset(
                    _getImageStringForEvent(type: oppCreatedByMeModel.type),
                    color: defaultDark.withOpacity(0.64),
                  ),
                ),
              )
            : Positioned(
                right: 25,
                top: 18,
                child: Container(
                  width: 22,
                  height: 26,
                  child: SvgPicture.asset(
                    _getImageStringForEvent(type: oppCreatedByMeModel.type),
                    color: defaultDark.withOpacity(0.64),
                  ),
                ),
              ),
        if (oppCreatedByMeModel.isSelected)
          Positioned(
            right: 10,
            top: 6,
            child: SelectedTickMarkIcon(),
          ),
        if (_getEventDateString() != '')
          Positioned(
            bottom: oppCreatedByMeModel.isSelected ? 20 : 18,
            right: oppCreatedByMeModel.isSelected ? 32 : 25,
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: defaultDark.withOpacity(0.64),
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  _getEventDateString(),
                  style: montserratNormal.copyWith(
                    fontSize: 10,
                    color: defaultDark.withOpacity(0.64),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getEventDateString() {
    var _date = CustomDateFormatter.dateIn_DDMMMYYYY(
        oppCreatedByMeModel.eventDate ?? '');
    if (_date == '' || _date.contains('1970')) {
      return '';
    }
    return _date;
  }

  Widget _getStatusDotWidget() {
    var color = white;
    if (oppCreatedByMeModel.approvalStatus?.toLowerCase() == 'rejected' ||
        oppCreatedByMeModel.visibility?.toLowerCase() == 'removed') {
      color = red;
    } else if (oppCreatedByMeModel.approvalStatus?.toLowerCase() == 'draft' ||
        oppCreatedByMeModel.visibility?.toLowerCase() == 'hidden') {
      color = Colors.grey;
    } else if (oppCreatedByMeModel.approvalStatus?.toLowerCase() ==
        'approved') {
      color = green;
    } else {
      color = uploadIconButtonColor;
    }

    return Container(
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _getStatusTextWidget() {
    var _color = uploadIconButtonColor;
    var _text = 'IN REVIEW';

    if (oppCreatedByMeModel.visibility?.toLowerCase() == 'removed') {
      _text = 'REMOVED';
      _color = red;
    } else if (oppCreatedByMeModel.visibility?.toLowerCase() == 'hidden') {
      _text = 'HIDDEN';
      _color = Colors.grey;
    } else if (oppCreatedByMeModel.visibility?.toLowerCase() == 'available') {
      if (oppCreatedByMeModel.approvalStatus?.toLowerCase() == 'approved') {
        if (oppCreatedByMeModel.opportunityScope?.toLowerCase() == 'global') {
          _text = 'APPROVED';
          _color = green;
        } else {
          _text = 'AVAILABLE';
          _color = green;
        }
      } else if (oppCreatedByMeModel.approvalStatus?.toLowerCase() ==
          'rejected') {
        _text = 'REJECTED';
        _color = red;
      } else if (oppCreatedByMeModel.approvalStatus?.toLowerCase() == 'draft') {
        _text = 'DRAFT';
        _color = Colors.grey;
      } else if (oppCreatedByMeModel.approvalStatus
              ?.toLowerCase()
              .contains('review') ??
          false) {
        print('printing in elses: ${oppCreatedByMeModel.approvalStatus}');
        _text = 'IN REVIEW';
        _color = red;
      } else {
        _text = 'AVAILABLE';
        _color = green;
      }
    }
    return Row(
      children: [
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        SizedBox(width: 4),
        Text(
          '$_text',
          style: robotoTextStyle.copyWith(color: _color, fontSize: 12),
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
    } else if (type == 'Employment') {
      return 'images/employment.svg';
    } else if (type.startsWith('Education')) {
      return "images/education_WM.svg";
    } else {
      return 'images/genericVM.svg';
    }
  }
}
