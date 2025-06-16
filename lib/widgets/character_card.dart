import 'package:flutter/material.dart';
import 'package:harry_potter_app/models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğine göre boyutlandırma
    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Karakter resmi
            // character.image artık String? olabilir, bu yüzden null kontrolü gerekli
            if (character.image != null &&
                character
                    .image!
                    .isNotEmpty) // .isNotEmpty'tan önce null değil mi kontrolü
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  character
                      .image!, // Null olmadığını garanti etmek için ! kullanıldı
                  width: screenWidth * 0.25, // Ekran genişliğinin %25'i
                  height: screenWidth * 0.25,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        color: Colors.grey[300],
                        child: Icon(Icons.person, size: screenWidth * 0.15),
                      ),
                ),
              )
            else
              Container(
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.person,
                  size: screenWidth * 0.15,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // character.house artık String? olabilir
                  Text(
                    'Evi: ${character.house != null && character.house!.isNotEmpty ? character.house! : 'Bilinmiyor'}',
                  ),
                  Text('Tür: ${character.species}'),
                  // character.actor artık String? olabilir
                  if (character.actor != null && character.actor!.isNotEmpty)
                    Text('Aktör: ${character.actor!}'),
                  if (character.alive)
                    const Text(
                      'Durum: Hayatta',
                      style: TextStyle(color: Colors.green),
                    ),
                  if (!character.alive)
                    const Text(
                      'Durum: Ölü',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
