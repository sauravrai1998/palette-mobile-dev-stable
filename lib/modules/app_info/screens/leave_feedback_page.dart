import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_components/text_area.dart';
import 'package:palette/modules/app_info/bloc/send_feedback_bloc.dart';
import 'package:palette/modules/app_info/models/app_info_model.dart';
import 'package:palette/modules/app_info/models/app_info_static_model.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class LeaveFeedBackPage extends StatefulWidget {
  String name;
  String email;
  LeaveFeedBackPage({required this.name, required this.email});

  @override
  _LeaveFeedBackPageState createState() => _LeaveFeedBackPageState();
}

class _LeaveFeedBackPageState extends State<LeaveFeedBackPage> {
  TextEditingController textAreaController = TextEditingController();

  String messageText = '';
  bool goodselection = false;
  bool badselection = false;
  bool mehselection = false;
  String selectedRating = '';
  bool errorMessage = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendFeedbackBloc, SendFeedbackState>(
        listener: (context, state) {
          if (state is SendFeedbackSuccess) {
            Helper.showSuccessSnackBar(
              'Your Feedback was delivered successfully',
              context,
            );
            setState(() {
              textAreaController.clear();
              goodselection = false;
              badselection = false;
              mehselection = false;
              selectedRating = '';
            });
          }
          if (state is SendFeedbackFailed) {
            Navigator.pop(context);
            Helper.showCustomSnackBar(
                'We could not send your message at this time. Please try again later',
                context);
          }
        },
        bloc: context.read<SendFeedbackBloc>(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                  child: Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: RotatedBox(
                                  quarterTurns: 1,
                                  child: SvgPicture.asset(
                                    'images/dropdown.svg',
                                    color: defaultDark,
                                  )),
                            ),
                          ),
                          Center(
                              child: Image.asset('images/palettelogonobg.png',
                                  width: 200)),
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Leave a feedback',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _ratingSelector(
                                        isSelected: goodselection,
                                        emotion: FeedBackRating.instance.good,
                                        onTap: () {
                                          setState(() {
                                            selectedRating =
                                                FeedBackRating.instance.good;
                                            goodselection = true;
                                            mehselection = false;
                                            badselection = false;
                                          });
                                        }),
                                    _ratingSelector(
                                        isSelected: mehselection,
                                        emotion:
                                            FeedBackRating.instance.neutral,
                                        onTap: () {
                                          setState(() {
                                            selectedRating =
                                                FeedBackRating.instance.neutral;
                                            goodselection = false;
                                            mehselection = true;
                                            badselection = false;
                                          });
                                        }),
                                    _ratingSelector(
                                        isSelected: badselection,
                                        emotion: FeedBackRating.instance.bad,
                                        onTap: () {
                                          setState(() {
                                            selectedRating =
                                                FeedBackRating.instance.bad;
                                            badselection = true;
                                            mehselection = false;
                                            goodselection = false;
                                          });
                                        }),
                                  ],
                                ),
                                SizedBox(height: 20),
                                CommonTextArea(
                                  hintText: 'Your message...',
                                  controller: textAreaController,
                                  initialText: messageText,
                                  onTextChanged: (text) {
                                    messageText = text;
                                    setState(() {
                                      messageText = text;
                                      errorMessage = false;
                                    });
                                  },
                                  errorFlag: errorMessage,
                                ),
                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                      sendFeedbackButton(context, selectedRating),
                      SizedBox(height: 10),
                    ]),
              ));
            }),
          ),
        ));
  }

  Column _ratingSelector(
      {bool isSelected = false,
      required String emotion,
      required Function onTap}) {
    Color _color = isSelected ? Colors.white : defaultDark;
    Color _borderColor = emotion == FeedBackRating.instance.good
        ? Colors.orangeAccent
        : emotion == FeedBackRating.instance.neutral
            ? Colors.grey
            : emotion == FeedBackRating.instance.bad
                ? red
                : defaultDark;
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(),
          child: Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? _borderColor : Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 2.4,
                      color: Colors.grey.withOpacity(0.8))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SvgPicture.asset('images/${emotion.toUpperCase()}.svg',
                  width: 50, height: 50, color: _color),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text('${emotion.toUpperCase()}',
            style: montserratNormal.copyWith(
                fontSize: 16,
                color: isSelected ? _borderColor : defaultDark,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget sendFeedbackButton(BuildContext context, String emotion) {
    Color _borderColor = emotion == FeedBackRating.instance.good
        ? Colors.orangeAccent
        : emotion == FeedBackRating.instance.neutral
            ? Colors.grey
            : emotion == FeedBackRating.instance.bad
                ?red
                : purpleBlue;
    return BlocBuilder<SendFeedbackBloc, SendFeedbackState>(
        builder: (context, state) {
      return Center(
          child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.76,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
        child: state is SendFeedbackLoading
            ? CustomPaletteLoader()
            : ElevatedButton.icon(
                onPressed: () {
                  if (selectedRating == '') {
                    Helper.showCustomSnackBar(
                        'Please select a Rating', context);
                    return;
                  }
                  if (messageText.isEmpty || messageText.trim().isEmpty) {
                    setState(() {
                      errorMessage = true;
                    });
                    return;
                  }
                  FeedbackModel model = FeedbackModel(
                      email: widget.email,
                      feedback: textAreaController.text,
                      name: widget.name,
                      rating: selectedRating.toUpperCase());
                  BlocProvider.of<SendFeedbackBloc>(context)
                      .add((SendFeedbackClicked(model)));
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(0.5)),
                icon: SvgPicture.asset(
                  'images/feedback.svg',
                  color: _borderColor,
                ),
                label: Text(
                  'SEND FEEDBACK',
                  style: TextStyle(color: _borderColor),
                ),
              ),
      ));
    });
  }
}
