import 'package:dio/dio.dart';
import 'package:harry_potter_app/models/character.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://hp-api.onrender.com/api';

  Future<List<Character>> getCharacters() async {
    try {
      final response = await _dio.get('$_baseUrl/characters');

      // BURAYA EKLE: API yanıtını konsola yazdır
      print('API Response Status Code: ${response.statusCode}');
      print(
        'API Response Data: ${response.data.runtimeType}',
      ); // Veri tipini de yazdır
      // print('API Response Data Content: ${response.data}'); // Çok büyükse konsolu doldurur

      if (response.statusCode == 200) {
        // Kontrol 1: response.data'nın null olup olmadığını kontrol edin
        if (response.data == null) {
          throw Exception('API\'den boş (null) yanıt geldi.');
        }

        // Kontrol 2: response.data'nın List<dynamic> olduğundan emin olun
        if (response.data is! List) {
          throw Exception(
            'API yanıtı liste formatında değil. Gelen tür: ${response.data.runtimeType}',
          );
        }

        final List<dynamic> data = response.data;

        // Listeyi Character nesnelerine dönüştürün
        // HER BİR KARAKTERİN DÖNÜŞÜMÜNÜ KONTROL ETMEK İÇİN TRY-CATCH EKLENDİ
        return data.map((json) {
          try {
            return Character.fromJson(json);
          } catch (e) {
            // Hangi JSON objesinin hataya neden olduğunu görmek için
            print('Karakter dönüşüm hatası: $e for JSON: $json');
            // Hatanın UI'a taşınması için yeniden fırlatıyoruz
            rethrow;
          }
        }).toList();
      } else {
        throw Exception('API isteği başarısız oldu: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          'Dio Hata Yanıtı: ${e.response!.data}',
        ); // Dio'dan gelen hata yanıtını yazdır
        throw Exception(
          'API hatası: ${e.response!.statusCode} - ${e.response!.statusMessage}',
        );
      } else {
        throw Exception(
          'Ağ hatası veya beklenmeyen bir sorun oluştu: ${e.message}',
        );
      }
    } catch (e) {
      throw Exception(
        'Karakterler getirilirken genel bir hata oluştu: $e',
      ); // Genel hata mesajını güncelledim
    }
  }
}
