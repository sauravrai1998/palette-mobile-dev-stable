import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_repos/common_link_info.dart';
import 'package:palette/modules/explore_module/widgets/common_textbox_opportunity.dart';
import 'package:palette/modules/share_drawer_module/model/link_meta_info.dart';
import 'package:palette/modules/share_drawer_module/share_drawer_bloc/send_chat_message_bloc.dart';
import 'package:palette/modules/share_drawer_module/widgets/loading_helper.dart';
import 'package:palette/modules/share_drawer_module/widgets/share_drawer_back_button.dart';
import 'package:palette/modules/share_drawer_module/screens/share_send_chat/share_select_contacts_sheet.dart';
import 'package:palette/modules/share_drawer_module/widgets/weblink_container.dart';
import 'package:palette/utils/konstants.dart';

class ShareSendChatPage extends StatefulWidget {
  final String? urlLink;
  ShareSendChatPage({Key? key, this.urlLink}) : super(key: key);

  @override
  _ShareSendChatPageState createState() => _ShareSendChatPageState();
}

class _ShareSendChatPageState extends State<ShareSendChatPage> {
  var messageController = TextEditingController();
  bool errorMessage = false;
  late String role;
  LinkMetaInfo? linkMetaInfo;
  bool isFetching = true;

  @override
  void initState() {
    super.initState();
    fetchLinkInfo();
  }

  fetchLinkInfo() async {
    if (widget.urlLink != null) {
      linkMetaInfo =
          await CommonLinkMetaInfo().getMetaInfoOfLink(url: widget.urlLink!);
      String result = "";

      if (linkMetaInfo?.title != null) {
        result = "Look what I found - ${linkMetaInfo?.title}";
      }
      if (linkMetaInfo?.description != null) {
        result = result + "\n\n${linkMetaInfo?.description}";
      }
      messageController.text = result;
    }

    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    role = pendoState.role;
    return SafeArea(
        child: LoadingHelper(
      isLoading: isFetching,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SvgPicture.asset('images/bgsharedrawer.svg', height: 200),
            ),
            LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                physics: RangeMaintainingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            topRow(),
                            SizedBox(height: 20),
                            body(constraints: constraint),
                            SizedBox(height: 20),
                          ],
                        ),
                        Container(
                          child: nextButton(),
                          margin: EdgeInsets.only(bottom: 30),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ));
  }

  Widget topRow() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 20,
      ),
      child: Row(
        children: <Widget>[
          ShareDrawerBackButton(),
          SizedBox(width: 10),
          SharedWebLinkContainer(
              url: widget.urlLink ?? 'https://www.google.com'),
        ],
      ),
    );
  }

  Widget body({required Constraints constraints}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: Text('Send in Chat',
                      style:
                          montserratSemiBoldTextStyle.copyWith(fontSize: 18))),
              SizedBox(height: 20),
              CommonTextAreaOpportunity(
                hintText: 'Message (optional)',
                controller: messageController,
                errorFlag: errorMessage,
              ),
              SizedBox(height: 14),
            ]));
  }

  bool isValid() {
    return true;
  }

  Widget nextButton() {
    return GestureDetector(
      onTap: () {
        if (isValid()) {
          String msg = widget.urlLink != null
              ? '${messageController.text} \n ${widget.urlLink}'
              : messageController.text;
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            isScrollControlled: true,
            builder: (context) => BlocProvider(create: (BuildContext context) {  
              return SendChatMessageBloc(SendChatMessageInitialState());
            },
            child: ShareSelectContactSheet(message: msg)),
          );
        }
      },
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
            color: purpleBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 3),
                  blurRadius: 6)
            ]),
        child: Center(
          child: Text(
            'SEND'.toUpperCase(),
            style: robotoTextStyle.copyWith(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
