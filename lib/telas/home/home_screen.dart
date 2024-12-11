import 'package:controleestoque/model/login_manager.dart';
import 'package:controleestoque/padrao/cores.dart';
import 'package:controleestoque/padrao/tela_padrao.dart';
import 'package:controleestoque/telas/home/home_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:controleestoque/telas/produtos/produtos_screen.dart';
import 'package:controleestoque/telas/graficos/chart_screen.dart';
import 'package:provider/provider.dart';
import '../../model/Product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer2<Product, LoginManager>(
      builder: (__, product, loginManager, _) {
        final user = loginManager.loggedInUser;

        return TelaPadrao(
          hasLeadingButton: false,
          titulo: 'Dashboard'.i18n,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Olá,'.i18n + ' ${user?['name']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildDashboardCard(
                      context,
                      icon: Icons.inventory,
                      title: 'Produtos'.i18n,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProdutosScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.bar_chart,
                      title: 'Gráficos'.i18n,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChartScreen(products: product.products),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingButton: false,
        );
      },
    );

  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Cores.cardBackgroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 120,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
