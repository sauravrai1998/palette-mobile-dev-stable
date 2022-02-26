import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/utils/konstants.dart';

class SuggestEntireProgramButton extends StatelessWidget {
  final bool isSelected;
  final Function onTap;
  const SuggestEntireProgramButton(
      {required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return onTap();
      },
      child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 69,
          decoration: BoxDecoration(
            color: isSelected ? defaultDark : shareBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: white,
                  radius: 30,
                  backgroundImage: NetworkImage(pendoState.instituteLogo,),
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggest for entire program',
                    style: roboto700.copyWith(
                      color: isSelected ? white : defaultDark,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .70,
                    child: Text(
                      pendoState.instituteName,
                      style: roboto700.copyWith(
                          fontSize: 13,
                          color: isSelected
                              ? white.withOpacity(0.5)
                              : defaultDark.withOpacity(0.5)),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
