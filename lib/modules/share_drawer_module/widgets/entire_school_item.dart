import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/utils/konstants.dart';

class EntireSchoolItem extends StatelessWidget {
  const EntireSchoolItem({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    return Container(
      height: 70,
      width: 190,
      margin: EdgeInsets.only(right: 10,left: 2,bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(-1, 6),)
        ],
      
      ),
      child: Row(
        children: [
          const SizedBox(width: 2),
           CircleAvatar(
              backgroundColor: white,
              radius: 25,
              backgroundImage: NetworkImage(
                pendoState.instituteLogo,
              )),
          const SizedBox(width: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${pendoState.instituteName}',
                style: roboto700.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                overflow: TextOverflow.clip,
              ),
              SizedBox(height: 5),
              Text(
                'Entire School',
                style: roboto700.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}