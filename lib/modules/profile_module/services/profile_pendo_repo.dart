import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

class ProfilePendoRepo {
  static trackOpenImageUploadPopup({required PendoMetaDataState pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - ProfilePicture - OpenImageUploadPopup', arg);
  }

  static trackSelectProfileImageFromGallery(
      {required PendoMetaDataState pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - ProfilePicture - SelectImageFromGallery', arg);
  }

  static trackRemoveProfilePicture({required PendoMetaDataState pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - ProfilePicture - RemoveProfilePicture', arg);
  }

  static trackUploadProfilePicture(
      {required String url, required PendoMetaDataState pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      "profilePictureUrl": url,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - ProfilePicture - UploadProfilePicture', arg);
  }

  // static loopTrackEvents(
  //     {required PendoMetaDataState pendoState}) {
  //   Map<String, dynamic> arg = {
  //     visitorIdKey: pendoState.visitorId,
  //
  //     personaTypeKey: pendoState.role,
  //     accountIdKey: pendoState.instituteName,
  //     instituteIdKey: pendoState.instituteId,
  //     instituteName: pendoState.instituteName,
  //   };
  //   var arr = [
  //     'Student Dashboard | DashboardScreen - Tap on Profile - Navigate To Profile Screen',
  //     'Other Role Dashboard | DashboardScreen - Tap on Profile - Navigate To Profile Screen',
  //     'Student Recommendation | RecommendationDetailScreen - VisitLinkOfAnEvent',
  //     'Other roles Recommendation | RecommendationDetailScreen - VisitLinkOfAnEvent',
  //     'Student Explore | ExploreScreen - NavigateToExploreScreen',
  //     'Other roles Explore | ExploreScreen - NavigateToExploreScreen',
  //   ];
  //   for (var i = 0; i < arr.length; i++) {
  //     PendoFlutterPlugin.track(arr[i], arg);
  //     print(arr[i]);
  //   }
  //   //PendoFlutterPlugin.track(
  //   //       'Profile | ProfilePage - Settings - LogoutEvent', arg);
  //   // }
  // }

  static trackLogoutEvent({required PendoMetaDataState pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Profile | AppInfoPage - LogoutButton - LogoutEvent', arg);
  }

  // static trackClearAccountData({required PendoMetaDataState pendoState}) {
  //   Map<String, dynamic> arg = {
  //     visitorIdKey: pendoState.visitorId,
  //
  //     personaTypeKey: pendoState.role,
  //     accountIdKey: pendoState.instituteName,
  //     instituteIdKey: pendoState.instituteId,
  //     instituteName: pendoState.instituteName,
  //   };

  //   PendoFlutterPlugin.track(
  //       'Profile | ProfilePage - Settings - ClearAccountData', arg);
  // }

  static trackViewAllSkills(
      {required bool thirdPerson, required PendoMetaDataState pendoState}) {
    var eventname =
        thirdPerson ? "ViewAllSkillsByThirdPerson" : "ViewAllSkillsByStudent";
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - Skills - $eventname', arg);
  }

  static trackViewAllInterests(
      {required bool thirdPerson, required PendoMetaDataState pendoState}) {
    var eventname = thirdPerson
        ? "ViewAllInterestsByThirdPerson"
        : "ViewAllInterestsByStudent";
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - Interests - $eventname', arg);
  }

  static trackOpenSheetForAddingValue(
      {required bool isSkill, required PendoMetaDataState pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    if (isSkill) {
      PendoFlutterPlugin.track(
          'Profile | ProfilePage - AddingSkills - ViewInputSheetForAddingSkills',
          arg);
    } else {
      PendoFlutterPlugin.track(
          'Profile | ProfilePage - AddingInterests - ViewInputSheetForAddingInterests',
          arg);
    }
  }

  static trackAddingNewValue(
      {required PendoMetaDataState pendoState,
      required bool isSkill,
      required List<String> newValue}) {
    var eventname = isSkill
        ? 'Profile | ProfilePage - AddingSkills - AddingNewSkills'
        : 'Profile | ProfilePage - AddingInterests - AddingInterests';
    var newkey = isSkill ? "NewSkills" : "NewInterests";
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      newkey: newValue,
    };
    PendoFlutterPlugin.track('$eventname', arg);
  }

  static trackOpenSocialPopup(
      {required PendoMetaDataState pendoState, required String socialType}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'socialType': socialType
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - SocialInfoButtons - ViewSocialInfo', arg);
  }

  static trackOpenSocialPopupThirdPerson(
      {required PendoMetaDataState pendoState,
      required String socialType,
      required String studentId}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'socialType': socialType,
      'studentId': studentId
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - SocialInfoButtons - ViewSocialInfoByThirdPerson',
        arg);
  }

  static trackCopySocialLink({
    required String socialLink,
    required PendoMetaDataState pendoState,
    required String socialType,
  }) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'socialType': socialType,
      'link': socialLink,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - SocialPopupActions - CopySocialLink', arg);
  }

  static trackOpenSocialLink(
      {required PendoMetaDataState pendoState,
      required String socialType,
      required String socialLink}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'socialType': socialType,
      'link': socialLink,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - SocialPopupActions - ViewSocialLinkInBrowser',
        arg);
  }

  static trackDeleteSocialLink(
      {required PendoMetaDataState pendoState, required String socialType}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'socialType': socialType,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - SocialPopupActions - DeleteSocialLink', arg);
  }

  static trackOpenEditSocialLink(
      {required PendoMetaDataState pendoState, required String socialType}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'socialType': socialType,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - SocialPopupActions - OpenEditBoxForSocialLink',
        arg);
  }

  static trackUploadEditedLink(
      {required PendoMetaDataState pendoState,
      required String socialType,
      required String socialLink}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'socialType': socialType,
      'link': socialLink,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - SocialLinkEditBoxOptions - UploadEditedSocialLink',
        arg);
  }

  static trackUploadSocialLink(
      {required PendoMetaDataState pendoState,
      required String socialType,
      required String socialLink}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
      'socialType': socialType,
      'link': socialLink,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - AddingNewSocialLink - UploadNewSocialLink',
        arg);
  }

  static trackNavigateBack({required PendoMetaDataState pendoState}) {
    Map<String, dynamic> arg = {
      visitorIdKey: pendoState.visitorId,
      personaTypeKey: pendoState.role,
      accountIdKey: pendoState.instituteName,
      instituteIdKey: pendoState.instituteId,
    };

    PendoFlutterPlugin.track(
        'Profile | ProfilePage - TapOnBackButton - NavigatedBackToDasboard',
        arg);
  }
}
