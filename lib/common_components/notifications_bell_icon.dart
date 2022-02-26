import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_repos/common_pendo_repo.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

class NotificationBellButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final int? notificationCount;
  NotificationBellButton(
      {Key? key, required this.onTap, required this.icon, this.notificationCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _notificationCountText = notificationCount != null && notificationCount != 0
        ? notificationCount! >= 11 ? '10+' : '$notificationCount'
        : '';
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
      builder: (context, state) {
        return Container(
          height: 35,
          width: 35,
          child: Stack(
            children: [
              Positioned(
                top: 4,
                right: 5,
                child: Container(
                  padding: EdgeInsets.all(7.5),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: defaultLight,
                      borderRadius: BorderRadius.circular(500),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ]),
                  child: SvgPicture.asset(
                    'images/notification_bell_icon.svg',
                    color: defaultDark,
                    height: 20,
                    width: 20,
                  ),
                  ),
              ),
              if (notificationCount != null && notificationCount != 0)
              Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      color: red,
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: Center(
                      child: Text(
                        _notificationCountText,
                        style: roboto700.copyWith(
                          color: Colors.white,
                          fontSize: _notificationCountText.length < 3? 10: 7,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    );
  }
}
