
//ContactUs States
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/app_info/models/app_info_model.dart';
import 'package:palette/modules/app_info/services/app_info_repo.dart';

class ContactUsState{}
class ContactUsInitial extends ContactUsState{}
class ContactUsSuccess extends ContactUsState {}
class ContactUsLoading extends ContactUsState {}
class ContactUsFailed extends ContactUsState {
  final String error;

  ContactUsFailed({required this.error});
}

//ContactUs Event
abstract class ContactUsEvent {}

class ContactUsClicked extends ContactUsEvent {
  final ContactUsModel contactUsModel;

  ContactUsClicked(this.contactUsModel);
}
//ContactUs Bloc
class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc() : super(ContactUsInitial());


  @override
  Stream<ContactUsState> mapEventToState(ContactUsEvent event) async*{
    if (event is ContactUsClicked) {
      yield ContactUsLoading();
      try {
        print('App Info Contact Us Bloc');
         await AppInfoRepo.contactUs(event.contactUsModel);
        
          yield ContactUsSuccess();
        
      } catch (e) {
        yield ContactUsFailed(error: e.toString());
      }
    }
  }
  
}
