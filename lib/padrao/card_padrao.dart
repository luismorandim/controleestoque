import 'package:flutter/material.dart';
import 'cores.dart';

class CardPadrao extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final bool isBelowMinimum;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  const CardPadrao({
    Key? key,
    required this.titulo,
    required this.subtitulo,
    required this.isBelowMinimum,
    required this.trailingIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        color: isBelowMinimum ? Cores.warningCard : Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Cores.borderPadrao,
            width: 1.0,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          title: Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Cores.cardFontPadrao,
            ),
          ),
          subtitle: Text(
            subtitulo,
            style: TextStyle(
              color: Cores.cardFontPadrao,
            ),
          ),
          trailing: Icon(
            trailingIcon,
            color: isBelowMinimum ? Cores.alertStatus : Cores.normalStatus,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
