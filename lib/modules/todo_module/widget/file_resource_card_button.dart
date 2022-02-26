import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class FileResourceCardButton extends StatefulWidget {
  final bool isForm;
  final bool isForUpdate;
  final String? sfid;
  final String? sfuuid;
  final String? role;
  final String todotitle;
  final String? gid;
  // Function? onTap;
  FileResourceCardButton({
    Key? key,
    this.isForm = false,
    this.isForUpdate = false,
    // this.onTap,
    required this.file,
    this.sfid = '',
    this.sfuuid = '',
    required this.gid,
    this.role = '',
    required this.todotitle,
  }) : super(key: key);

  final Resources file;

  @override
  State<FileResourceCardButton> createState() => _FileResourceCardButtonState();
}

class _FileResourceCardButtonState extends State<FileResourceCardButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return GestureDetector(
        onTap: () async {
          TodoPendoRepo.trackTapOnDownloadResourcesEvent(
              pendoState: pendoState,
              todoTitle: widget.todotitle,
              filelink: widget.file.url.trim());

          print('file.url: ${widget.file.url.trim()}');

          if (widget.file.url.startsWith('http')) {
            return launchURL(!widget.file.url.startsWith('http')
                ? "https://" + widget.file.url.trim()
                : widget.file.url.trim());
          } else {
            OpenFile.open(widget.file.url);
          }
        },
        child: Builder(builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            decoration: widget.isForm
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ])
                : BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: nudeContainer),
            child: widget.file.type.toLowerCase() == 'jpg' ||
                    widget.file.type.toLowerCase() == 'png' ||
                    widget.file.type.toLowerCase() == 'jpeg' ||
                    widget.file.type.toLowerCase() == 'gif'
                ? Container(
                    child: Builder(builder: (context) {
                      if (widget.file.url.startsWith('http')) {
                        return CachedNetworkImage(
                          imageUrl: widget.file.url,
                          placeholder: (context, _) {
                            return Container(
                              width: 80,
                              child: CustomChasingDotsLoader(
                                color: Colors.blue,
                                size: 30.0,
                              ),
                            );
                          },
                        );
                      }

                      return Image.file(
                        File(widget.file.url),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 80,
                      );
                    }),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: widget.isForUpdate
                            ? EdgeInsets.all(12)
                            : EdgeInsets.all(20.0),
                        child: SvgPicture.asset(
                          'images/pdf.svg',
                          color: defaultDark,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                        width: 80,
                        height: 16,
                        child: Text(
                          "${widget.file.name.length <= 13 ? widget.file.name : widget.file.name.substring(0, 12)}...",
                          style: roboto700.copyWith(
                            fontSize: 11.8,
                            color: white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: widget.isForm ? defaultDark : violetContainer,
                        ),
                      )
                    ],
                  ),
          );
        }),
      );
    });
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
