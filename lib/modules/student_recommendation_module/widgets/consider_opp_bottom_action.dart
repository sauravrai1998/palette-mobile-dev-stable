import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/modules/student_recommendation_module/screens/recommendation_detail_screen.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_pendo_repo.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/modules/student_recommendation_module/widgets/role_name_viewer.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsiderOpportunityBottomAction extends StatefulWidget {
  ConsiderOpportunityBottomAction({
    Key? key,
    required this.recommendation,
    required this.rejectOpportunityCallBack,
    required this.setter,
    required this.role,
    required this.sfid,
    required this.sfuuid,
    required this.otherOptionsClickedCallback,
    required this.otherOptionsClicked,
  }) : super(key: key);

  final RecommendedByData recommendation;
  final RejectOpportunityCallBack rejectOpportunityCallBack;
  final ValueChanged<bool> setter;
  final String sfid;
  final String sfuuid;
  final bool otherOptionsClicked;
  final String role;
  final Function otherOptionsClickedCallback;

  @override
  _ConsiderOpportunityBottomActionState createState() =>
      _ConsiderOpportunityBottomActionState();
}

class _ConsiderOpportunityBottomActionState
    extends State<ConsiderOpportunityBottomAction>
    with TickerProviderStateMixin<ConsiderOpportunityBottomAction> {
  final decoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    color: white,
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 8,
        color: Colors.black.withOpacity(0.08),
      )
    ],
  );

  bool clicked = false;

  void showRecommendedPopup() {
    showGeneralDialog(
      barrierLabel: 'recoomendation_label',
      barrierDismissible: true,
      barrierColor: Color(0x01000000),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return TextScaleFactorClamper(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(0),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                decoration: BoxDecoration(
                  color: defaultDark,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Recommended by,",
                      style: montserratNormal.copyWith(
                          fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 43.8,
                                  childAspectRatio: 1 / 4,
                                  crossAxisSpacing: 5.8,
                                  mainAxisSpacing: 0),
                          itemBuilder: (context, ind) {
                            return NameAndRoleViwer(
                                name: widget
                                    .recommendation.recommendedBy[ind].name,
                                role: widget
                                    .recommendation.recommendedBy[ind].role);
                          },
                          itemCount: widget.recommendation.recommendedBy.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0.2)).animate(anim1),
          child: child,
        );
      },
    ).then((value) {
      setState(() {
        clicked = !clicked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return Container(
        // color: greenDefault,
        alignment: Alignment.topLeft,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _recommendedByButton(pendoState),
              Expanded(child: _addToTodoButton(pendoState)),
              _otherOptions(pendoState),
            ],
          ),
        ),
      );
    });
  }

  Widget _otherOptions(PendoMetaDataState pendoState) {
    return GestureDetector(
      onTap: () {
        widget.otherOptionsClickedCallback();
      },
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: widget.otherOptionsClicked ? defaultDark : white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  ),
                ]),
            child: Center(
              child: SvgPicture.asset(
                'images/Vectorexclamation.svg',
                color: widget.otherOptionsClicked ? white : defaultDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addToTodoButton(PendoMetaDataState pendoState) {
    return GestureDetector(
      onTap: () {
        Helper.showAcceptRejectDialog(
            body: 'Are you sure you want to accept this recommendation?',
            context: context,
            okAction: () async {
              bool result =
                  await RecommendRepository.instance.acceptRecommendation(
                Ids: widget.recommendation.id,
              );
              if (!result) {
                RecommendRepository.instance
                    .rejectRecommendation(id: widget.recommendation.id);
                Navigator.pop(context);

                showDialog(
                    context: context,
                    builder: Helper.showGenericDialog(
                        title: 'Oops...',
                        body:
                            "This event has already been added to your todo list",
                        context: context,
                        okAction: () {
                          Navigator.pop(context);
                          widget
                              .rejectOpportunityCallBack(widget.recommendation);
                          Navigator.pop(context);
                        }));
              } else {
                RecommendationPendoRepo.trackAcceptRecommendation(
                    pendoState: pendoState, event: widget.recommendation.event);
                final prefs = await SharedPreferences.getInstance();
                String? studentId = prefs.getString(sfidConstant);
                final bloc = BlocProvider.of<TodoListBloc>(context);
                bloc.add(TodoListEvent(studentId: studentId!));
                Navigator.pop(context);
                widget.rejectOpportunityCallBack(widget.recommendation);
                Navigator.pop(context);
              }
              // final bloc = BlocProvider.of<RecommendationBloc>(context);
              // bloc.add(GetRecommendation());
            },
            cancel: () {
              Navigator.pop(context);
            });
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
        ),
        height: 45,
        decoration: decoration,
        child: Text(
          'Add to To-do',
          style: montserratBoldTextStyle.copyWith(
            color: defaultDark,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _recommendedByButton(PendoMetaDataState pendoState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          clicked = !clicked;
        });
        showRecommendedPopup();
        RecommendationPendoRepo.trackTappingRecommendedByButton(
            recommendedBy:
                widget.recommendation.recommendedBy.map((e) => e.name).toList(),
            pendoState: pendoState,
            event: widget.recommendation.event);
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: clicked ? defaultDark : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SvgPicture.asset(
              "images/recommended_by.svg",
              height: 20,
              width: 16,
              color: clicked ? white : defaultDark,
            ),
          ),
        ),
      ),
    );
  }
}
