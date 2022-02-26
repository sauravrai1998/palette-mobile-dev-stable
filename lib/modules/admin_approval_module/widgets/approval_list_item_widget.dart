import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';

class ApprovalListItemWidget extends StatelessWidget {
  final int index;
  const ApprovalListItemWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: index == 1 ? 120 : 130,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(33, 12, 18, 7.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18,
              top: 12,
              bottom: 12,
              right: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Text(
                    'Barbara washington',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: roboto700.copyWith(
                      color: defaultDark,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                _makeTimeRow(),
                SizedBox(height: 17),
                if (index != 1) _eventNameAndDescription()
              ],
            ),
          ),
        ),
        Positioned(
          right: 25,
          top: 18,
          child: Container(
            width: 22,
            height: 26,
            child: SvgPicture.asset(
              'images/genericVM.svg',
              color: defaultDark.withOpacity(0.64),
            ),
          ),
        ),
        if (index == 1)
          Positioned(
            bottom: 7.5,
            left: 33,
            right: 18,
            child: Container(
                height: 34,
                padding: EdgeInsets.only(left: 18, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18)),
                  color: Colors.grey[200],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Apply to Montgomery College',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: roboto700.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 19,
                    ),
                  ],
                )),
          ),
        _circleAvatar(),
      ],
    );
  }

  Widget _makeTimeRow() {
    return Container(
      margin: EdgeInsets.only(left: 18),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: defaultDark.withOpacity(0.64),
            size: 14,
          ),
          SizedBox(width: 4),
          Text(
            '2 weeks ago',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: montserratNormal.copyWith(
              fontSize: 10,
              color: defaultDark.withOpacity(0.64),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleAvatar() {
    return Positioned(
      left: 10,
      top: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        width: 48,
        height: 48,
      ),
    );
  }

  Widget _eventNameAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hype Sport Summer Jam',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: roboto700.copyWith(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: montserratNormal.copyWith(
            fontSize: 10,
            height: 1.2,
            color: defaultDark.withOpacity(0.64),
          ),
        ),
      ],
    );
  }
}
