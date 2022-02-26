import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:palette/common_components/common_components_link.dart';

class FeedBackModalSheet extends StatefulWidget {
  @override
  _FeedBackModalSheetState createState() => _FeedBackModalSheetState();
}

class _FeedBackModalSheetState extends State<FeedBackModalSheet> {
  String feedback = "";

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      var effectiveHeight = 380;
      return SafeArea(
        child: Container(
          height: effectiveHeight.toDouble(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: defaultDark),
          child: Padding(
            padding: EdgeInsets.only(top: 30, left: 30, right: 30),
            child: ListView(
              children: [
                Text(
                  "Enter Feedback",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 15,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 160,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: Offset(0, 0),
                              spreadRadius: 0.25)
                        ]),
                    child: Column(
                      children: [
                        Flexible(
                          child: TextFormField(
                            maxLines: 8,
                            onChanged: (value) {
                              feedback = value;
                              setState(() {});
                            },
                            style: TextStyle(
                                color: defaultDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter comment",
                                contentPadding:
                                    EdgeInsets.only(left: 15, top: 5, right: 5),
                                hintStyle: TextStyle(
                                    color: defaultDark,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                                color: defaultDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
