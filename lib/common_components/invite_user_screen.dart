import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';
class InviteUserScreen extends StatefulWidget {
  const InviteUserScreen({Key? key}) : super(key: key);

  @override
  _InviteUserScreenState createState() => _InviteUserScreenState();
}

class _InviteUserScreenState extends State<InviteUserScreen> {

  TextEditingController programController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: RangeMaintainingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20,top: 50),
                child: backButton(context),
              ),
              SizedBox(height: 40,),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('INVITE NEW USERS',style: roboto700.copyWith(color: Colors.black),),
                  SizedBox(height: 50),
                  Text('Specified program',style: roboto700.copyWith(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),),
                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: ExcludeSemantics(
                      child: TextField(
                        controller: programController,
                        cursorColor: Colors.blueGrey,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Stanford University',
                        ),
                        // onChanged: onSearchTextChanged,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('Enter relationship',style: roboto700.copyWith(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),),
                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: ExcludeSemantics(
                      child: TextField(
                        controller: programController,
                        cursorColor: Colors.blueGrey,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Please select',
                          suffixIconConstraints: BoxConstraints(maxHeight: 9,maxWidth: 14),
                          suffixIcon: SvgPicture.asset('images/arrow_down.svg',color: Color(0xFFBEBEBE),width: 14,height: 9,),
                        ),
                        // onChanged: onSearchTextChanged,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('Enter user’s email address',style: roboto700.copyWith(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),),
                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: ExcludeSemantics(
                      child: TextField(
                        controller: programController,
                        cursorColor: Colors.blueGrey,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'example@email.com',
                        ),
                        // onChanged: onSearchTextChanged,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('User’s full name',style: roboto700.copyWith(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),),
                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: ExcludeSemantics(
                      child: TextField(
                        controller: programController,
                        cursorColor: Colors.blueGrey,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'full name',
                        ),
                        // onChanged: onSearchTextChanged,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Material(
                      color: pureblack,
                      elevation: 0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("SAVE",
                              style: montserratBoldTextStyle.copyWith(
                                color: white,
                                fontSize: 12
                              )),
                        ),
                      ),
                    ),
                  )

                ],
              ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container backButton(BuildContext context) {
    return Container(
              padding: EdgeInsets.only(left: 5),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(500),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ]),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
  }
}
