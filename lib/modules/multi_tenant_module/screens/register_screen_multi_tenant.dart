import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';
class ReisterScreenMultiTenant extends StatefulWidget {
  const ReisterScreenMultiTenant({Key? key}) : super(key: key);

  @override
  _ReisterScreenMultiTenantState createState() => _ReisterScreenMultiTenantState();
}

class _ReisterScreenMultiTenantState extends State<ReisterScreenMultiTenant> {

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
                    Text('ADD NEW PROFILE',style: roboto700.copyWith(color: Colors.black),),
                    SizedBox(height: 50),
                    Text('Select your program',style: roboto700.copyWith(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),),
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
                    SizedBox(height: 25,),
                    Text('Select your role',style: roboto700.copyWith(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),),
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
                            hintText: 'your role',
                            suffixIconConstraints: BoxConstraints(maxHeight: 9,maxWidth: 14),
                            suffixIcon: SvgPicture.asset('images/arrow_down.svg',color: Color(0xFFBEBEBE),width: 14,height: 9,),
                          ),
                          // onChanged: onSearchTextChanged,
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
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
                    SizedBox(height: 25,),
                    Text('Create a new password',style: roboto700.copyWith(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),),
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
                            hintText: 'new password',
                          ),
                          // onChanged: onSearchTextChanged,
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
                    Text('Confirm new password',style: roboto700.copyWith(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 14),),
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
                            hintText: 'confirm password',
                          ),
                          // onChanged: onSearchTextChanged,
                        ),
                      ),
                    ),
                    SizedBox(height: 55,),
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
                            child: Text("REGISTER",
                                style: montserratBoldTextStyle.copyWith(
                                    color: white,
                                    fontSize: 12
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40,),

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
