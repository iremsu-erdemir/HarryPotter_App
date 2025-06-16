import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_app/models/character.dart';
import 'package:harry_potter_app/services/api_service.dart';

// API servisini sağlayan provider
final apiServiceProvider = Provider((ref) => ApiService());

// API'den tüm karakterleri çeken provider
final allCharactersProvider =
    AsyncNotifierProvider<AllCharactersNotifier, List<Character>>(() {
      return AllCharactersNotifier();
    });

class AllCharactersNotifier extends AsyncNotifier<List<Character>> {
  @override
  Future<List<Character>> build() async {
    final apiService = ref.watch(apiServiceProvider);
    return apiService.getCharacters();
  }

  // Veriyi yenilemek için
  Future<void> refreshCharacters() async {
    ref.invalidateSelf(); // Mevcut veriyi sıfırlar
    await future; // Yeni verinin yüklenmesini bekler
  }
}

// Filtre seçimini tutar (varsayılan: 'Tümü')
final houseFilterProvider = StateProvider<String?>((ref) => 'Tümü');

// Arama metnini tutar
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtrelenmiş ve aranmış karakterleri sağlayan provider
final filteredCharactersProvider = Provider<AsyncValue<List<Character>>>((ref) {
  final allCharactersAsyncValue = ref.watch(allCharactersProvider);
  final selectedHouse = ref.watch(houseFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return allCharactersAsyncValue.when(
    data: (characters) {
      Iterable<Character> filtered = characters;

      // Eve göre filtreleme
      if (selectedHouse != null &&
          selectedHouse.isNotEmpty &&
          selectedHouse != 'Tümü') {
        filtered = filtered.where(
          (character) =>
              character.house?.toLowerCase() == selectedHouse.toLowerCase(),
        );
      }

      // Arama sorgusuna göre filtreleme
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where(
          (character) =>
              character.name.toLowerCase().contains(searchQuery.toLowerCase()),
        );
      }

      return AsyncValue.data(filtered.toList());
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});
