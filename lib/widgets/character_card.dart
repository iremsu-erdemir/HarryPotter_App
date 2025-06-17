import 'package:flutter/material.dart';
import 'package:harry_potter_app/models/character.dart';
import 'package:lottie/lottie.dart';

class CharacterCard extends StatefulWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = ColorTween(
      begin: const Color(0xFFFFC107), // Gold
      end: const Color(0xFFFFF176), // Açık altın sarısı
    ).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Sabit renkler (animasyon kapalı)
    const Color deepNightBlue = Color(0xFF2E1A47);
    const Color darkPurple = Color(0xFF3B2C5A);
    const Color goldColor = Color(0xFFFFC107);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 14,
      shadowColor: const Color.fromARGB(255, 212, 48, 89).withOpacity(0.7),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [deepNightBlue, darkPurple],
          ),
          border: Border.all(
            color: const Color.fromARGB(255, 189, 95, 119).withOpacity(0.7),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 204, 55, 92).withOpacity(0.7),
              blurRadius: 20,
              spreadRadius: 3,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              width: screenWidth * 0.25,
              height: screenWidth * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3A4A72), Color(0xFF2E3B5E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: const Color(0xFF800020).withOpacity(0.7),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child:
                  character.image != null && character.image!.isNotEmpty
                      ? Image.network(
                        character.image!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.person,
                                size: screenWidth * 0.15,
                                color: Colors.grey[500],
                              ),
                            ),
                      )
                      : Container(
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.person,
                          size: screenWidth * 0.15,
                          color: Colors.grey[500],
                        ),
                      ),
            ),
            // Resim ile metin içeriği arasındaki boşluğu ayarlama
            const SizedBox(width: 80), // Boşluğu 60'tan 20'ye düşürüldü
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 212, 15, 90),
                      shadows: [
                        Shadow(
                          color: Colors.orangeAccent,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    label: 'Evi',
                    value:
                        character.house?.isNotEmpty == true
                            ? character.house!
                            : 'Bilinmiyor',
                    color: goldColor,
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    label: 'Tür',
                    value: character.species,
                    color: goldColor,
                  ),
                  if (character.actor != null &&
                      character.actor!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _infoRow(
                      label: 'Aktör',
                      value: character.actor!,
                      color: goldColor,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              character.alive
                                  ? const Color(0xFF1B5E20)
                                  : const Color(0xFF800020),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: (character.alive
                                      ? const Color(0xFF1B5E20)
                                      : const Color(0xFF800020))
                                  .withOpacity(0.85),
                              blurRadius: 16,
                              spreadRadius: 1,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.12),
                              blurRadius: 4,
                              offset: const Offset(-1, -2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 22,
                        ),
                        child: Text(
                          character.alive ? 'Hayatta' : 'Ölü',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Lottie.asset(
                          character.alive
                              ? 'assets/lottie/alive.json'
                              : 'assets/lottie/dead.json',
                          repeat: true,
                          animate: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
            shadows: [
              Shadow(
                color: const Color.fromARGB(
                  255,
                  255,
                  253,
                  253,
                ).withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
