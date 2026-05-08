import 'package:flutter/material.dart';
import 'package:cylindr_track/config/theme.dart';
import 'package:cylindr_track/models/models.dart';
import 'package:cylindr_track/services/data_service.dart';
import 'package:intl/intl.dart';

class PengirimanScreen extends StatefulWidget {
  const PengirimanScreen({super.key});

  @override
  State<PengirimanScreen> createState() => _PengirimanScreenState();
}

class _PengirimanScreenState extends State<PengirimanScreen> {
  final dataService = DataService();

  @override
  Widget build(BuildContext context) {
    final pengiriman = dataService.getPengiriman();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengiriman'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTambahPengirimanDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: pengiriman.isEmpty
          ? Center(
              child: Text(
                'Belum ada pengiriman',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pengiriman.length,
              itemBuilder: (context, index) {
                final p = pengiriman[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _showDetailPengiriman(context, p),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.nomorPengiriman,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      p.mitraNama,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.cyan.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  p.status,
                                  style: const TextStyle(
                                    color: AppTheme.cyan,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lokasi',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    p.lokasi,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Jumlah Item',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${p.items.length} item',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(p.tanggal),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showDetailPengiriman(BuildContext context, Pengiriman pengiriman) {
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
                      'Detail Pengiriman',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    _DetailRow('Nomor Pengiriman', pengiriman.nomorPengiriman),
                    _DetailRow(
                      'Tanggal',
                      DateFormat('dd/MM/yyyy HH:mm').format(pengiriman.tanggal),
                    ),
                    _DetailRow('Mitra', pengiriman.mitraNama),
                    _DetailRow('Lokasi', pengiriman.lokasi),
                    _DetailRow('Status', pengiriman.status),
                    const SizedBox(height: 16),
                    Text(
                      'Item Pengiriman',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...pengiriman.items.map((item) {
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
                              Text(
                                'Jumlah: ${item.jumlah}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    if (pengiriman.catatan.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Catatan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Card(
                        color: AppTheme.lightGray,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            pengiriman.catatan,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            );
          },
        );
      },
    );
  }

  void _showTambahPengirimanDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _FormTambahPengiriman(dataService: dataService);
      },
    );
  }
}

class _FormTambahPengiriman extends StatefulWidget {
  final DataService dataService;

  const _FormTambahPengiriman({required this.dataService});

  @override
  State<_FormTambahPengiriman> createState() => _FormTambahPengirimanState();
}

class _FormTambahPengirimanState extends State<_FormTambahPengiriman> {
  String? selectedMitra;
  final List<_ItemPengirimanTemp> items = [];
  final catatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mitra = widget.dataService.getMitra();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tambah Pengiriman Baru',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedMitra,
                  hint: const Text('Pilih Mitra'),
                  items: mitra.map((m) {
                    return DropdownMenuItem(
                      value: m.id,
                      child: Text(m.nama),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedMitra = value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Mitra',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Item Pengiriman',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...items.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.namaProduk,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Jumlah: ${item.jumlah}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => items.removeAt(idx));
                                },
                                icon: const Icon(Icons.close, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                ElevatedButton.icon(
                  onPressed: () => _showTambahItemDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Item'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: catatanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Catatan (opsional)',
                    hintText: 'Masukkan catatan pengiriman',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Simpan Pengiriman'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTambahItemDialog(BuildContext context) {
    final produk = widget.dataService.getProduk();
    String? selectedProduk;
    final jumlahController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Item'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedProduk,
                    hint: const Text('Pilih Produk'),
                    items: produk.map((p) {
                      return DropdownMenuItem(
                        value: p.id,
                        child: Text(p.nama),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedProduk = value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Produk',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProduk != null && jumlahController.text.isNotEmpty) {
                  final p = produk.firstWhere((x) => x.id == selectedProduk);
                  this.setState(() {
                    items.add(_ItemPengirimanTemp(
                      produkId: p.id,
                      namaProduk: p.nama,
                      jumlah: int.parse(jumlahController.text),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (selectedMitra == null || items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mitra dan minimal 1 item')),
      );
      return;
    }

    final mitra = widget.dataService.getMitraById(selectedMitra!);
    if (mitra != null) {
      final pengiriman = Pengiriman(
        id: 'pkr-${DateTime.now().millisecondsSinceEpoch}',
        nomorPengiriman: 'PKR-${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}',
        tanggal: DateTime.now(),
        mitraId: mitra.id,
        mitraNama: mitra.nama,
        lokasi: mitra.lokasi,
        items: items.map((i) => ItemPengiriman(
          produkId: i.produkId,
          namaProduk: i.namaProduk,
          jumlah: i.jumlah,
        )).toList(),
        catatan: catatanController.text,
      );

      widget.dataService.addPengiriman(pengiriman);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengiriman berhasil ditambahkan')),
      );
    }
  }

  @override
  void dispose() {
    catatanController.dispose();
    super.dispose();
  }
}

class _ItemPengirimanTemp {
  final String produkId;
  final String namaProduk;
  final int jumlah;

  _ItemPengirimanTemp({
    required this.produkId,
    required this.namaProduk,
    required this.jumlah,
  });
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
