import 'package:flutter/material.dart';
import 'package:cylindr_track/config/theme.dart';
import 'package:cylindr_track/models/models.dart';
import 'package:cylindr_track/services/data_service.dart';
import 'package:intl/intl.dart';

class RepurchasingScreen extends StatefulWidget {
  const RepurchasingScreen({super.key});

  @override
  State<RepurchasingScreen> createState() => _RepurchasingScreenState();
}

class _RepurchasingScreenState extends State<RepurchasingScreen> {
  final dataService = DataService();

  @override
  void initState() {
    super.initState();
    dataService.generateAlertsForInactivePartners();
  }

  @override
  Widget build(BuildContext context) {
    final evaluasi = dataService.getEvaluasi();
    final pending = evaluasi.where((e) => e.status == 'belum_ditindak').toList();
    final actionTaken = evaluasi.where((e) => e.status != 'belum_ditindak').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluasi Repurchasing'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Alert Pending'),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          pending.length.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah Ditindak'),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          actionTaken.length.toString(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  pending.isEmpty
                      ? Center(
                          child: Text(
                            'Tidak ada alert pending',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: pending.length,
                          itemBuilder: (context, index) {
                            final e = pending[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.mitraNama,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Alert ${DateFormat('dd/MM/yyyy').format(e.tanggalAlert)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            '⚠️ Alert',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Sudah ${e.hariTanpaPengiriman} hari tidak ada pengiriman ke klien ini',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors.orange[800],
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            _showEvaluasiDialog(context, e),
                                        child: const Text('Ambil Tindakan'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  actionTaken.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada tindakan yang diambil',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: actionTaken.length,
                          itemBuilder: (context, index) {
                            final e = actionTaken[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
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
                                                e.mitraNama,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Tindakan ${DateFormat('dd/MM/yyyy').format(e.tanggalTindakan ?? DateTime.now())}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            '✓ Selesai',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Card(
                                      color: AppTheme.lightGray,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tindakan: ${e.status}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                            const SizedBox(height: 4),
                                            if (e.tindakan != null)
                                              Text(
                                                e.tindakan!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEvaluasiDialog(BuildContext context, EvaluasiRepurchasing evaluasi) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Evaluasi: ${evaluasi.mitraNama}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi:',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Hari tanpa pengiriman:'),
                        Text(
                          '${evaluasi.hariTanpaPengiriman} hari',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pilih tindakan:',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                dataService.updateEvaluasiStatus(
                  evaluasi.id,
                  'follow_up',
                  'Melakukan follow up dengan klien',
                );
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Follow up dicatat')),
                );
              },
              child: const Text('Follow Up'),
            ),
            ElevatedButton(
              onPressed: () {
                _showPengirimanDialog(context, evaluasi);
              },
              child: const Text('Kirim Sekarang'),
            ),
          ],
        );
      },
    );
  }

  void _showPengirimanDialog(BuildContext context, EvaluasiRepurchasing evaluasi) {
    Navigator.pop(context);

    final mitra = dataService.getMitraById(evaluasi.mitraId);
    if (mitra != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Siap mengirim ke ${mitra.nama}'),
          action: SnackBarAction(
            label: 'Atur Pengiriman',
            onPressed: () {
              dataService.updateEvaluasiStatus(
                evaluasi.id,
                'pengiriman_dijadwalkan',
                'Pengiriman baru dijadwalkan',
              );
              setState(() {});
            },
          ),
        ),
      );
    }
  }
}
