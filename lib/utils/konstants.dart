import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';

const Color defaultDark = Color(0xFF4B5D6B);
const Color pureblack = Color(0xFF2B2A29);
const Color defaultLight = Color(0xFFDEE5EE);
const Color white = Color(0xFFFFFFFF);
const Color unselectedColor = Color(0xFF485D6B);
const Color offWhite = Color(0xFFF8F8F8);
const Color navBarPageBackgroundColor = Color(0xFF949FA8);
const Color swipeBackgroundColor = Color(0xFFE5E5E5);
const Color profileCardBackgroundColor = Color(0xFF77838F);
const Color darkBackgroundColor = Color.fromRGBO(75, 93, 107, 0.9);
const Color greenDefault = Color(0xFF02818E);
const Color inactiveOtpColor = Color(0xFFB3ACFA);
const Color moreChipColor = Color(0xFF6D89D3);
const Color greyBorder = Color(0xFFC4C4C4);
const Color lightFieldBGColor = Color.fromRGBO(179, 172, 250, 0.2);
const Color defaultBlueDark = Color(0xFF6D89D3);
const Color colorForPlaceholders = Color(0xFF89949C);
const Color lightGreen = Color(0xFF02818E);
const Color defaultOrange = Color(0xFFF39200);
const Color chatDarkPurple = Color(0xFF545190);
const Color defaultPurple = Color(0xFFB3ACFA);
const Color darkPurple = Color(0xFF3F3D56);
const Color iconEvent = Color(0xFFD6D6D6);
const Color selectContactTileColor = Color(0xFF7496BE);
const inProgressColorForTimeLineWidget = Color(0xFF5ec792);
const Color educationColorGrad1 = Color.fromRGBO(89, 95, 221, 1);
const Color companyColorGrad1 = Color.fromRGBO(153, 109, 248, 1);
const Color socialColorGrad1 = Color.fromRGBO(108, 172, 208, 1);
const Color genericColorGrad1 = Color.fromRGBO(0, 67, 133, 1);
const Color educationColorGrad2 = Color.fromRGBO(89, 95, 221, 0.5);
const Color companyColorGrad2 = Color.fromRGBO(153, 109, 248, 0.5);
const Color socialColorGrad2 = Color.fromRGBO(108, 172, 208, 0.5);
const Color genericColorGrad2 = Color.fromRGBO(0, 67, 133, 0.5);
const Color todoTypeTextColor = Color.fromRGBO(248, 109, 112, 1);
const Color nudeContainer = Color.fromRGBO(245, 245, 245, 1);
const Color violetContainer = Color.fromRGBO(89, 95, 221, 1);
const Color completedContainer = Color.fromRGBO(0, 146, 170, 0.17);
const Color openedContainer = Color.fromRGBO(255, 222, 222, 1);
const Color closedContainer = Color.fromRGBO(237, 239, 240, 1);
const Color completed = Color.fromRGBO(0, 146, 170, 1);
const Color openButtonColor = Color(0xFFE37A2E);
const Color closedButtonColor = Color(0xFF4B5D6B);
const Color completedButtonColor = Color(0xFF0092AA);
const Color todoListActiveTab = Color(0xFFF86D70);
const Color sportsBgColor = Color.fromRGBO(248, 109, 112, 0.06);
const Color educationColor = Color.fromRGBO(89, 95, 221, 0.06);
const Color companyColor = Color.fromRGBO(225, 223, 231, 0.5);
const Color volunteerColor = Color.fromRGBO(231, 223, 223, 0.5);
const Color genericColor = Color.fromRGBO(216, 220, 224, 0.5);
const Color artColor = Color.fromRGBO(231, 223, 223, 0.5);
const Color openOpac = Color.fromRGBO(227, 122, 46, 0.3);
const Color openOpacTool = Color.fromRGBO(227, 122, 46, 1);
const Color completedOpac = Color.fromRGBO(0, 146, 170, 0.3);
const Color completedOpacTool = Color.fromRGBO(0, 146, 170, 1);
const Color closedOpac = Color.fromRGBO(75, 93, 107, 0.3);
const Color closedOpacTool = Color.fromRGBO(75, 93, 107, 1);
const Color acceptText = Color.fromRGBO(75, 93, 107, 0.81);
const Color todoStatusOpenStatusText = Color(0xFFF98308);
const Color uploadIconButtonColor = Color(0xFF595FDD);
const Color rejectButton = Color(0xFF8A2828);
const Color aquaBlue = Color.fromRGBO(75, 93, 107, 1);
const Color pinkRed = Color.fromRGBO(248, 109, 112, 1);
const Color pinkRedOpace = Color.fromRGBO(248, 109, 112, 0.38);
const Color purpleBlue = Color(0xFF6C67F2);
const Color lightPurple = Color(0xFFD4D6FE);
const Color lightRed = Color(0xFFFFDEDF);
const Color clearSelectionBackgroundColor = Color(0xFF46439C);
const Color green = Color(0XFF71C77A);
const Color neoGreen = Color(0xFF44A13B);
const Color red = Color(0XFFB62931);
const Color approvalDescriptionGray = Color(0xFF827F7C);
const Color lightBlack = Color(0xFF464646);
const Color kDarkGrayColor = Color(0xff424C54);
const Color kLightGrayColor = Color(0xff4B5D6B);
const Color hintBlack = Color(0xFF7C7C7C);
const Color shareBackground = Color(0xFFF6F6F6);
const Color greenTick = Color(0xFF4ECB71);
const Color redColor = Color(0xFFC5545A);
const Color greyishGrey = Color(0xFF8F99A1);
const Color greyishGrey2 = Color(0xFFA5AEB5);

