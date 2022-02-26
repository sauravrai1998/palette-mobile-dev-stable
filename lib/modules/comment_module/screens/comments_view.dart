import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:palette/modules/comment_module/services/comment_pendo_repo.dart';
import 'package:palette/modules/notifications_module/services/notification_pendo_repo.dart';
import 'package:palette/modules/comment_module/bloc/comment_bloc.dart';
import 'package:palette/modules/comment_module/model/send_comment_bloc.dart';
import 'package:palette/modules/comment_module/model/comment_list_response_model.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/utils/custom_timeago_formatter.dart';
import 'package:palette/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsView extends StatefulWidget {
  String? eventId;
  String? commentType;
  String? commentOn;
  CommentsView({this.eventId, this.commentType, this.commentOn});

  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  StreamController<List<CommentItemModel>> commentStream =
      StreamController<List<CommentItemModel>>.broadcast();
  List<CommentItemModel> commentList = [];

  TextEditingController commentText = new TextEditingController();

  final _controller = ScrollController();
  bool enableSend = false;
  bool isLoading = false;

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(56 / 2)),
    borderSide: BorderSide(width: 1, color: Colors.transparent),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: WidgetsBinding.instance!.window.viewInsets.bottom > 0.0
            ? MediaQuery.of(context).size.height * 0.55
            : MediaQuery.of(context).size.height * 0.75,
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: pureblack,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.0),
                    topRight: Radius.circular(28.0),
                  ),
                ),
                height: 600,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset('images/comment_mycreation.svg'),
                          SizedBox(width: 16),
                          Text(
                            'Comments',
                            style: montserratNormal.copyWith(
                              color: white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<CommentsBloc, CommentsState>(
                        builder: (context, state) {
                      print('comment');
                      if (state is FetchCommentsLoadingState) {
                        print('loading');
                        return Center(
                          child: Container(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(white),
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      } else if (state is FetchCommentsSuccessState) {
                        commentList = state.commentList.commentList!;
                        return Expanded(
                          child: ListView.builder(
                            controller: _controller,
                            itemCount: commentList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 21,
                                              child: CachedNetworkImage(
                                                imageUrl: commentList[index]
                                                    .profilePicture,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Container()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Text(
                                                  commentList[index]
                                                              .creatorName ==
                                                          ''
                                                      ? ''
                                                      : Helper.getInitials(
                                                          commentList[index]
                                                              .creatorName,
                                                        ),
                                                  style:
                                                      robotoTextStyle.copyWith(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  commentList[index]
                                                      .creatorName,
                                                  style:
                                                      montserratNormal.copyWith(
                                                          fontSize: 14,
                                                          color: white),
                                                ),
                                                Text(
                                                  TimeAgo.timeAgoSinceDate(
                                                      DateFormat(
                                                              'dd-MM-yyyy hh:mma')
                                                          .format(
                                                              commentList[index]
                                                                  .postedAt)),
                                                  style:
                                                      montserratNormal.copyWith(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        white.withOpacity(0.72),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SvgPicture.asset(
                                          'images/comment_mycreation.svg',
                                          height: 22,
                                          width: 22,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    ExpandableText(
                                      commentList[index].comment,
                                      expandText: 'view more',
                                      style: montserratNormal.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: white,
                                        fontSize: 12,
                                      ),
                                      collapseText: 'view less',
                                      maxLines: 3,
                                      linkColor: white,
                                      linkStyle:
                                          roboto700.copyWith(fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is FetchCommentsFailureState) {
                        return commentList.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  controller: _controller,
                                  itemCount: commentList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 21,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          commentList[index]
                                                              .profilePicture,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      placeholder: (context,
                                                              url) =>
                                                          CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child:
                                                                  Container()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Text(
                                                        commentList[index]
                                                                    .creatorName ==
                                                                ''
                                                            ? ''
                                                            : Helper
                                                                .getInitials(
                                                                commentList[
                                                                        index]
                                                                    .creatorName,
                                                              ),
                                                        style: robotoTextStyle
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        commentList[index]
                                                            .creatorName,
                                                        style: montserratNormal
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: white),
                                                      ),
                                                      Text(
                                                        TimeAgo.timeAgoSinceDate(
                                                            DateFormat(
                                                                    'dd-MM-yyyy hh:mma')
                                                                .format(commentList[
                                                                        index]
                                                                    .postedAt)),
                                                        style: montserratNormal
                                                            .copyWith(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              white.withOpacity(
                                                                  0.72),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SvgPicture.asset(
                                                'images/comment_mycreation.svg',
                                                height: 22,
                                                width: 22,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6),
                                          ExpandableText(
                                            commentList[index].comment,
                                            expandText: 'view more',
                                            style: montserratNormal.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: white,
                                              fontSize: 12,
                                            ),
                                            collapseText: 'view less',
                                            maxLines: 3,
                                            linkColor: white,
                                            linkStyle: roboto700.copyWith(
                                                fontSize: 14),
                                          ),
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text('No comments found',
                                    style: montserratNormal.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: white,
                                      fontSize: 12,
                                    )),
                              );
                      }
                      return SizedBox();
                    }),
                  ],
                )),
            BlocProvider<SendCommentsBloc>(
              create: (context) => SendCommentsBloc(
                  commentRepository: RecommendRepository.instance),
              child: Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                  height: 56,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            focusedBorder: border,
                            disabledBorder: border,
                            enabledBorder: border,
                            border: border,
                            errorBorder: border,
                            focusedErrorBorder: border,
                            filled: true,
                            hintStyle: montserratNormal.copyWith(
                              fontWeight: FontWeight.w500,
                              color: hintBlack,
                              fontSize: 15,
                            ),
                            hintText: "Enter comment...",
                            fillColor: lightBlack,
                          ),
                          controller: commentText,
                          onChanged: (String value) {
                            setState(() {
                              if (value.trim().isNotEmpty) {
                                enableSend = true;
                              } else {
                                enableSend = false;
                              }
                            });
                          },
                          style: montserratNormal.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: commentText.text.trim().isNotEmpty || enableSend
                            ? () async {
                                await onTapSendButton(context);
                              }
                            : () {},
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: lightBlack,
                            borderRadius: BorderRadius.circular(56 / 2),
                          ),
                          child: BlocListener(
                            bloc: context.read<SendCommentsBloc>(),
                            listener: (context, state) {
                              if (state is SendCommentLoadingState) {
                                setState(() {
                                  isLoading = true;
                                });
                              } else if (state is SendCommentSuccessState) {
                                setState(() {
                                  isLoading = false;
                                });
                                _controller.animateTo(
                                  _controller.position.maxScrollExtent,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                              } else if (state is SendCommentFailureState) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: isLoading
                                ? Center(
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                white),
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.send,
                                      color:
                                          commentText.text.trim().isNotEmpty ||
                                                  enableSend
                                              ? white
                                              : hintBlack,
                                    ),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onTapSendButton(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(fullNameConstant);
    print(name);
    final profilePicture = prefs.getString(profilePictureConstant);
    Map<String, dynamic> queryParameters = {
      'id': widget.eventId.toString(),
      'comment': commentText.text.toString(),
      'commentType': widget.commentType.toString()
    };

    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    CommentPendoRepo.trackSendComment(
      pendoState: pendoState,
      eventId: widget.eventId.toString(),
      commentType: widget.commentType.toString(),
      commentOn: widget.commentOn.toString()
    );
    context.read<SendCommentsBloc>().add(SendComment(queryParameters));
    print('adding comment to list');
    setState(() {
      commentList.add(CommentItemModel(
          id: '1',
          profilePicture: profilePicture ?? '',
          creatorName: name ?? '',
          postedAt: DateTime.now(),
          comment: commentText.text));
      commentText.clear();
      enableSend = false;
    });
  }
}
