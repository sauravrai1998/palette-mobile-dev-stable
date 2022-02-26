import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/auth_module/screens/check_user_exist.dart';
import 'package:palette/modules/multi_tenant_module/screens/check_user_exist.dart';
import 'package:palette/utils/konstants.dart';

class TopSheet extends StatefulWidget {
  late AnimationController controller;
  late Animation<Offset> offset;

  TopSheet({required this.controller, required this.offset});

  @override
  _TopSheetState createState() => _TopSheetState();
}

class _TopSheetState extends State<TopSheet> with SingleTickerProviderStateMixin{

  final pageController = PageController(viewportFraction: .8);
  final _currentPageNotifier = ValueNotifier<int>(0);

  final pageControllerUser = PageController(viewportFraction: .85);
  final _currentPageNotifierUser = ValueNotifier<int>(0);
  final List<String> imgEx = [
    'https://cdn.pixabay.com/photo/2020/03/11/23/24/lamp-post-4923527_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/03/11/23/24/lamp-post-4923527_960_720.jpg',
  ];

  final List<String> imgEx1 = [
    'https://cdn.pixabay.com/photo/2020/03/11/23/24/lamp-post-4923527_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/03/11/23/24/lamp-post-4923527_960_720.jpg',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    widget.offset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(widget.controller);
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      child: SlideTransition(
        position: widget.offset,
        child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(25.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .2,
                    decoration: BoxDecoration(
                      color: pureblack,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16.0),
                      ),
                    ),
                    child: imgEx.isNotEmpty?Column(
                      children: [
                        SizedBox(height: 80,),
                        Container(
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: imgEx.length,
                            itemBuilder: (context, itemIndex) {
                              return _makePage(context, itemIndex);
                            },
                            onPageChanged: (index) {
                              _currentPageNotifier.value = index;
                            },
                          ),
                        ),
                        SizedBox(height: 50,),
                        Center(
                          child: CirclePageIndicator(
                            selectedDotColor: Colors.white,
                            dotColor: defaultLight.withOpacity(0.5),
                            itemCount: 2,
                            currentPageNotifier: _currentPageNotifier,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: MediaQuery.of(context).size.height / 7,
                          child: imgEx1.isNotEmpty?PageView.builder(
                            controller: pageControllerUser,
                            itemCount: imgEx1.length,
                            itemBuilder: (context, itemIndex) {
                              return _makeUsersPage(context, itemIndex);
                            },
                            onPageChanged: (index) {
                              _currentPageNotifierUser.value = index;
                            },
                          ):_addProfileCard(context),
                        ),
                      ],
                    ):_addInstituteCard(context),),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: MediaQuery.of(context).size.width/2 - 25,
                  child: GestureDetector(
                      onTap: () {
                        switch (widget.controller.status) {
                          case AnimationStatus.completed:
                            widget.controller.reverse();
                            break;
                          case AnimationStatus.dismissed:
                            widget.controller.forward();
                            break;
                          default:
                        }
                      },
                      child: Material(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          height: 47,
                          width: 47,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'images/top_arrow.svg',
                              height: 20,
                              width: 16,
                            ),
                          ),),
                      )))
            ]
        ),
      ),
    );
  }
  Widget _makePage(BuildContext context, int itemIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width * .95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Stack(
            children: [CachedNetworkImage(
              imageUrl: imgEx[itemIndex],
              imageBuilder: (context, imageProvider) =>
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) =>
                  Container(),
            ),
              Align(
                  alignment: Alignment.bottomCenter,heightFactor: 12.5,
                  child: Text('Stanford University',style: robotoTextStyle.copyWith(fontSize: 16,fontWeight: FontWeight.w700,color: white),)),


            ]
        ),
      ),
    );
  }
  Widget _makeUsersPage(BuildContext context, int itemIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width * .95,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: imgEx[itemIndex],
                imageBuilder: (context, imageProvider) =>
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover),
                      ),
                    ),
                placeholder: (context, url) => CircleAvatar(
                    radius:
                    // widget.screenHeight <= 736 ? 35 :
                    20,
                    backgroundColor: Colors.indigoAccent,
                    child: Container(
                      child: Container(),
                    )),
                errorWidget: (context, url, error) =>
                    CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
                      child: Container(),
                    ),
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Jack Parker',style: robotoTextStyle.copyWith(fontSize: 16,color: Colors.black),),
                  SizedBox(height: 10,),
                  Text('MIT, Student',style: robotoTextStyle.copyWith(fontSize: 14,color: defaultLight),),
                ],
              ),
              SizedBox(width: 35,),
              SvgPicture.asset('images/right_tick.svg')
            ],
          ),
        ),
      ),
    );
  }

  Widget _addProfileCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width * .85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: white
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              SvgPicture.asset('images/add_user.svg',height: 70,width: 70,),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add Profile',style: robotoTextStyle.copyWith(fontSize: 16,color: Color(0xFF5E5E5E),fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text('to continue..',style: robotoTextStyle.copyWith(fontSize: 14,color: defaultLight,fontWeight: FontWeight.w400),),
                ],
              ),
              SizedBox(width: 35,),
              Icon(Icons.add_circle,color: Color(0xFFBDBDBD),size: 34,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _addInstituteCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 100),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckUserExistScreenMultiTenant(),
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width * .95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Colors.white
          ),
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('images/institute.svg'),
              SizedBox(height: 25,),
              Text('ADD PROFILE TO CONTINUE',style: roboto700.copyWith(color: Color(0xFF8E8E8E),fontSize: 20),)
            ],
          )),
        ),
      ),
    );
  }
}
