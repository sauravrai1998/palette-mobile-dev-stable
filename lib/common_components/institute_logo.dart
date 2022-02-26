import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/utils/konstants.dart';

class InstituteLogo extends StatelessWidget {

  final double radius;
  const InstituteLogo({Key? key, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
        builder: (context, pendoState) {
      return CircleAvatar(
        radius: radius,
        child: CachedNetworkImage(
          imageUrl: pendoState.instituteLogo,
          imageBuilder: (context, imageProvider) => Container(
            width: 59,
            height: 59,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
            ),
          ),
          placeholder: (context, url) => CircleAvatar(
              radius:
                  // widget.screenHeight <= 736 ? 35 :
                  29,
              backgroundColor: Colors.white,
              child: CustomChasingDotsLoader(color: defaultDark)),
          errorWidget: (context, url, error) => Container(
            color: white,
          ),
        ),
      );
    });
  }
}
