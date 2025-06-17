import 'package:flutter/material.dart';

class MagicText extends StatelessWidget {
  final String text;
  final double fontSize;

  const MagicText(this.text, {super.key, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback:
          (bounds) => const LinearGradient(
            colors: [Color(0xFFFFC107), Color(0xFFFFF176), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          // GoogleFonts.cinzelDecorative yerine TextStyle kullanıldı
          fontFamily: 'HarryPotter', // Özel yazı tipi ailesini burada belirtin
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
