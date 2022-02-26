import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_components/common_components_link.dart';

class ShowCallLinkPopup extends StatelessWidget {

final Function onTap;
final bool viewIcons;

  const ShowCallLinkPopup({ Key? key , required  this.onTap, required this.viewIcons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
      
      return GestureDetector(
                      onTap: () {
                        onTap();
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !viewIcons ? Colors.white : defaultDark,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 5,
                                offset: Offset(0, 1),
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: !viewIcons
                              ? Center(
                                  child: SvgPicture.asset("images/arrow_up.svg",
                                      height: 10,
                                      width: 16,
                                      color: defaultDark),
                                )
                              : Center(
                                  child: SvgPicture.asset(
                                    "images/arrow_down.svg",
                                    height: 10,
                                    width: 16,
                                    color: white,
                                  ),
                                ),
                        ),
                      ),
                    );
      
    
  }
}