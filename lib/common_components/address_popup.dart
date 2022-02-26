import 'package:palette/common_components/common_components_link.dart';

// ignore: must_be_immutable
class AddressPopUp extends StatefulWidget {
  String address;

  final Function? upDateCallBack;
  AddressPopUp({required this.address, required this.upDateCallBack});

  @override
  _AddressPopUpState createState() => _AddressPopUpState();
}

class _AddressPopUpState extends State<AddressPopUp>
    with SingleTickerProviderStateMixin {
  var showOptions = false;

  getBody(_width) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 10, top: 10),
      child: Container(
        width: 4.5 * _width / 7,
        height: 90,
        child: Row(
          children: [
            Container(
              width: 3.8 * _width / 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.home,
                          color: defaultDark,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Semantics(
                          child: Text(
                            "ADDRESS",
                            style: roboto700.copyWith(
                                color: defaultDark, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 0.5 * _width / 7,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    child: FittedBox(
                      child: Semantics(
                        child: Text(
                          "${widget.address}",
                          style: roboto700.copyWith(
                              fontWeight: FontWeight.w700,
                              color: defaultDark,
                              fontFamily: 'KalamReg',
                              fontSize: 14),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   width: 0.3 * _width / 7,
            //   child: showOptions
            //       ? Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     print('called');
            //                     showOptions = !showOptions;
            //                     print(showOptions);
            //                   });
            //                 },
            //                 child: Icon(
            //                   Icons.keyboard_arrow_up,
            //                   size: 20,
            //                   color: defaultDark,
            //                 )),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Container(
            //                 decoration: BoxDecoration(
            //                     color: defaultDark,
            //                     borderRadius:
            //                         BorderRadius.circular(500)),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(2.0),
            //                   child: Center(
            //                       child: Icon(
            //                     Icons.delete,
            //                     size: 13,
            //                     color: defaultLight,
            //                   )),
            //                 )),
            //             SizedBox(
            //               height: 10,
            //             ),
            //             Container(
            //                 decoration: BoxDecoration(
            //                     color: defaultDark,
            //                     borderRadius:
            //                         BorderRadius.circular(500)),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(2.0),
            //                   child: Icon(
            //                     Icons.double_arrow,
            //                     size: 13,
            //                     color: defaultLight,
            //                   ),
            //                 ))
            //           ],
            //         )
            //       : Container(
            //           alignment: Alignment.topCenter,
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               GestureDetector(
            //                   onTap: () {
            //                     setState(() {
            //                       print('called');
            //                       showOptions = !showOptions;
            //                       print(showOptions);
            //                     });
            //                   },
            //                   child: Icon(
            //                     Icons.keyboard_arrow_down,
            //                     size: 20,
            //                     color: defaultDark,
            //                   )),
            //               SizedBox(
            //                 height: 40,
            //               )
            //             ],
            //           ),
            //         ),
            // )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(child: GestureDetector(
          onTap: () {
            setState(() {
              print('ca;;ed');
              widget.upDateCallBack!(popUp: false);
            });
          },
        )),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Container(
                width: 4.5 * _width / 7,
                decoration: BoxDecoration(
                    color: defaultLight,
                    borderRadius: BorderRadius.circular(12)),
                child: getBody(_width),
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    widget.upDateCallBack!(false);
                  });
                },
                child: SizedBox(
                  width: _width * 1.3 / 7,
                )),
          ],
        ),
      ],
    );
  }
}
