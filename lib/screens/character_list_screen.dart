import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:harry_potter_app/providers/character_provider.dart';
import 'package:harry_potter_app/widgets/character_card.dart';
import 'package:harry_potter_app/widgets/error_message_widget.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: (query) {
            ref.read(searchQueryProvider.notifier).state = query;
          },
          decoration: InputDecoration(
            hintText: 'Karakter ara...',
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            suffixIcon:
                searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        FocusScope.of(context).unfocus();
                      },
                    )
                    : null,
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButton<String>(
              value: selectedHouse,
              dropdownColor: Theme.of(context).primaryColor,
              icon: const Icon(Icons.filter_list, color: Colors.white),
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
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
      body: charactersAsyncValue.when(
        data: (characters) {
          if (characters.isEmpty) {
            if (selectedHouse != 'Tümü' || searchController.text.isNotEmpty) {
              return const Center(
                child: Text('Aradığınız kriterlere uygun karakter bulunamadı.'),
              );
            }
            return const Center(child: Text('Karakter bulunamadı.'));
          }
          return RefreshIndicator(
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
        loading: () => const Center(child: CircularProgressIndicator()),
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
    );
  }
}
