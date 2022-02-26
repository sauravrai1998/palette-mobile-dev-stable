import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_components/text_area.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/modules/app_info/bloc/contact_us_bloc.dart';
import 'package:palette/modules/app_info/models/app_info_model.dart';
import 'package:palette/modules/app_info/models/app_info_static_model.dart';
import 'package:palette/modules/todo_module/widget/file_resource_card_button.dart';
import 'package:palette/modules/todo_module/widget/textFormfieldForAppInfo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/validation_regex.dart';

class ContactUsPage extends StatefulWidget {
  final String name;

  ContactUsPage({Key? key, required this.name}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController textAreaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String emailText = '';
  String messageText = '';
  bool errorEmail = false;
  bool errorMessage = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactUsBloc, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsSuccess) {
          Helper.showSuccessSnackBar(
            'Your Message was delivered successfully',
            context,
          );
          setState(() {
            emailText = '';
            messageText = '';
            textAreaController.clear();
            emailController.clear();
          });
        } else if (state is ContactUsFailed) {
          Navigator.pop(context);
          Helper.showCustomSnackBar(
                'We could not send your message at this time. Please try again later',
                context);
        }
      },
      bloc: context.read<ContactUsBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(builder: (lcontext, constraints) {
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
                                Text('Contact Us',
                                    style: montserratSemiBoldTextStyle.copyWith(
                                      fontSize: 24,
                                    )),
                                SizedBox(height: 20),
                                CommonTextFieldAppInfo(
                                  hintText: 'Your email...',
                                  inputController: emailController,
                                  errorFlag: errorEmail,
                                  onChanged: (text) {
                                    emailText = text;
                                    print(emailText);
                                    setState(() {
                                      errorEmail = false;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                CommonTextArea(
                                  hintText: 'Your message...',
                                  controller: textAreaController,
                                  initialText: messageText,
                                  errorFlag: errorMessage,
                                  onTextChanged: (text) {
                                    messageText = text;
                                    setState((){
                                      messageText = text;
                                      errorMessage = false;
                                    });
                                  },
                                ),
                                SizedBox(height: 40),
                              ],
                            )),
                      ],
                    ),
                    SizedBox(height: 20),
                    sendReportButton(context),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          _contactRow(context),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ]),
            ));
          }),
        ),
      ),
    );
  }

  Widget sendReportButton(BuildContext context) {
    return BlocBuilder<ContactUsBloc, ContactUsState>(
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
        child: state is ContactUsLoading
            ? CustomPaletteLoader()
            : MaterialButton(
                onPressed: () async {
                  if (emailText.isEmpty) {
                    setState(() {
                      errorEmail = true;
                    });
                    return;
                  } else if (messageText.isEmpty || messageText.trim().isEmpty) {
                    setState(() {
                      errorMessage = true;
                    });
                    return;
                  } else if (emailText.contains(Validator.emailValid) ==
                      false) {
                    Helper.showCustomSnackBar(
                        'Please enter a valid email', context);
                    setState(() {
                      errorEmail = true;
                    });
                    return;
                  }
                  ContactUsModel model = ContactUsModel(
                      email: emailController.text,
                      message: messageText,
                      name: widget.name);
                  BlocProvider.of<ContactUsBloc>(context)
                      .add(ContactUsClicked(model));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail_outline,
                      color: defaultDark,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'SEND MESSAGE',
                      style: TextStyle(color: defaultDark),
                    ),
                  ],
                ),
              ),
      ));
    });
  }
}

Widget _contactRow(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    height: 50.0,
    width: width,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                color: defaultDark,
                icon: Icon(
                  Imported.mail_black_18dp_1,
                  size: 34,
                  semanticLabel: "Email",
                ),
                onPressed: () {
                  launchURL('mailto:${AppInfoSocialLinks.instance.email}');
                }),
            IconButton(
                color: defaultDark,
                icon: Icon(
                  Imported.language_black_18dp_1,
                  size: 34,
                  semanticLabel: "Website link",
                ),
                onPressed: () {
                  launchURL('${AppInfoSocialLinks.instance.weblink}');
                }),
            IconButton(
                icon:
                    SvgPicture.asset('images/twitter.svg', color: defaultDark),
                onPressed: () {
                  launchURL('${AppInfoSocialLinks.instance.twitter}');
                }),
            IconButton(
                icon: SvgPicture.asset('images/facebook.svg'),
                onPressed: () {
                  launchURL('${AppInfoSocialLinks.instance.facebook}');
                }),
            IconButton(
                color: defaultDark,
                icon: Icon(
                  Imported.instagram,
                  size: 34,
                  semanticLabel: "Instagram",
                ),
                onPressed: () {
                  launchURL('${AppInfoSocialLinks.instance.instagram}');
                }),
          ],
        ),
      ),
    ),
  );
}
