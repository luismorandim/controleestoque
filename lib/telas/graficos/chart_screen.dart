import 'package:controleestoque/padrao/cores.dart';
import 'package:controleestoque/padrao/tela_padrao.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ChartScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: TelaPadrao(
        titulo: 'Gráficos de Estoque',
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.pie_chart), text: 'Pizza'),
                Tab(icon: Icon(Icons.bar_chart), text: 'Barras'),
                Tab(icon: Icon(Icons.show_chart), text: 'Linhas'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPieChart(context),
                  _buildBarChart(context),
                  _buildLineChart(context),
                ],
              ),
            ),
          ],
        ),
        floatingButton: false,
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final belowMinimum = products.where((p) => p['quantity'] < p['minimum']).length;
    final totalProducts = products.length;
    final percentageWithinStock = ((totalProducts - belowMinimum) / totalProducts) * 100;

    return Column(
      children: [
        Expanded(
          child: SfCircularChart(
            series: <CircularSeries>[
              PieSeries<Map<String, dynamic>, String>(
                dataSource: [
                  {'category': 'Dentro do Estoque', 'value': totalProducts - belowMinimum},
                  {'category': 'Abaixo do Mínimo', 'value': belowMinimum},
                ],
                xValueMapper: (data, _) => data['category'],
                yValueMapper: (data, _) => data['value'],
                pointColorMapper: (data, index) {
                  if (data['category'] == 'Dentro do Estoque') {
                    return Cores.chartPieGreen;
                  }
                  return Cores.chartPieRed;
                },
                explode: true,
                explodeIndex: 1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: Cores.chartPieGreen, size: 12),
                  const SizedBox(width: 8),
                  Text(
                    'Dentro do Estoque',
                    style: TextStyle(color: Cores.textSubtitleColor(context)),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.circle, color: Cores.chartPieRed, size: 12),
                  const SizedBox(width: 8),
                  Text(
                    'Abaixo do Mínimo',
                    style: TextStyle(color: Cores.textSubtitleColor(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${percentageWithinStock.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Cores.textColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'A porcentagem acima representa os produtos que estão dentro do estoque mínimo exigido em relação ao total de produtos cadastrados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Cores.textSubtitleColor(context),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              Center(
                child: Text(
                  'Produtos Dentro do Estoque:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Cores.textSubtitleColor(context),
                  ),
                ),
              ),
              ...products
                  .where((p) => p['quantity'] >= p['minimum'])
                  .map((p) => Text(
                '${p['name']} - Quantidade: ${p['quantity']}',
                style: TextStyle(color: Cores.textColor(context)),
              ))
                  ,
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Produtos Abaixo do Mínimo:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Cores.textSubtitleColor(context),
                  ),
                ),
              ),
              ...products
                  .where((p) => p['quantity'] < p['minimum'])
                  .map((p) => Text(
                '${p['name']} - Quantidade: ${p['quantity']}',
                style: TextStyle(color: Cores.textColor(context)),
              ))
                  ,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  color: Cores.textColor(context),
                ),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  color: Cores.textColor(context),
                ),
              ),
              series: <CartesianSeries>[
                ColumnSeries<Map<String, dynamic>, String>(
                  dataSource: products,
                  xValueMapper: (Map<String, dynamic> data, _) => data['name'],
                  yValueMapper: (Map<String, dynamic> data, _) => data['quantity'],
                  pointColorMapper: (Map<String, dynamic> data, _) =>
                  data['quantity'] < data['minimum']
                      ? Cores.chartBarRed
                      : Cores.chartBarGreen,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: Cores.chartBarGreen, size: 12),
                  const SizedBox(width: 8),
                  Text(
                    'Dentro do Estoque',
                    style: TextStyle(color: Cores.textSubtitleColor(context)),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.circle, color: Cores.chartBarRed, size: 12),
                  const SizedBox(width: 8),
                  Text(
                    'Abaixo do Mínimo',
                    style: TextStyle(color: Cores.textSubtitleColor(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            title: AxisTitle(
              text: 'Produtos',
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(
              text: 'Quantidade',
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            LineSeries<Map<String, dynamic>, String>(
              dataSource: products,
              xValueMapper: (data, _) => data['name'],
              yValueMapper: (data, _) => data['quantity'],
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              color: Cores.textColor(context),
              width: 2,
            ),
          ],
        ),
      ),
    );
  }
}
