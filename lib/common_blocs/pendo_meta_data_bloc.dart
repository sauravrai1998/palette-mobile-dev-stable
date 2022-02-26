import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PendoMetaDataEvent {}

class PendoMetaDataWithValuesEvent extends PendoMetaDataEvent {
  String visitorId;
  String accountId;
  String name;
  String role;
  String instituteId;
  String instituteName;
  String instituteLogo;

  PendoMetaDataWithValuesEvent({
    required this.visitorId,
    required this.accountId,
    required this.name,
    required this.instituteName,
    required this.instituteId,
    required this.role,
    required this.instituteLogo
  });
}

class PendoClearMetaDataEvent extends PendoMetaDataEvent {}

class PendoMetaDataState {
  String visitorId;
  String accountId;
  String name;
  String role;
  String instituteId;
  String instituteName;
  String instituteLogo;

  PendoMetaDataState({
    this.name = '',
    this.role = '',
    this.accountId = '',
    this.instituteId = '',
    this.visitorId = '',
    this.instituteName = '',
    this.instituteLogo = ''
  });

  PendoMetaDataState copyWith({
    String? visitorId,
    String? accountId,
    String? name,
    String? role,
    String? instituteId,
    String? instituteName,
    String? instituteLogo
  }) {
    return PendoMetaDataState(
      name: name ?? this.name,
      role: role ?? this.role,
      visitorId: visitorId ?? this.visitorId,
      accountId: accountId ?? this.accountId,
      instituteId: instituteId ?? this.instituteId,
      instituteName: instituteName ?? this.instituteName,
      instituteLogo: instituteLogo ?? this.instituteLogo
    );
  }

  clearState() {
    this.visitorId = '';
    this.role = '';
    this.accountId = '';
    this.instituteId = '';
    this.visitorId = '';
    this.instituteName = '';
    this.instituteLogo = '';
  }
}

class PendoMetaDataBloc extends Bloc<PendoMetaDataEvent, PendoMetaDataState> {
  PendoMetaDataBloc() : super(PendoMetaDataState());

  @override
  Stream<PendoMetaDataState> mapEventToState(PendoMetaDataEvent event) async* {
    if (event is PendoClearMetaDataEvent) {
      state.clearState();
      yield state;
    } else if (event is PendoMetaDataWithValuesEvent) {
      yield state.copyWith(
        name: event.name,
        role: event.role,
        accountId: event.accountId,
        visitorId: event.visitorId,
        instituteId: event.instituteId,
        instituteName: event.instituteName,
        instituteLogo: event.instituteLogo
      );
    }
  }
}
