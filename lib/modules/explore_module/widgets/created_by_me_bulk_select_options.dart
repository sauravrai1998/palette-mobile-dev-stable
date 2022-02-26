import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/services/explore_pendo_repo.dart';
import 'package:palette/utils/konstants.dart';

// ignore: must_be_immutable
class CreatedByMeBulkSelectOptions extends StatelessWidget {
  final List<OppCreatedByMeModel> oppCreatedByMeList;
  final Function onClearTap;
  final Function(OpportunityVisibility) onHideTap;
  final Function onDeactivateTap;
  final Function onShareTap;

  CreatedByMeBulkSelectOptions({
    Key? key,
    required this.oppCreatedByMeList,
    required this.onClearTap,
    required this.onHideTap,
    required this.onDeactivateTap,
    required this.onShareTap,
  }) : super(key: key);

  List<OppCreatedByMeModel> selectedList = [];

  @override
  Widget build(BuildContext context) {
    selectedList =
        oppCreatedByMeList.where((element) => element.isSelected).toList();
    return Container(
      // height: 170,
      width: 160,
      decoration: BoxDecoration(
        color: uploadIconButtonColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'Options',
                  style: roboto700.copyWith(fontSize: 14, color: Colors.white),
                ),
                SizedBox(height: 4),
                Container(
                  width: 28,
                  height: 1.6,
                  color: Colors.white,
                ),
                if (_isUnhideAndHideAreSelected()) _hideButton(context),
                if (_isDeactivateButtonVisible())
                  _deactivateButton(context: context),
                if (_isSearchVisible(context)) 
                _shareButton()
              ],
            ),
          ),
          _clearSelectionButton()
        ],
      ),
    );
  }

  bool _isDeactivateButtonVisible() {
    bool isVisible = true;
    selectedList.forEach((element) {
      if (element.visibility?.toLowerCase() == 'removed') {
        isVisible = false;
      }
    });
    return isVisible;
  }

  bool _isUnhideAndHideAreSelected() {
    for (var i = 0; i < selectedList.length; i++) {
      if (selectedList[i].visibility?.toLowerCase() == 'removed') {
        return false;
      }
    }
    var _available = selectedList
        .where((element) => element.visibility == 'Available')
        .toList();
    var _hidden = selectedList
        .where((element) => element.visibility == 'Hidden')
        .toList();
    if (_available.length != 0 && _hidden.length != 0) {
      return false;
    }
    return true;
  }

  bool _isSearchVisible(context) {
    String role = BlocProvider.of<PendoMetaDataBloc>(context).state.role;
    var allItemsAvailable = true;
    if (role.toLowerCase() == 'student') {
      return false;
    }
    // print('leng: ${selectedList.length} ${selectedList.first.approvalStatus}');
    selectedList.forEach((element) {
      print('element.approvalStatus: ${element.approvalStatus}');
      if (element.approvalStatus?.toLowerCase() != 'approved') {
        allItemsAvailable = false;
      }
    });
    return allItemsAvailable;
  }

  Widget _shareButton() {
    return GestureDetector(
      onTap: () {
        onShareTap();
      },
      child: Container(
        height: 45,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Share',
                style: robotoTextStyle.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SvgPicture.asset(
                'images/share_icon.svg',
                color: white,
                height: 18,
                width: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _clearSelectionButton() {
    return GestureDetector(
      onTap: () {
        onClearTap();
      },
      child: Container(
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: clearSelectionBackgroundColor.withOpacity(0.12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clear Selection',
              style:
                  robotoTextStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            Icon(
              Icons.delete,
              color: white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget _deactivateButton({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        ///
        ExplorePendoRepo.trackMyCreationBulkDeactivate(
          context: context,
          ids: selectedList.map((e) => e.id).toList(),
        );
        onDeactivateTap();
      },
      child: Container(
        height: 45,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remove',
                style: robotoTextStyle.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SvgPicture.asset('images/deactivate_icon.svg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hideButton(BuildContext context) {
    var _available = selectedList
        .where((element) => element.visibility == 'Available')
        .toList();
    var _hidden = selectedList
        .where((element) => element.visibility == 'Hidden')
        .toList();
    String _text = 'Hide';
    if (_available.length != 0 && _hidden.length == 0) {
      _text = 'Hide';
    } else if (_available.length == 0 && _hidden.length != 0) {
      _text = 'Unhide';
    }
    return GestureDetector(
      onTap: () {
        if (_available.length == 0 && _hidden.length != 0) {
          onHideTap(OpportunityVisibility.Available); //For Hidden to Available
        } else if (_available.length != 0 && _hidden.length == 0) {
          onHideTap(OpportunityVisibility.Hidden); //For Available to Hidden
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Please select only one item"),
          ));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _text,
              style: robotoTextStyle.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SvgPicture.asset('images/hide_eye.svg'),
          ],
        ),
      ),
    );
  }
}