const String whatsappTitle = "WhatsApp";
const String linkedInTitle = "LinkedIn";
const String gitHubTitle = "Github";
const String facebookTitle = "Facebook";
const String instagramTitle = "Instagram";
const String websiteTitle = "Website";

const String checkHttp = "http://";
const String checkHttps = "https://";

InputDecoration authInputFieldDecoration = InputDecoration(
  fillColor: Colors.white,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
);

InputDecoration commonInputFieldDecoration = InputDecoration(
  fillColor: offWhite,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  hintText: 'Email',
  hintStyle: robotoTextStyle.copyWith(color: defaultDark.withOpacity(0.6)),
);

const TextStyle robotoTextStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: defaultDark,
);

const TextStyle montserratSemiBoldTextStyle = TextStyle(
  fontFamily: 'MontserratSemiBold',
  fontSize: 16,
  color: defaultDark,
);

const TextStyle montserratBoldTextStyle = TextStyle(
  fontFamily: 'MontserratBold',
  fontSize: 16,
  color: defaultDark,
);

const TextStyle darkTextFieldStyle = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: defaultLight,
);

const TextStyle lightTextFieldStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: defaultDark,
);

const TextStyle montserratNormal = TextStyle(
  fontFamily: 'MontserratReg',
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: defaultDark,
);

const TextStyle kalamTextStyle = TextStyle(
  fontFamily: 'KalamReg',
  fontSize: 28,
  fontWeight: FontWeight.normal,
  color: defaultDark,
);

const TextStyle kalamTextStyleSmall = TextStyle(
  fontFamily: 'KalamReg',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: defaultDark,
);

const TextStyle roboto700 = TextStyle(
  fontFamily: 'RobotoReg',
  fontSize: 24,
  color: defaultDark,
  fontWeight: FontWeight.w700,
);

const TextStyle kalam700 = TextStyle(
  fontFamily: 'KalamReg',
  fontSize: 24,
  color: defaultDark,
  fontWeight: FontWeight.w700,
);

const TextStyle addressTextStyle = TextStyle(
  color: defaultDark,
  fontSize: 18,
  fontFamily: 'KalamReg',
  fontWeight: FontWeight.w700,
);

const TextStyle kalamLight = TextStyle(
  color: defaultLight,
  fontSize: 18,
  fontFamily: 'KalamReg',
  fontWeight: FontWeight.w700,
);

const TextStyle tutoringStyle = TextStyle(
  fontSize: 12,
  fontFamily: 'KalamReg',
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

const bottomRightNotCurvedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(20)));

const bottomRightCurvedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12)));

const String institutePlaceholder = 'Select Institute';

const String globalString = 'Global';

const String coursePlaceholder = 'Select Course';

const String ferpaCompilanceText =
    "The Family Educational Rights and Privacy Act (FERPA) (20 U.S.C. § 1232g; 34 CFR Part 99) is a Federal law that protects the privacy of student education records. The law applies to all schools that receive funds under an applicable program of the U.S. Department of Education. FERPA gives parents certain rights with respect to their children's education records. These rights transfer to the student when he or she reaches the age of 18 or attends a school beyond the high school level. Students to whom the rights have transferred are 'eligible students'. These rights transfer to the student when he or she reaches the age of 18 or attends a school beyond the high school level. Students to whom the rights have transferred are eligible students.";

const preRegisterMessage =
    'The user has been registered successfully. The password credentials have been saved for future login.';

const userMappingKeyForUidNameMapping = 'userMapping';
const roleFromUserExistAPIKey = 'roleFromUserExistAPI';

/// Share Drawer Constants

const String sharedURLString = 'SharedURLConstant';

const String iOSAppGroupId = 'group.com.paletteedu.palette.sharedrawer';

const String shareDrawerNavigateKey = 'shareDrawerNavigateKey';

/// Firebase Keys
const firebaseNotifProdKey =
    'AAAAa9BJ43I:APA91bEWHycY0O_wsr_WATOtHrSmQPbqQZ8EjTS8NfD6RYe5sTn3O9d6QZzSB0A8fYp0fhDCAXOUQzp6ByGp8Jqe_H3DD2FwbjNZhZ4BBBxr-CYb6TvwLAfcUt7nZtIN62rPEqcLBQAG';

