import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

class GenderSelector extends StatelessWidget {
  final List<String> genderList;
  final Function(int) onTap;
  final selectedIndex;

  GenderSelector({
    Key? key,
    required this.genderList,
    required this.onTap,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    return MergeSemantics(
      child: Semantics(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: genderList
              .asMap()
              .map((index, gender) {
                return MapEntry(
                    index,
                    GestureDetector(
                      onTap: () {
                        onTap(index);
                      },
                      child: Container(
                        width: index > 2 ? devWidth * 0.3 : devWidth * 0.25,
                        padding: EdgeInsets.only(
                            top: index > 2 ? 10 : 0,
                            bottom: index < 2 ? 10 : 0),
                        margin: EdgeInsets.symmetric(
                            horizontal: index > 2 ? 12 : 5),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? defaultBlueDark
                                  : white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  offset: Offset(0, 1),
                                  blurRadius: 8,
                                )
                              ]),
                          child: Center(
                            child: BlockSemantics(
                              child: Text(
                                gender,
                                textAlign: TextAlign.center,
                                style: robotoTextStyle.copyWith(
                                  color: selectedIndex == index
                                      ? offWhite
                                      : defaultDark,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
              })
              .values
              .toList(),
        ),
      ),
    );
  }
}
