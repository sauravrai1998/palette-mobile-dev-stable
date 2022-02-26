
import 'package:flutter/material.dart';

class ActivityStatus {
  static String submitted = 'SUBMITTED'.toLowerCase();
  static String incomplete = 'INCOMPLETE'.toLowerCase();
  static String received = 'RECEIVED'.toLowerCase();
  static String inReview = 'IN REVIEW'.toLowerCase();
  static String waitList = 'WAITLIST'.toLowerCase();
  static String admit = 'ADMIT';
  static String admitWithCondition = 'ADMIT WITH CONDITIONS'.toLowerCase();
  static String deny = 'DENY';
  static String defferedOffer = 'DEFERRED OFFER'.toLowerCase();
  static String acceptedOffer = 'ACCEPTED OFFER'.toLowerCase();
  static String declinedOffer = 'DECLINED OFFER'.toLowerCase();

  //ACCEPTED OFFER  //DECLINED OFFER

  //DEFERRED OFFER

  static Color getColor(String status){
    //0xFFE5E5E5
    if(status == declinedOffer){
      return Color(0xFFBE4A25);
    } else if(status == acceptedOffer){
      return Color(0xFF5BAF7C);
    } else if(status == defferedOffer){
      return Color(0xFF006DAA);
    } else if(status == deny){
      return Color(0xFFBE4A25);
    } else if(status == admitWithCondition){
      return Color(0xFF71C77A);
    } else if(status == admit){
      return Color(0xFF71C77A);
    } else if(status == waitList){
      return Color(0xFF6C63FF);
    } else if(status == inReview){
      return Color(0xFFF98308);
    } else if(status == received){
      return Color(0xFF00AAAA);
    } else if(status == incomplete){
      return Color(0xFF8E0202);
    } else if(status == submitted){
      return Color(0xFF0092AA);
    } else {
      return Color(0xFF0092AA);
    }

  }


}