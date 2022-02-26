import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class FileResourceCardButton extends StatelessWidget {
  final bool isForm;
  final bool isForUpdate;
  final String? sfid;
  final String? sfuuid;
  final String? role;
  final String todotitle;
  // Function? onTap;
  FileResourceCardButton({
    Key? key,
    this.isForm = false,
    this.isForUpdate = false,
    // this.onTap,
    required this.file,
    this.sfid = '',
    this.sfuuid = '',
    this.role = '',
    required this.todotitle,
  }) : super(key: key);

  final Resources file;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return GestureDetector(
        onTap: () {
          TodoPendoRepo.trackTapOnDownloadResourcesEvent(
              pendoState: pendoState,
              todoTitle: todotitle,
              filelink: file.url.trim());
          return launchURL(file.url.trim().substring(0, 4) != "http"
              ? "https://" + file.url.trim()
              : file.url.trim());
        },
        child: Container(
          decoration: isForm
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    isForUpdate ? EdgeInsets.all(12) : EdgeInsets.all(20.0),
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
                  "${file.name.length <= 13 ? file.name : file.name.substring(0, 12)}...",
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
                  color: isForm ? defaultDark : violetContainer,
                ),
              )
            ],
          ),
        ),
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
