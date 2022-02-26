import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';

class SwipeUpButton extends StatelessWidget {
  final width;
  final String sfid;
  final String sfuuid;
  final String role;
  SwipeUpButton(
      {required this.width,
      required this.sfid,
      required this.role,
      required this.sfuuid});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Button to navigate back to the dashboard",
      button: true,
      child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return GestureDetector(
          onTap: () async {
            ProfilePendoRepo.trackNavigateBack(pendoState: pendoState);
            Navigator.pop(context);
          },
          child: Container(
            width: width / 7,
            decoration: BoxDecoration(
                color: greyishGrey2,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
            height: 60,
            child: Icon(
              Imported.subtract,
              size: 20,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }
}
