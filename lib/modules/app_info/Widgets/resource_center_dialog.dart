import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_repos/common_pendo_repo.dart';
import 'package:palette/modules/app_info/bloc/resource_center_bloc.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

// ignore: non_constant_identifier_names
Future<void> resourceCenterDialog(
    {required BuildContext context,
    required String sfuuid,
    required String role,
    required String sfid}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BlocBuilder<ResourceCenterBloc, ResourceCenterState>(
          bloc: context.read<ResourceCenterBloc>(),
          builder: (context, state) {
            bool isLoading = state is ResourceCenterGuidesLoadingState;
            if (state is ResourceCenterGuidesFailedState) {
              Navigator.pop(context);
              Helper.showCustomSnackBar(
                  'Something went wrong. Check back later', context);
            }
            if (state is ResourceCenterGuidesSuccessState) {
              if (state.guideList.length == 0) {
                Helper.showToast('Nothing to display');
                if (!isLoading) {
                  Navigator.pop(context);
                }
              }
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!isLoading) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: state.guideList.length == 0
                          ? Container()
                          : SimpleDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              titlePadding: EdgeInsets.only(left: 50, top: 20),
                              title: Row(
                                children: [
                                  SvgPicture.asset('images/resource_center.svg',
                                      color: Colors.deepPurpleAccent),
                                  SizedBox(width: 10),
                                  Text('Resource Centre',
                                      style: robotoTextStyle.copyWith(
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              children: state.guideList.map((e) {
                                return BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                                  builder: (context, pendoState) {
                                    return InkWell(
                                      onTap: () {
                                        CommonPendoRepo.trackResourceCenterGuide(
                                            pendoState: pendoState,
                                            eventName: e.eventString);
                                      },
                                      child: ListTile(
                                        title: Text(e.name,
                                            style: robotoTextStyle.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(e.description,
                                            style: robotoTextStyle.copyWith(
                                                color: Colors.grey)),
                                      ),
                                    );
                                  }
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          });
    },
  );
}
