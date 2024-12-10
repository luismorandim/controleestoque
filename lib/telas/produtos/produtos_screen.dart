import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/Product.dart';
import '../../padrao/cores.dart';
import '../../padrao/tela_padrao.dart';
import '../../padrao/card_padrao.dart';
import '../qrCode/qr_screen.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  String searchKeyword = '';
  bool showBelowMinimum = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (__, product, _) {
        final filteredProducts = product.products.where((produto) {
          final matchesSearch = produto['name']
              .toLowerCase()
              .contains(searchKeyword.toLowerCase());
          final matchesFilter =
              !showBelowMinimum || produto['quantity'] < produto['minimum'];
          return matchesSearch && matchesFilter;
        }).toList();

        return TelaPadrao(
          hasLeadingButton: true,
          titulo: 'Controle de Estoque',
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Pesquisar por nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                          },
                        ),
                        if (searchKeyword.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                searchKeyword = '';
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchKeyword = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showBelowMinimum = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !showBelowMinimum
                            ? Cores.buttonActive
                            : Cores.buttonInactive,
                      ),
                      child: Text(
                        'Todos',
                        style: TextStyle(
                          color: !showBelowMinimum
                              ? Cores.textButtonActive
                              : Cores.textButtonInactive,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showBelowMinimum = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showBelowMinimum
                            ? Cores.buttonActive
                            : Cores.buttonInactive,
                      ),
                      child: Text(
                        'Abaixo do Mínimo',
                        style: TextStyle(
                          color: showBelowMinimum
                              ? Cores.textButtonActive
                              : Cores.textButtonInactive,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                  child: Text(
                    'Nenhum produto encontrado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final produto = filteredProducts[index];
                    final isBelowMinimum =
                        produto['quantity'] < produto['minimum'];

                    return CardPadrao(
                      titulo: produto['name'],
                      subtitulo:
                      'Quantidade: ${produto['quantity']} | Mínimo: ${produto['minimum']}',
                      isBelowMinimum: isBelowMinimum,
                      trailingIcon: isBelowMinimum
                          ? Icons.warning
                          : Icons.check_circle,
                      onTap: () {
                        _showEditDialog(context, produto, index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingButton: true,
          floatingButtonIcon: Icons.qr_code_scanner,
          onFloatingButtonPressed: () async {
            final scannedData = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const QRCodeScreen(),
              ),
            );

            if (scannedData != null) {
              setState(() {});
            }

          },
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
                      decoration: const InputDecoration(labelText: 'Nome do Produto'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O nome não pode estar vazio.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantidade'),
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
                      decoration: const InputDecoration(labelText: 'Mínimo Permitido'),
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
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormValid ? Cores.primaryColor : Colors.grey,
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
