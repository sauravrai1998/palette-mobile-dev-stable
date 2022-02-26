import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/explore_module/blocs/my_creations_bloc/my_creations_bulk_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/opportunity_visibility_bloc.dart';
import 'package:palette/modules/explore_module/services/explore_pendo_repo.dart';
import 'package:palette/modules/explore_module/widgets/common_opportunity_alerts.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class RemovalBottomSheet extends StatefulWidget {
  final List<String> opportunityId;
  final bool isBulk;
  final VoidCallback? popCallBack;
  final bool isGlobal;
  const RemovalBottomSheet({Key? key,required this.opportunityId,required this.isBulk, this.isGlobal = false, this.popCallBack}) : super(key: key);


  @override
  _RemovalBottomSheetState createState() => _RemovalBottomSheetState();
}

class _RemovalBottomSheetState extends State<RemovalBottomSheet> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: _focusNode.hasFocus ? 0.9: 0.6,
        maxChildSize: 0.95, // full screen on scroll
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
        return  Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: BlocListener<MyCreationsBlukBloc, MyCreationsBulkState>(
                listener: (context, state) {
                  if (state is MyCreationsBulkSuccessState) {
                    Navigator.of(context).pop();
                  }
                },
                child:
                    BlocListener<OpportunityVisibilityBloc, OpportunityVisibilityState>(
                  listener: (context, state) {
                    if (state is OpportunityVisibilitySuccessState) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: BlocBuilder<MyCreationsBlukBloc, MyCreationsBulkState>(
                      builder: (context, myBlocState) {
                    if (myBlocState is MyCreationsBulkLoadingState) {
                      isLoading = true;
                    }
                    if (myBlocState is MyCreationsBulkSuccessState) {
                      isLoading = false;
                      BlocProvider.of<OpportunityVisibilityBloc>(context)
                          .add(SetOpportunityVisibilityToInitEvent());
                    }
                    if (myBlocState is MyCreationsBulkFailedState) {
                      isLoading = false;
                      Helper.showToast('Opportunity Visibility Updated Failed');
                    }
                    return BlocBuilder<OpportunityVisibilityBloc,
                        OpportunityVisibilityState>(builder: (context, blocState) {
                      if (blocState is OpportunityVisibilityLoadingState) {
                        isLoading = true;
                      }
                      if (blocState is OpportunityVisibilitySuccessState) {
                        Helper.showToast('${blocState.message}');
                        isLoading = false;
                        BlocProvider.of<OpportunityVisibilityBloc>(context)
                            .add(SetOpportunityVisibilityToInitEvent());
                      }
                      if (blocState is OpportunityVisibilityErrorState) {
                        isLoading = false;
                        Helper.showToast('Opportunity Visibility Updated Failed');
                        print(
                            'Opportunity Visibility Updated Failed ${blocState.error}');
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 4),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  SvgPicture.asset(
                                    'images/paletteimage.svg',
                                    height: 140,
                                    width: 140,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Oh no!',
                                    style: robotoTextStyle.copyWith(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.clear_circled,
                                    color: red,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please share the reason for removal.',
                            style: roboto700.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We will notify users who have already enrolled to these opportunities.',
                            style: robotoTextStyle.copyWith(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: _focusNode.hasFocus ? 120: 140,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 4, bottom: 8),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 2,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _textEditingController,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Describe your reason... (optional)',
                                hintStyle: robotoTextStyle.copyWith(
                                    fontSize: 16, color: Colors.grey),
                              ),
                              onTap: () {
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 50,
                            width: 240,
                            decoration: BoxDecoration(
                              color: defaultDark,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 2,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: isLoading
                                ? Center(
                                    child: SpinKitChasingDots(
                                        color: Colors.white, size: 20))
                                : TextButton(
                                    onPressed: () {
                                      widget.isGlobal
                                          ? _showAlert(
                                              alertType: OpportunityAlertsType
                                                  .removalRequest,
                                              actionType:
                                                  OpportunityActionType.opportunity,
                                              onYesTap: () {
                                                print('yes');
                                                Navigator.pop(context);
                                                removeOpportunity(context);
                                              })
                                          : _showAlert(
                                              alertType:
                                                  OpportunityAlertsType.remove,
                                              actionType:
                                                  OpportunityActionType.opportunity,
                                              onYesTap: () {
                                                print('yes');
                                                Navigator.pop(context);
                                                removeOpportunity(context);
                                              });
                                    },
                                    child: Text(
                                      'SUBMIT',
                                      style: roboto700.copyWith(
                                        color: white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    });
                  }),
                ),
              ),
            ),
        );
      }
    );
  }

  void removeOpportunity(BuildContext context) {
    /// Pendo log
    ///
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    ExplorePendoRepo.trackBulkRemoveInMyCreationPage(
        pendoState: pendoState, opportunityIds: widget.opportunityId);

    BlocProvider.of<MyCreationsBlukBloc>(context).add(
        BulkDeleteMyCreationsEvent(
            eventIds: widget.opportunityId,
            message: _textEditingController.text));
    Navigator.of(context).pop();
    if (widget.popCallBack != null) {
      widget.popCallBack!();
    }
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
}
