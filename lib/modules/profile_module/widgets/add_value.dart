import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/dark_text_field.dart';
import 'package:palette/common_components/next_icon_button.dart';
import 'package:palette/common_components/submit_icon_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_states.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class AddValue extends StatefulWidget {
  final List<String?> points;
  final String? value;
  final Function? callBackfn;
  final String sfid;
  final String sfuuid;

  AddValue(
      {required this.points, this.value, this.callBackfn, required this.sfid, required this.sfuuid});

  @override
  _AddValueState createState() => _AddValueState();
}

class _AddValueState extends State<AddValue> {
  TextEditingController inputController = TextEditingController();
  FocusNode inputFocus = FocusNode();
  List<String> newlyAddedPoints = [];
  var hasText = false;
  int length = 0;

  @override
  initState() {
    super.initState();
    print(widget.value);
    inputController.addListener(() {
      if (inputController.text.length > 0) {
        setState(() {
          hasText = true;
        });
      } else {
        setState(() {
          hasText = false;
        });
      }
    });
  }

  Widget closeIconWidget() {
    return Positioned(
      top: 10,
      bottom: 10,
      right: 20,
      child: Semantics(
        onTapHint: "Text cleared",
        button: true,
        label: "Clear text button",
        child: GestureDetector(
          onTap: () {
            setState(() {
              inputController.clear();
            });
          },
          child: SvgPicture.asset(
            'images/crossicon.svg',
            height: 27,
            color: defaultLight,
          ),
        ),
      ),
    );
  }

  Widget listOfAddedValues() {
    return ListView(children: [
      Wrap(
        children: List.generate(
            length,
            (index) => Padding(
                  padding:
                      const EdgeInsets.only(right: 25, top: 10, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: profileCardBackgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(
                        "${newlyAddedPoints[index]}",
                        style: kalamLight,
                      ),
                    ),
                  ),
                )),
      )
    ]);
  }

  Widget getNextButton() {
    return BlocListener(
      listener: (_, state) {
        if (state is SkillsInterestActivitiesFailedState) {
          Helper.showCustomSnackBar(state.err, context);
          Navigator.pop(context);
        }
        if (state is SkillsInterestActivitiesSuccessState) {
          Navigator.pop(context);
        }
      },
      bloc: context.read<RefreshProfileBloc>(),
      child: Container(
        child: BlocBuilder<RefreshProfileBloc, RefreshProfileState>(
          builder: (_, state) {
            if (state is SkillsInterestActivitiesLoadingState) {
              return CustomChasingDotsLoader(
                color: defaultDark,
              );
            }
            return hasText
                ? Semantics(
                    button: true,
                    label: "Add ${widget.value} button",
                    onTapHint: "${widget.value} added",
                    child: NextButton(
                      clickFunction: () {
                        final text = inputController.text;
                        if (inputController.text.startsWith(' ') ||
                            inputController.text.endsWith(' ')) {
                          if (text.contains(RegExp(r'[A-Z]')) ||
                              text.contains(RegExp(r'[a-z]'))) {
                            setState(() {
                              newlyAddedPoints.add(
                                  inputController.text.trimRight().trimLeft());
                              length = newlyAddedPoints.length;
                              inputController.clear();
                            });
                          } else {}
                        } else {
                          setState(() {
                            newlyAddedPoints.add(inputController.text);
                            length = newlyAddedPoints.length;
                            inputController.clear();
                          });
                        }
                      },
                    ),
                  )
                : BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                    return Semantics(
                        button: true,
                        label: "Submit ${widget.value} button",
                        onTapHint: "${widget.value} submitted",
                        child: SubmitIconButton(
                          clickFunction: () {
                            if (length >= 1) {
                              final bloc =
                                  BlocProvider.of<RefreshProfileBloc>(context);
                              var data = widget.points + newlyAddedPoints;
                              if (widget.value == "Interests") {
                                ProfilePendoRepo.trackAddingNewValue(
                                    pendoState: pendoState,
                                    isSkill: false,
                                    newValue: newlyAddedPoints);
                                var interestMap = {"interests": data};
                                bloc.add(
                                    AddSkillsInterestActivities(data: interestMap));
                                bloc.add(RefreshUserProfileDetails());
                              } else if (widget.value == "Skills") {
                                ProfilePendoRepo.trackAddingNewValue(
                                    pendoState: pendoState,
                                    isSkill: true,
                                    newValue: newlyAddedPoints);
                                var skillsMap = {"skills": data};
                                bloc.add(
                                    AddSkillsInterestActivities(data: skillsMap));
                                bloc.add(RefreshUserProfileDetails());
                              } else {
                                var activitiesMap = {"activities": data};
                                bloc.add(AddSkillsInterestActivities(
                                    data: activitiesMap));
                                bloc.add(RefreshUserProfileDetails());
                              }
                              widget.callBackfn == null
                                  ? print("no function was passed")
                                  : widget.callBackfn!(
                                      newlyAddedPoints, widget.value);
                              setState(() {});
                            }
                          },
                        ),
                      );
                  }
                );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextScaleFactorClamper(
      child: StatefulBuilder(builder: (context, setState) {
        var listViewHeight = (length > 2
                ? 200
                : length > 0
                    ? 100
                    : 0)
            .toDouble();
        return SafeArea(
          child: Semantics(
            label:
                "Here you can add more ${widget.value}. Type them in the text input field below and press the button next to it to submit the entered value",
            child: Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 10, right: 20, bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  length > 0
                      ? Container(
                          height: listViewHeight, child: listOfAddedValues())
                      : Container(),
                  Center(
                      child: Text(
                    "Select your ${widget.value}",
                    style: kalamLight.copyWith(color: defaultDark),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 18.0, left: 15),
                          child: Stack(
                            children: [
                              DarkTextField(
                                skillinterest: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10,
                                  right: 32,
                                  top: 15,
                                  bottom: 15,
                                ),
                                hintText:
                                    'Enter your ${widget.value.toString().toLowerCase()} here.',
                                inputController: inputController,
                                inputFocus: inputFocus,
                                hasPadding: true,
                              ),
                              closeIconWidget(),
                            ],
                          ),
                        ),
                      ),
                      getNextButton()
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
