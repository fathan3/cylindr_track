import 'package:flutter/material.dart';
import 'package:cylindr_track/config/theme.dart';
import 'package:cylindr_track/models/models.dart';
import 'package:cylindr_track/services/data_service.dart';
import 'package:intl/intl.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Selamat Datang',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Kelola inventory dan penjualan gas LPG',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _StatsGrid(dataService: dataService, formatter: formatter),
            const SizedBox(height: 32),
            Text(
              'Transaksi Terbaru',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _RecentTransactions(dataService: dataService, formatter: formatter),
            const SizedBox(height: 32),
            Text(
              'Produk Stok Rendah',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _LowStockProducts(dataService: dataService),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final DataService dataService;
  final NumberFormat formatter;

  const _StatsGrid({
    required this.dataService,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatCard(
          title: 'Total Penjualan',
          value: formatter.format(dataService.getTotalPenjualan()),
          icon: Icons.trending_up,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Transaksi Pending',
          value: dataService.getTransaksiPending().toString(),
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        _StatCard(
          title: 'Total Produk',
          value: dataService.getTotalProduk().toString(),
          icon: Icons.inventory,
          color: AppTheme.cyan,
        ),
        _StatCard(
          title: 'Total Pelanggan',
          value: dataService.getTotalPelanggan().toString(),
          icon: Icons.people,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  final DataService dataService;
  final NumberFormat formatter;

  const _RecentTransactions({
    required this.dataService,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final transaksi = dataService.getTransaksi().take(3).toList();

    return Column(
      children: transaksi.map((t) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.cyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.receipt, color: AppTheme.cyan),
            ),
            title: Text(t.namaPelanggan),
            subtitle: Text(
              DateFormat('dd/MM/yyyy').format(t.tanggal),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatter.format(t.total),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: t.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    t.status.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: t.status.color,
                    ),
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

class _LowStockProducts extends StatelessWidget {
  final DataService dataService;

  const _LowStockProducts({required this.dataService});

  @override
  Widget build(BuildContext context) {
    final lowStockProducts =
        dataService.getProduk().where((p) => p.stok < 50).toList();

    if (lowStockProducts.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Semua produk stok cukup',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    return Column(
      children: lowStockProducts.map((p) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(p.nama),
            subtitle: Text('SKU: ${p.sku}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Stok: ${p.stok}',
                style: const TextStyle(
                  color: Colors.red,
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
