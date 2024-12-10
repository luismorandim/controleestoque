import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/Product.dart';
import '../../padrao/cores.dart';
import '../../padrao/tela_padrao.dart';
import '../../padrao/card_padrao.dart';

class HomeScreen extends StatelessWidget {
  String searchKeyword = '';
  bool showBelowMinimum = false;


  @override
  Widget build(BuildContext context) {

    return Consumer <Product> (
      builder: (__, product, _) {
        return TelaPadrao(
          hasLeadingButton: false,
          titulo: 'Controle de Estoque',
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: product.products.length,
              itemBuilder: (context, index) {
                final produto = product.products[index];
                final isBelowMinimum = produto['quantity'] < produto['minimum'];

                return CardPadrao(
                  titulo: produto['name'],
                  subtitulo: 'Quantidade: ${produto['quantity']} | Mínimo: ${produto['minimum']}',
                  isBelowMinimum: isBelowMinimum,
                  trailingIcon: isBelowMinimum ? Icons.warning : Icons.check_circle,
                  onTap: () {
                    _showEditDialog(context, produto, index);
                  },
                );
              },
            ),
          ),
          floatingButton: false,
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> product, int index) {
    final nameController = TextEditingController(text: product['name']);
    final quantityController = TextEditingController(text: product['quantity'].toString());
    final minimumController = TextEditingController(text: product['minimum'].toString());
    final produto = context.read<Product>();

    final formKey = GlobalKey<FormState>();
    bool isFormValid = false;

    void validateForm() {
      isFormValid = formKey.currentState?.validate() ?? false;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Produto'),
              content: Form(
                key: formKey,
                onChanged: () {
                  setState(() {
                    validateForm();
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Produto',
                        errorStyle: TextStyle(color: Colors.redAccent),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O nome não pode estar vazio.';
                        }
                        return null;
                      },
                      autofocus: true,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        errorStyle: TextStyle(color: Colors.redAccent),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A quantidade é obrigatória.';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number < 0) {
                          return 'A quantidade deve ser um número positivo.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: minimumController,
                      decoration: const InputDecoration(
                        labelText: 'Mínimo Permitido',
                        errorStyle: TextStyle(color: Colors.redAccent),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O mínimo permitido é obrigatório.';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number < 0) {
                          return 'O mínimo permitido deve ser um número positivo.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edição cancelada.'),
                        backgroundColor: Colors.grey,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                    final updatedProduct = {
                      'name': nameController.text,
                      'quantity': int.tryParse(quantityController.text) ?? 0,
                      'minimum': int.tryParse(minimumController.text) ?? 0,
                    };

                    produto.updateProduct(index, updatedProduct);

                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Produto atualizado com sucesso!'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Desfazer',
                          textColor: Colors.white,
                          onPressed: () {
                            produto.updateProduct(index, product);
                          },
                        ),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormValid ? Cores.primaryColor : Colors.grey,
                  ),
                  child: const Text('Salvar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
