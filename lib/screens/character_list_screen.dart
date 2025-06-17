import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    const TextStyle customTextStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 212, 15, 90),
      shadows: [
        Shadow(
          color: Colors.yellowAccent,
          blurRadius: 10,
          offset: Offset(0, 0),
        ),
        Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 3),
      ],
    );

    const List<Shadow> iconShadows = [
      Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(2, 2)),
    ];

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
            hintStyle: customTextStyle.copyWith(
              color: const Color.fromARGB(255, 213, 186, 216),
            ),
            border: InputBorder.none,
            prefixIcon: ShaderMask(
              shaderCallback:
                  (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFEB3B), Color(0xFFFFF176)],
                  ).createShader(bounds),
              child: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 255, 251, 7),
                shadows: iconShadows,
              ),
            ),
            suffixIcon:
                searchController.text.isNotEmpty
                    ? IconButton(
                      icon: ShaderMask(
                        shaderCallback:
                            (bounds) => const LinearGradient(
                              colors: [Color(0xFFFFEB3B), Color(0xFFFFF176)],
                            ).createShader(bounds),
                        child: const Icon(
                          Icons.clear,
                          color: Color.fromARGB(255, 255, 238, 7),
                          shadows: iconShadows,
                        ),
                      ),
                      onPressed: () {
                        searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        FocusScope.of(context).unfocus();
                      },
                    )
                    : null,
          ),
          style: customTextStyle.copyWith(
            color: const Color.fromARGB(244, 217, 158, 224),
          ),
          cursorColor: const Color.fromARGB(255, 255, 238, 7),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButton<String>(
              value: selectedHouse,
              hint: Text(
                'Evi Seç...',
                style: customTextStyle.copyWith(
                  color: const Color.fromARGB(255, 248, 248, 248),
                ),
              ),
              dropdownColor: deepNightBlue,
              icon: ShaderMask(
                shaderCallback:
                    (bounds) => const LinearGradient(
                      colors: [Color(0xFFFFEB3B), Color(0xFFFFF176)],
                    ).createShader(bounds),
                child: const Icon(
                  Icons.list_sharp,
                  color: Color.fromARGB(255, 253, 230, 25),
                  shadows: iconShadows,
                ),
              ),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                ref.read(houseFilterProvider.notifier).state = newValue;
              },
              items:
                  houses.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: customTextStyle.copyWith(
                          color: const Color.fromARGB(255, 206, 177, 223),
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
              if ((selectedHouse != null && selectedHouse != 'Tümü') ||
                  searchController.text.isNotEmpty) {
                return const Center(
                  child: MagicText(
                    '🔮 Aradığınız kriterlere uygun karakter bulunamadı!',
                    fontSize: 18,
                  ),
                );
              }
              return const Center(
                child: MagicText('Hiç karakter bulunamadı.', fontSize: 18),
              );
            }
            return RefreshIndicator(
              color: const Color.fromARGB(255, 208, 186, 221),
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
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 255, 238, 7),
                ),
              ),
          error: (error, stack) {
            return ErrorMessageWidget(
              message: error.toString(),
              onRefresh: () {
                ref.read(allCharactersProvider.notifier).refreshCharacters();
                ref.read(houseFilterProvider.notifier).state = null;
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
