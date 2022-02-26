import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class UploadResourcesArea extends StatelessWidget {
  final bool isAttachmentUploading;
  final Function onUploadTap;
  UploadResourcesArea(
      {required this.onUploadTap, required this.isAttachmentUploading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
        child: isAttachmentUploading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Text(
                  "Upload Resources",
                  style: montserratNormal.copyWith(fontSize: 14),
                ),
              ),
      ),
      onTap: () => onUploadTap(),
    );
  }
}
