import 'package:flutter/material.dart';
import 'package:cylindr_track/config/theme.dart';
import 'package:cylindr_track/models/models.dart';
import 'package:cylindr_track/services/data_service.dart';
import 'package:intl/intl.dart';

class EvaluasiScreen extends StatelessWidget {
  const EvaluasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Laporan Evaluasi',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Analisis performa bisnis dan pelanggan',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _CustomerPerformance(dataService: dataService, formatter: formatter),
            const SizedBox(height: 24),
            _TransactionAnalysis(dataService: dataService),
            const SizedBox(height: 24),
            _ProductPerformance(dataService: dataService),
            const SizedBox(height: 24),
            _HealthIndicators(dataService: dataService, formatter: formatter),
          ],
        ),
      ),
    );
  }
}

class _CustomerPerformance extends StatelessWidget {
  final DataService dataService;
  final NumberFormat formatter;

  const _CustomerPerformance({
    required this.dataService,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final pelanggan = dataService.getPelanggan();
    final topCustomers = List<Pelanggan>.from(pelanggan)
      ..sort((a, b) => b.totalBelanja.compareTo(a.totalBelanja));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performa Pelanggan',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _CustomerStat(
                  label: 'Total Pelanggan',
                  value: pelanggan.length.toString(),
                  icon: Icons.people,
                  color: Colors.purple,
                ),
                const Divider(height: 16),
                _CustomerStat(
                  label: 'Rata-rata Belanja',
                  value: formatter.format(
                    pelanggan.isEmpty
                        ? 0
                        : pelanggan
                                .fold<double>(
                                    0, (sum, p) => sum + p.totalBelanja) /
                            pelanggan.length,
                  ),
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Top Pelanggan',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        ...topCustomers.take(3).map((p) {
          final index = topCustomers.indexOf(p) + 1;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: AppTheme.cyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              title: Text(p.nama),
              subtitle: Text('${p.jumlahTransaksi} transaksi'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatter.format(p.totalBelanja),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _CustomerStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _CustomerStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionAnalysis extends StatelessWidget {
  final DataService dataService;

  const _TransactionAnalysis({required this.dataService});

  @override
  Widget build(BuildContext context) {
    final transaksi = dataService.getTransaksi();
    final penjualan = transaksi.where((t) => t.tipe == TipeTransaksi.penjualan);
    final pembelian = transaksi.where((t) => t.tipe == TipeTransaksi.pembelian);
    final retur = transaksi.where((t) => t.tipe == TipeTransaksi.retur);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analisis Transaksi',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _TransactionStat(
                  label: 'Total Penjualan',
                  value: penjualan.length.toString(),
                  color: Colors.green,
                ),
                const Divider(height: 16),
                _TransactionStat(
                  label: 'Total Pembelian',
                  value: pembelian.length.toString(),
                  color: Colors.blue,
                ),
                const Divider(height: 16),
                _TransactionStat(
                  label: 'Total Retur',
                  value: retur.length.toString(),
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TransactionStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TransactionStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductPerformance extends StatelessWidget {
  final DataService dataService;

  const _ProductPerformance({required this.dataService});

  @override
  Widget build(BuildContext context) {
    final produk = dataService.getProduk();
    final goodStock = produk.where((p) => p.stok >= 100).length;
    final mediumStock = produk.where((p) => p.stok >= 50 && p.stok < 100).length;
    final lowStock = produk.where((p) => p.stok < 50).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Produk',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _ProductStatusBar(
                  label: 'Stok Bagus (≥100)',
                  value: goodStock,
                  total: produk.length,
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _ProductStatusBar(
                  label: 'Stok Sedang (50-99)',
                  value: mediumStock,
                  total: produk.length,
                  color: Colors.orange,
                ),
                const SizedBox(height: 12),
                _ProductStatusBar(
                  label: 'Stok Rendah (<50)',
                  value: lowStock,
                  total: produk.length,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductStatusBar extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _ProductStatusBar({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : (value / total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text('$value/$total', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _HealthIndicators extends StatelessWidget {
  final DataService dataService;
  final NumberFormat formatter;

  const _HealthIndicators({
    required this.dataService,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final transaksi = dataService.getTransaksi();
    final successRate = transaksi.isEmpty
        ? 0
        : (transaksi.where((t) => t.status == StatusTransaksi.selesai).length /
                transaksi.length *
                100)
            .toStringAsFixed(1);

    final produk = dataService.getProduk();
    final avgStok =
        produk.isEmpty ? 0 : (produk.fold<int>(0, (sum, p) => sum + p.stok) / produk.length).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Indikator Kesehatan',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _HealthIndicator(
                  label: 'Tingkat Keberhasilan Transaksi',
                  value: '$successRate%',
                  status: double.parse(successRate) >= 80
                      ? 'Bagus'
                      : double.parse(successRate) >= 60
                          ? 'Cukup'
                          : 'Perlu Perbaikan',
                  statusColor: double.parse(successRate) >= 80
                      ? Colors.green
                      : double.parse(successRate) >= 60
                          ? Colors.orange
                          : Colors.red,
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                _HealthIndicator(
                  label: 'Rata-rata Stok Produk',
                  value: '$avgStok unit',
                  status: int.parse(avgStok) >= 75
                      ? 'Bagus'
                      : int.parse(avgStok) >= 50
                          ? 'Cukup'
                          : 'Perlu Restock',
                  statusColor: int.parse(avgStok) >= 75
                      ? Colors.green
                      : int.parse(avgStok) >= 50
                          ? Colors.orange
                          : Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HealthIndicator extends StatelessWidget {
  final String label;
  final String value;
  final String status;
  final Color statusColor;

  const _HealthIndicator({
    required this.label,
    required this.value,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
