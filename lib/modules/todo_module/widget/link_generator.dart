import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/utils/konstants.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class LinkGenerator extends StatelessWidget {
  final Resources file;
  String? sfid;
  String? sfuuid;
  String? role;
  final String todotitle;
  LinkGenerator({
    Key? key,
    required this.file,
     this.sfid,
     this.sfuuid,
     this.role,
    required this.todotitle,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
        return GestureDetector(
          onTap: () {
            TodoPendoRepo.trackTapOnLinkResourcesEvent(pendoState: pendoState, todoTitle: todotitle, link: file.url);
            return launchURL(file.url.trim().substring(0, 4) != "http"
              ? "https://" + file.url.trim()
              : file.url.trim());
          },
          child: Wrap(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.68,
                child: Text('${file.name} ',
                    overflow: TextOverflow.ellipsis,
                    style: roboto700.copyWith(fontSize: 14, color: defaultDark)),
              ),
              SvgPicture.asset(
                'images/linkDetails.svg',
                color: defaultDark,
              ),
            ],
          ),
        );
      }
    );
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
