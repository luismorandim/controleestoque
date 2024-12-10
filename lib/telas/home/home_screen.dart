import 'package:controleestoque/telas/home/produtos_detalhes.dart';
import 'package:flutter/material.dart';
import '../../padrao/tela_padrao.dart';
import '../../padrao/card_padrao.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {'name': 'Produto A', 'quantity': 5, 'minimum': 10},
    {'name': 'Produto B', 'quantity': 7, 'minimum': 10},
    {'name': 'Produto C', 'quantity': 3, 'minimum': 10},
    {'name': 'Produto D', 'quantity': 15, 'minimum': 10},
    {'name': 'Produto E', 'quantity': 9, 'minimum': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return TelaPadrao(
      hasLeadingButton: false,
      titulo: 'Controle de Estoque',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isBelowMinimum = product['quantity'] < product['minimum'];

            return CardPadrao(
              titulo: product['name'],
              subtitulo: 'Quantidade: ${product['quantity']} | Mínimo: ${product['minimum']}',
              isBelowMinimum: isBelowMinimum,
              trailingIcon: isBelowMinimum ? Icons.warning : Icons.check_circle,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ));
              },
            );
          },
        ),
      ),
      floatingButton: false,
    );
  }
}
