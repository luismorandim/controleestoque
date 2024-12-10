import 'package:flutter/material.dart';

import '../../padrao/tela_padrao.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TelaPadrao(
      titulo: 'Detalhes do Produto',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${product['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Quantidade: ${product['quantity']}'),
            const SizedBox(height: 10),
            Text('Mínimo: ${product['minimum']}'),
          ],
        ),
      ),
    );
  }
}