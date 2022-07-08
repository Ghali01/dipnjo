import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/share.dart';
import 'package:user/logic/providers/account.dart';

class ShareCubit extends Cubit<ShareState> {
  ShareCubit() : super(ShareState()) {
    load().then((value) => null);
  }
  Future<void> load() async {
    try {
      String rawData = await AccountAPI.getShareData();
      Map data = jsonDecode(rawData);
      emit(state.copyWith(
        loaded: true,
        code: data['code'],
        shareCodeValidated: data['shareCodeValidated'],
        usersSharedCount: data['usersSharedCount'],
      ));
    } catch (e) {}
  }

  void scanCode(int code) async {
    if (code == state.code) {
      emit(state.copyWith(error: tr("You can't use your code")));
      return;
    }
    try {
      emit(state.copyWith(loading: true));
      await AccountAPI.scanCode(code);
      emit(state.copyWith(
        loading: false,
        error: '',
        shareCodeValidated: true,
      ));
    } on CodeScanExp catch (e) {
      if (e.code == 404) {
        emit(state.copyWith(
          loading: false,
          error: tr('Code Not Found'),
        ));
      } else {
        emit(state.copyWith(
          loading: false,
          error: tr('Proccess Failed'),
        ));
      }
    } catch (e) {}
  }
}
