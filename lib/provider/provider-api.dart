import 'package:entrevista/api/api.dart';
import 'package:entrevista/models/characters-model.dart';
import 'package:flutter/material.dart';

class ProviderApi extends ChangeNotifier {
  CharacteresModel _info;
  bool _loading = false;
  bool get loading => this._loading;
  CharacteresModel get info => this._info;

  Future<void> getInfo(String nextPage) async {
    final api = Api();
    _loading = true;
    if (_info == null) {
      final resp = await api.getCharacters(nextPage);
      this._info = resp;
      _loading = false;
    } else {
      final resp = await api.getCharacters(nextPage);
      this._info.info = resp.info;
      final listNew = resp.results.map((e) => e).toList();
      this._info.results.addAll(listNew);
      _loading = false;
    }

    notifyListeners();
  }

  ProviderApi() {
    this.getInfo('/character?page=2');
  }
}
