import 'package:dio/dio.dart';
import 'package:entrevista/models/characters-model.dart';

class Api {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://rickandmortyapi.com/api'),
  );

  Future<CharacteresModel> getCharacters(String nextPage) async {
    try {
      final response = await _dio.get(
        '$nextPage',
        options: Options(headers: {
          "Content-Type": "application/json",
          'Accept': "application/json",
        }),
      );
      final data = CharacteresModel.fromJson(response.data);
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
