import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_potter_app/providers/character_provider.dart';
import 'package:harry_potter_app/widgets/character_card.dart';
import 'package:harry_potter_app/widgets/error_message_widget.dart';
import 'package:harry_potter_app/widgets/magic_text.dart';

class CharacterListScreen extends HookConsumerWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsyncValue = ref.watch(filteredCharactersProvider);
    final selectedHouse = ref.watch(houseFilterProvider);
    final searchController = useTextEditingController();

    final List<String> houses = [
      'Tümü',
      'Gryffindor',
      'Hufflepuff',
      'Ravenclaw',
      'Slytherin',
    ];

    const Color deepNightBlue = Color(0xFF2E1A47);
    const Color darkPurple = Color(0xFF3B2C5A);
    const Color goldColor = Color(0xFFFFC107);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepNightBlue,
        title: TextField(
          controller: searchController,
          onChanged: (query) {
            ref.read(searchQueryProvider.notifier).state = query;
          },
          decoration: InputDecoration(
            hintText: ' Karakter ara...  ✨',
            hintStyle: GoogleFonts.cinzelDecorative(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: goldColor),
            suffixIcon:
                searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear, color: goldColor),
                      onPressed: () {
                        searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        FocusScope.of(context).unfocus();
                      },
                    )
                    : null,
          ),
          style: GoogleFonts.cinzelDecorative(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          cursorColor: goldColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButton<String>(
              value: selectedHouse,
              dropdownColor: deepNightBlue,
              icon: const Icon(Icons.list_sharp, color: goldColor),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(houseFilterProvider.notifier).state = newValue;
                }
              },
              items:
                  houses.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.cinzelDecorative(
                          color: const Color.fromARGB(255, 248, 248, 248),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [deepNightBlue, darkPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: charactersAsyncValue.when(
          data: (characters) {
            if (characters.isEmpty) {
              if (selectedHouse != 'Tümü' || searchController.text.isNotEmpty) {
                return Center(
                  child: MagicText(
                    '🔮 Aradığınız kriterlere uygun karakter bulunamadı!',
                    fontSize: 18,
                  ),
                );
              }
              return Center(
                child: MagicText('Hiç karakter bulunamadı.', fontSize: 18),
              );
            }
            return RefreshIndicator(
              color: const Color.fromARGB(255, 255, 255, 255),
              onRefresh:
                  () =>
                      ref
                          .read(allCharactersProvider.notifier)
                          .refreshCharacters(),
              child: ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return CharacterCard(character: character);
                },
              ),
            );
          },
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: goldColor),
              ),
          error: (error, stack) {
            return ErrorMessageWidget(
              message: error.toString(),
              onRefresh: () {
                ref.read(allCharactersProvider.notifier).refreshCharacters();
                ref.read(houseFilterProvider.notifier).state = 'Tümü';
                ref.read(searchQueryProvider.notifier).state = '';
                searchController.clear();
              },
            );
          },
        ),
      ),
    );
  }
}
