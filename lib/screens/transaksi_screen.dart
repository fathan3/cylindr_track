import 'package:flutter/material.dart';
import 'package:cylindr_track/config/theme.dart';
import 'package:cylindr_track/models/models.dart';
import 'package:cylindr_track/services/data_service.dart';
import 'package:intl/intl.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final dataService = DataService();
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  TipeTransaksi? _filterTipe;

  @override
  Widget build(BuildContext context) {
    var transaksi = dataService.getTransaksi();
    if (_filterTipe != null) {
      transaksi = transaksi.where((t) => t.tipe == _filterTipe).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTambahTransaksiDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Semua'),
                    selected: _filterTipe == null,
                    onSelected: (_) {
                      setState(() => _filterTipe = null);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Penjualan'),
                    selected: _filterTipe == TipeTransaksi.penjualan,
                    onSelected: (_) {
                      setState(() => _filterTipe = TipeTransaksi.penjualan);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Pembelian'),
                    selected: _filterTipe == TipeTransaksi.pembelian,
                    onSelected: (_) {
                      setState(() => _filterTipe = TipeTransaksi.pembelian);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Retur'),
                    selected: _filterTipe == TipeTransaksi.retur,
                    onSelected: (_) {
                      setState(() => _filterTipe = TipeTransaksi.retur);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: transaksi.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada transaksi',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: transaksi.length,
                    itemBuilder: (context, index) {
                      final t = transaksi[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            _showTransaksiDetail(context, t);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            t.nomorTransaksi,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            t.namaPelanggan,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getTipeColor(t.tipe)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        t.tipe.label,
                                        style: TextStyle(
                                          color: _getTipeColor(t.tipe),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(t.tanggal),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          formatter.format(t.total),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: t.status.color
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getTipeColor(TipeTransaksi tipe) {
    switch (tipe) {
      case TipeTransaksi.penjualan:
        return Colors.green;
      case TipeTransaksi.pembelian:
        return Colors.blue;
      case TipeTransaksi.retur:
        return Colors.orange;
    }
  }

  void _showTransaksiDetail(BuildContext context, Transaksi transaksi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Detail Transaksi',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    _DetailRow('Nomor Transaksi', transaksi.nomorTransaksi),
                    _DetailRow(
                      'Tanggal',
                      DateFormat('dd/MM/yyyy HH:mm').format(transaksi.tanggal),
                    ),
                    _DetailRow('Pelanggan', transaksi.namaPelanggan),
                    _DetailRow('Tipe', transaksi.tipe.label),
                    _DetailRow('Status', transaksi.status.label),
                    const SizedBox(height: 16),
                    Text(
                      'Item Transaksi',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...transaksi.items.map((item) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: AppTheme.lightGray,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.namaProduk,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.jumlah} x ${formatter.format(item.hargaSatuan)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  Text(
                                    formatter.format(item.subtotal),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    Card(
                      color: AppTheme.cyan.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              formatter.format(transaksi.total),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.cyan,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            );
          },
        );
      },
    );
  }

  void _showTambahTransaksiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Transaksi'),
          content: const Text('Fitur penambahan transaksi akan datang segera.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
