import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/institute_logo.dart';
import 'package:palette/utils/konstants.dart';

import 'custom_chasing_dots_loader.dart';

class TopProgramButton extends StatefulWidget {
  const TopProgramButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  _TopProgramButtonState createState() => _TopProgramButtonState();
}

class _TopProgramButtonState extends State<TopProgramButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      top: 30,
      child: GestureDetector(
        onTap: () {
          // switch (widget.controller.status) {
          //   case AnimationStatus.completed:
          //     widget.controller.reverse();
          //     break;
          //   case AnimationStatus.dismissed:
          //     widget.controller.forward();
          //     break;
          //   default:
          // }
        },
        child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
            builder: (context, pendoState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      pendoState.role == 'Admin'
                          ? 'Program ${pendoState.role} at'
                          : pendoState.role,
                      style: robotoTextStyle.copyWith(
                          color: Color(0xFF979797),
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  Text(pendoState.instituteName,
                      style: robotoTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(
                width: 6,
              ),
              InstituteLogo(radius: 21),
            ],
          );
        }),
      ),
    );
  }
}
