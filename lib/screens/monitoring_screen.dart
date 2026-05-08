import 'package:flutter/material.dart';
import 'package:cylindr_track/config/theme.dart';
import 'package:cylindr_track/models/models.dart';
import 'package:cylindr_track/services/data_service.dart';
import 'package:intl/intl.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analisis Inventory',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _InventoryOverview(dataService: dataService),
            const SizedBox(height: 24),
            Text(
              'Stok Produk',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _StockChart(dataService: dataService),
            const SizedBox(height: 24),
            Text(
              'Performa Penjualan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _SalesPerformance(dataService: dataService, formatter: formatter),
            const SizedBox(height: 24),
            Text(
              'Top Produk',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _TopProducts(dataService: dataService, formatter: formatter),
          ],
        ),
      ),
    );
  }
}

class _InventoryOverview extends StatelessWidget {
  final DataService dataService;

  const _InventoryOverview({required this.dataService});

  @override
  Widget build(BuildContext context) {
    final produk = dataService.getProduk();
    final totalStok = produk.fold<int>(0, (sum, p) => sum + p.stok);
    final lowStock = produk.where((p) => p.stok < 50).length;
    final outOfStock = produk.where((p) => p.stok == 0).length;
    final goodStock = produk.where((p) => p.stok >= 50).length;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _OverviewItem(
                      label: 'Total Stok',
                      value: totalStok.toString(),
                      color: Colors.green,
                    ),
                    _OverviewItem(
                      label: 'Stok Baik',
                      value: goodStock.toString(),
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _OverviewItem(
                      label: 'Stok Rendah',
                      value: lowStock.toString(),
                      color: Colors.orange,
                    ),
                    _OverviewItem(
                      label: 'Habis',
                      value: outOfStock.toString(),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _OverviewItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StockChart extends StatelessWidget {
  final DataService dataService;

  const _StockChart({required this.dataService});

  @override
  Widget build(BuildContext context) {
    final produk = dataService.getProduk();

    return Column(
      children: produk.map((p) {
        final percentage = (p.stok / 200 * 100).clamp(0, 100);
        final barColor = p.stok < 50
            ? Colors.red
            : p.stok < 100
                ? Colors.orange
                : Colors.green;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        p.nama,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${p.stok} unit',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(barColor),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SalesPerformance extends StatelessWidget {
  final DataService dataService;
  final NumberFormat formatter;

  const _SalesPerformance({
    required this.dataService,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final transaksi = dataService.getTransaksi();
    final totalSales = transaksi
        .where((t) =>
            t.tipe == TipeTransaksi.penjualan &&
            t.status == StatusTransaksi.selesai)
        .fold<double>(0, (sum, t) => sum + t.total);
    final completedTx =
        transaksi.where((t) => t.status == StatusTransaksi.selesai).length;
    final pendingTx =
        transaksi.where((t) => t.status == StatusTransaksi.pending).length;
    final cancelledTx =
        transaksi.where((t) => t.status == StatusTransaksi.batal).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Penjualan',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              formatter.format(totalSales),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.cyan,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PerformanceItem(
                    label: 'Selesai',
                    value: completedTx,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PerformanceItem(
                    label: 'Pending',
                    value: pendingTx,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PerformanceItem(
                    label: 'Batal',
                    value: cancelledTx,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _PerformanceItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TopProducts extends StatelessWidget {
  final DataService dataService;
  final NumberFormat formatter;

  const _TopProducts({
    required this.dataService,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final transaksi = dataService.getTransaksi();
    final productSales = <String, int>{};

    for (var t in transaksi) {
      for (var item in t.items) {
        productSales[item.namaProduk] = (productSales[item.namaProduk] ?? 0) + item.jumlah;
      }
    }

    final topProducts = productSales.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: topProducts.take(5).map((entry) {
        final index = topProducts.indexOf(entry) + 1;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.cyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  '#$index',
                  style: const TextStyle(
                    color: AppTheme.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            title: Text(entry.key),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.cyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${entry.value} sold',
                style: const TextStyle(
                  color: AppTheme.cyan,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
