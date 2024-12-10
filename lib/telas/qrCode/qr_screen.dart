import 'dart:convert';
import 'package:flutter/material.dart';
import '../../model/Product.dart';
import '../../padrao/tela_padrao.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      final processedData = _processQRCode(scanData.code!);

      _handleQRCodeResult(processedData);
    });
  }

  Map<String, dynamic> _processQRCode(String code) {
    try {
      final data = Map<String, dynamic>.from(jsonDecode(code));
      if (data['name'] == null) {
        throw Exception('QR Code incompleto');
      }
      return data;
    } catch (e) {
      return {'name': code}; // Assume que o QR Code contém apenas o nome do produto
    }
  }

  void _handleQRCodeResult(Map<String, dynamic> qrData) {
    final productProvider = context.read<Product>();

    final produto = productProvider.products.firstWhere(
          (prod) => prod['name'] == qrData['name'],
      orElse: () => {},
    );

    if (produto.isNotEmpty) {
      _showUpdateQuantityDialog(produto);
    } else {
      _showNewProductDialog(qrData);
    }
  }


  void _showUpdateQuantityDialog(Map<String, dynamic> produto) {
    final quantityController = TextEditingController(text: produto['quantity'].toString());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Atualizar Quantidade - ${produto['name']}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nova Quantidade',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma quantidade.';
                }
                if (int.tryParse(value) == null || int.parse(value) < 0) {
                  return 'Quantidade inválida.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final novaQuantidade = int.parse(quantityController.text);

                  context.read<Product>().updateQuantity(produto['name'], novaQuantidade);

                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Quantidade de ${produto['name']} atualizada para $novaQuantidade'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }



  void _showNewProductDialog(Map<String, dynamic> qrData) {
    final nameController = TextEditingController(text: qrData['name'] ?? '');
    final quantityController = TextEditingController(text: '10');
    final minimumController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Cadastrar Novo Produto'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome do Produto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome é obrigatório.';
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
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Quantidade inválida.';
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
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Valor mínimo inválido.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final newProduct = {
                    'name': nameController.text,
                    'quantity': int.parse(quantityController.text),
                    'minimum': int.parse(minimumController.text),
                  };

                  context.read<Product>().addProduct(newProduct);

                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop(newProduct);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TelaPadrao(
      titulo: 'Escanear QR Code',
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  controller?.resumeCamera();
                },
                child: const Text('Reiniciar Scanner'),
              ),
            ),
          ),
        ],
      ),
      floatingButton: true,
      floatingButtonIcon: Icons.close,
      onFloatingButtonPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
