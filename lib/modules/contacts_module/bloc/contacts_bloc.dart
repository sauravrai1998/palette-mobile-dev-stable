import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/contacts_module/services/contacts_repo.dart';

abstract class GetContactsState {}

class GetContactsInitialState extends GetContactsState {}

class GetContactsLoadingState extends GetContactsState {}

class GetContactsSuccessState extends GetContactsState {
  final ContactsResponse contactsResponse;
  GetContactsSuccessState({required this.contactsResponse});
}

class GetContactsFailureState extends GetContactsState {
  final String errorMessage;

  GetContactsFailureState(this.errorMessage);
}

abstract class ContactsEvent {}

class GetContactsEvent extends ContactsEvent {}

class GetContactsBloc extends Bloc<ContactsEvent, GetContactsState> {
  GetContactsBloc(GetContactsState initialState)
      : super(GetContactsInitialState());

  @override
  Stream<GetContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is GetContactsEvent) {
      log('GetContactsEvent inside bloc');
      yield GetContactsLoadingState();
      try {
        final contactsResponse = await ContactsRepo.instance.getContacts();
        yield GetContactsSuccessState(contactsResponse: contactsResponse);
      } catch (e) {
        yield GetContactsFailureState(e.toString());
      }
    }
  }
}