const firebaseNotifDevKey =
    'AAAAZzH4Y3w:APA91bGHzvaF5D9EJNsWtpWcByn8E0zYw5fx_iEMfjN2inHp9ARxMckCGyj2XhExDzx2SMdYOS0D84febKocsu9iHJvQ1lmMha2Vm-BdzPqkJbC1LN1qqjQqG97jgJKdo0tYPC8q2VVh';

const firebaseNotifKey = firebaseNotifProdKey;

var deviceTimeOffset = 0;

/// URIS
const prodURI = 'https://app.paletteedu.net:5000';

const prodUAT_URI = 'http://54.208.95.107:5000';

const newProdUAT_URI = 'http://3.84.252.145:5000';

const devURI = 'http://164.52.205.35:9000';

const uri = newProdUAT_URI;

const uriV1 = uri + '/v1';

const uriV2 = uri + '/v2';

const current_uri = uriV1;

const sfidConstant = 'sfid';

const saleforceUUIDConstant = 'saleforceUUID';

const fullNameConstant = 'fullName';

const profilePictureConstant = 'profilePicture';

/// ENV
const env = 'UAT';

/// Pendo Key

const pendoDevKey =
    'eyJhbGciOiJSUzI1NiIsImtpZCI6IiIsInR5cCI6IkpXVCJ9.eyJkYXRhY2VudGVyIjoidXMiLCJrZXkiOiIyMzQ0YzE1MTk4ZjM5OTYyZjM5NzdjYjdlZGU3OTliYzIxNDViNzg2NDZmOTkwNjcwMjkyZDZjMzBlOTdlOGFiOTI0YTRlNDBhODlmYzY2MDE5ZDIzYjM2ZTY5ODhhMjcxYzk2NjM3MmUzYTQzMzdmYmVmNGJlODQzMWI2ZTBmZmMwODMwOTE2NWJlMTEzZjMwNGU4Y2JjMjU0YTk2ZDBlOTg3NzIxOWE2ZmMxZWIxNDM5NTQzNTBkODE0ZDI2YjVlM2NiYjI4YWY3OTA5N2E0YWNjOTRkNzI5YzQ1MWQ5Mi4wMGE0NzgxMmE4Mjg4NjkwZjVjOGUwMzIzZTczOTk2Ni45YTllMjNlNjFjOTE4MDA3MWRkMjZjNzk0ZGY1MjBiY2U2NjUwZmNjNzVkYjJmNWQ4YTkxNjkwM2Y3MWIxNTYzIn0.eWmPX89C620WqnycV7LPTMtpZtI0lTpoKxln7u-yrtJizCGImRL8Wwf3vdq-7A9-pmat38VgorQ0dJoa--inhO7KqBEpfWtdCrvM78TMCUmmg_qP0n6q43VZOMqoe_CfS8NhG1C9vh6mII6usPrQxQyFTM19pyK_tToujoAvM9w';

const pendoProdKey =
    'eyJhbGciOiJSUzI1NiIsImtpZCI6IiIsInR5cCI6IkpXVCJ9.eyJkYXRhY2VudGVyIjoidXMiLCJrZXkiOiIzYzIyZTYxZjJmNWU2OWZhZjAwZTgzZDlhZTVjMDkwOTUyM2I1ZjQ5ZjM5NDFlYzgxNDY0YWQyOTBkMjg1MmFhYjUzNzY3MGJiNzY1Y2IyYzgwMTIzN2EyMmU1NGQ4YjZhMjA5YmQ2YTU0ODI4YWM2YzhkOWNjNzA5YzQ3NjU1NzhhYWMxNTE3YWY2NDljYjM5YmNkNmRkODM3YWU2ODhjNzRhYTI0OGVhMTJiMTNiYzNlNjBkOGZiMzI5YTFhYjRjMDFlYzViZDA4MDMzNTFkOTAyNjQ1Y2UwY2QwYjFmOS43NTk2MGI3MzQ4NDMxM2Q5MDM2ZTgwMGM0MjIxMWYzZC4wNTQ5YTk2YzRjNTU4MTYyZTk4OTlhYWE0NDA1NjZmNTU4NzU3ZjExZmU2Nzg5NjMyYmUxMjQxYzJmNDMwNDdjIn0.h1lfDV3cI5jCStKf4BJ6RLAq6CjwvPgORzb7PpK07j6z--gvaOFRFvGIm1JDxp7rwOKK9xVCuqnkXKOap5oAkbkI7ZT33i-N_AWeYc2UwPmW7Lax_LzDisZx4n3cVG5-8SCBZsIhgqEZpjt_XPvUDvAWyH01gD48pp6yoK8xRDM';

const pendoKey = pendoDevKey;
var isTodoListLoadedFirstTime = true;
var isTodoListLoadedFirstTimeForParent = true;

/// Pendo json keys

const visitorIdKey = 'visitorId';
const personNameKey = 'personName';
const personaTypeKey = 'persona';
const accountIdKey = 'accountId';
const instituteIdKey = 'instituteId';
const instituteNameKey = 'instituteName';
const instituteLogoKey = 'instituteLogo';
