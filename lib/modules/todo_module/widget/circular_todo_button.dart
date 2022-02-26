import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/utils/konstants.dart';

class CircularTodoSearchButton extends StatelessWidget {
  final Color? iconColor;
  final Function onTap;
  final IconData icon;
  final bool? isUnRead;
  CircularTodoSearchButton(
      {Key? key,
      required this.onTap,
      required this.icon,
      this.isUnRead,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isUnRead = isUnRead ?? false;
    return GestureDetector(
      onTap: () {
        final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
        TodoPendoRepo.trackTodoSearch(pendoState: pendoState);
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: _isUnRead ? red : Colors.white,
            borderRadius: BorderRadius.circular(500),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ]),
        child: Icon(
          icon,
          color: iconColor ?? (_isUnRead ? Colors.white : kLightGrayColor),
          size: 16,
        ),
      ),
    );
  }
}
