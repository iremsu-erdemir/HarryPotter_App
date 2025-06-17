import 'package:dio/dio.dart';
import 'package:harry_potter_app/models/character.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://hp-api.onrender.com/api';

  Future<List<Character>> getCharacters() async {
    try {
      final response = await _dio.get('$_baseUrl/characters');

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Data: ${response.data.runtimeType}');
      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('API\'den boş (null) yanıt geldi.');
        }

        if (response.data is! List) {
          throw Exception(
            'API yanıtı liste formatında değil. Gelen tür: ${response.data.runtimeType}',
          );
        }

        final List<dynamic> data = response.data;

        return data.map((json) {
          try {
            return Character.fromJson(json);
          } catch (e) {
            print('Karakter dönüşüm hatası: $e for JSON: $json');

            rethrow;
          }
        }).toList();
      } else {
        throw Exception('API isteği başarısız oldu: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio Hata Yanıtı: ${e.response!.data}');
        throw Exception(
          'API hatası: ${e.response!.statusCode} - ${e.response!.statusMessage}',
        );
      } else {
        throw Exception(
          'Ağ hatası veya beklenmeyen bir sorun oluştu: ${e.message}',
        );
      }
    } catch (e) {
      throw Exception('Karakterler getirilirken genel bir hata oluştu: $e');
    }
  }
}
