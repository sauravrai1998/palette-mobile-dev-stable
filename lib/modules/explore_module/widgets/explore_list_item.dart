import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/selected_tick_icon.dart';
import 'package:palette/modules/explore_module/models/explore_list_model.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/konstants.dart';

class ExploreListItem extends StatelessWidget {
  const ExploreListItem({
    Key? key,
    required this.exploreModel,
    required this.eventNumber,
  }) : super(key: key);

  final int eventNumber;
  final ExploreModel exploreModel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Event $eventNumber",
      child: Stack(
        children: [
          Container(
            height: 110,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(15, 12, 14, 7.5),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.all(Radius.circular(11)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: exploreModel.isSelected ? 33 : 18,
                top: 12,
                bottom: 12,
                right: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exploreModel.activity?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: roboto700.copyWith(
                      color: defaultDark,
                      fontSize: 16,
                    ),
                  ),
                  exploreModel.activity?.venue == null
                      ? SizedBox(height: 0)
                      : SizedBox(height: 10),
                  exploreModel.activity?.venue == null
                      ? Container()
                      : Text(
                          exploreModel.activity?.description ?? '',
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
          Positioned(
            right: exploreModel.isSelected ? 30 : 20,
            top: 18,
            child: Container(
              width: 22,
              height: 26,
              child: SvgPicture.asset(
                _getImageStringForEvent(
                    type: exploreModel.activity!.category ?? ''),
                color: defaultDark.withOpacity(0.64),
              ),
            ),
          ),
          Positioned(
            bottom: 18,
            right: 20,
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: defaultDark.withOpacity(0.64),
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  CustomDateFormatter.dateIn_DDMMMYYYY(
                      exploreModel.activity?.startDate ?? ''),
                  style: montserratNormal.copyWith(
                    fontSize: 10,
                    color: defaultDark.withOpacity(0.64),
                  ),
                ),
              ],
            ),
          ),
          exploreModel.isSelected
              ? Positioned(
                  left: 24,
                  top: 24,
                  child: _getStatusIconWhileSelected(),
                )
              : Positioned(
                  left: 4,
                  top: 4,
                  child: _getStatusIcon(),
                ),

          // TIck mark icon
          if (exploreModel.isSelected)
            Positioned(
              right: 6,
              top: 2,
              child: SelectedTickMarkIcon(),
            )
        ],
      ),
    );
  }

  Widget _getStatusIconWhileSelected() {
    if (exploreModel.enrolledEvent) {
      return SvgPicture.asset(
        "images/done_enrolled.svg",
        height: 12,
        width: 12,
        color: uploadIconButtonColor,
      );
    } else if (exploreModel.wishListedEvent) {
      return SvgPicture.asset(
        "images/recommended_by_icon.svg",
        height: 12,
        width: 12,
        color: todoListActiveTab,
      );
    }
    return Container();
  }

  Widget _getStatusIcon() {
    if (exploreModel.enrolledEvent) {
      return CircleAvatar(
        radius: 12,
        backgroundColor: uploadIconButtonColor,
        child: SvgPicture.asset(
          "images/done_enrolled.svg",
          height: 10,
          width: 10,
        ),
      );
    } else if (exploreModel.wishListedEvent) {
      return CircleAvatar(
        radius: 12,
        backgroundColor: todoListActiveTab,
        child: SvgPicture.asset(
          "images/recommended_by_icon.svg",
          height: 10,
          width: 10,
        ),
      );
    }

    return Container();
  }

  Color _getBackgroundColor() {
    if (exploreModel.isSelected) {
      return Colors.white;
    }
    if (exploreModel.enrolledEvent) {
      return lightPurple;
    } else if (exploreModel.wishListedEvent) {
      return lightRed;
    } else {
      return Colors.white;
    }
  }

  String _getImageStringForEvent({required String type}) {
    if (type == 'Event - Arts') {
      return 'images/arts_WM.svg';
    } else if (type == 'Event - Volunteer') {
      return 'images/volunteerWM.svg';
    } else if (type == 'Event - Social') {
      return 'images/social_WM.svg';
    } else if (type == 'Event - Sports') {
      return 'images/todo_sports.svg';
    } else if (type == 'Employment') {
      return 'images/employment.svg';
    } else if (type == 'Education') {
      return 'images/education.svg';
    }else {
      return 'images/genericVM.svg';
    }
  }
}
