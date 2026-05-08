import 'package:cylindr_track/models/models.dart';

class DataService {
  static final List<Produk> _produk = [
    Produk(
      id: '1',
      nama: 'Silinder Gas LPG 3kg',
      sku: 'LPG-3KG-001',
      stok: 150,
      harga: 35000,
      kategori: 'LPG',
    ),
    Produk(
      id: '2',
      nama: 'Silinder Gas LPG 12kg',
      sku: 'LPG-12KG-001',
      stok: 75,
      harga: 95000,
      kategori: 'LPG',
    ),
    Produk(
      id: '3',
      nama: 'Regulator Gas Tekanan Rendah',
      sku: 'REG-TR-001',
      stok: 45,
      harga: 65000,
      kategori: 'Aksesori',
    ),
    Produk(
      id: '4',
      nama: 'Selang Gas 2 Meter',
      sku: 'SELANG-2M-001',
      stok: 120,
      harga: 25000,
      kategori: 'Aksesori',
    ),
    Produk(
      id: '5',
      nama: 'Manometer Gas',
      sku: 'MANO-001',
      stok: 32,
      harga: 85000,
      kategori: 'Aksesori',
    ),
  ];

  static final List<Mitra> _mitra = [
    Mitra(
      id: '1',
      nama: 'PT Maju Jaya',
      lokasi: 'Surabaya',
      nomorTelepon: '081234567890',
      alamat: 'Jl. Raya Industri No. 45',
      tanggalKerjasama: DateTime.now().subtract(const Duration(days: 120)),
      tanggalPengirimanTerakhir: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Mitra(
      id: '2',
      nama: 'Toko Mitra Usaha',
      lokasi: 'Sidoarjo',
      nomorTelepon: '082345678901',
      alamat: 'Jl. Perdagangan No. 12',
      tanggalKerjasama: DateTime.now().subtract(const Duration(days: 90)),
      tanggalPengirimanTerakhir: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Mitra(
      id: '3',
      nama: 'CV Bersama Maju',
      lokasi: 'Gresik',
      nomorTelepon: '083456789012',
      alamat: 'Jl. Kebun Raya No. 78',
      tanggalKerjasama: DateTime.now().subtract(const Duration(days: 60)),
      tanggalPengirimanTerakhir: DateTime.now().subtract(const Duration(days: 35)),
    ),
  ];

  static final List<Pengiriman> _pengiriman = [
    Pengiriman(
      id: '1',
      nomorPengiriman: 'PKR-001/2024',
      tanggal: DateTime.now().subtract(const Duration(days: 5)),
      mitraId: '1',
      mitraNama: 'PT Maju Jaya',
      lokasi: 'Surabaya',
      items: [
        ItemPengiriman(produkId: '2', namaProduk: 'Silinder Gas LPG 12kg', jumlah: 10),
      ],
      catatan: 'Pengiriman reguler',
    ),
    Pengiriman(
      id: '2',
      nomorPengiriman: 'PKR-002/2024',
      tanggal: DateTime.now().subtract(const Duration(days: 12)),
      mitraId: '2',
      mitraNama: 'Toko Mitra Usaha',
      lokasi: 'Sidoarjo',
      items: [
        ItemPengiriman(produkId: '1', namaProduk: 'Silinder Gas LPG 3kg', jumlah: 30),
        ItemPengiriman(produkId: '3', namaProduk: 'Regulator Gas Tekanan Rendah', jumlah: 5),
      ],
      catatan: 'Pengiriman tambahan',
    ),
  ];

  static final List<StokMitra> _stokMitra = [
    StokMitra(
      mitraId: '1',
      mitraNama: 'PT Maju Jaya',
      produkId: '1',
      namaProduk: 'Silinder Gas LPG 3kg',
      stokTerpinjam: 25,
      tanggalPengirimanTerakhir: DateTime.now().subtract(const Duration(days: 5)),
    ),
    StokMitra(
      mitraId: '1',
      mitraNama: 'PT Maju Jaya',
      produkId: '2',
      namaProduk: 'Silinder Gas LPG 12kg',
      stokTerpinjam: 10,
      tanggalPengirimanTerakhir: DateTime.now().subtract(const Duration(days: 5)),
    ),
    StokMitra(
      mitraId: '2',
      mitraNama: 'Toko Mitra Usaha',
      produkId: '1',
      namaProduk: 'Silinder Gas LPG 3kg',
      stokTerpinjam: 30,
      tanggalPengirimanTerakhir: DateTime.now().subtract(const Duration(days: 12)),
    ),
    StokMitra(
      mitraId: '3',
      mitraNama: 'CV Bersama Maju',
      produkId: '2',
      namaProduk: 'Silinder Gas LPG 12kg',
      stokTerpinjam: 15,
      tanggalPengirimanTerakhir: DateTime.now().subtract(const Duration(days: 35)),
    ),
  ];

  static final List<EvaluasiRepurchasing> _evaluasi = [
    EvaluasiRepurchasing(
      id: '1',
      mitraId: '3',
      mitraNama: 'CV Bersama Maju',
      hariTanpaPengiriman: 35,
      tanggalAlert: DateTime.now().subtract(const Duration(days: 5)),
      status: 'belum_ditindak',
    ),
  ];

  static final List<Transaksi> _transaksi = [
    Transaksi(
      id: '1',
      nomorTransaksi: 'TRX-001/2024',
      tanggal: DateTime.now().subtract(const Duration(days: 5)),
      tipe: TipeTransaksi.penjualan,
      namaPelanggan: 'PT Maju Jaya',
      items: [
        ItemTransaksi(
          produkId: '2',
          namaProduk: 'Silinder Gas LPG 12kg',
          jumlah: 10,
          hargaSatuan: 95000,
          subtotal: 950000,
        ),
      ],
      total: 950000,
      status: StatusTransaksi.selesai,
    ),
    Transaksi(
      id: '2',
      nomorTransaksi: 'TRX-002/2024',
      tanggal: DateTime.now().subtract(const Duration(days: 3)),
      tipe: TipeTransaksi.penjualan,
      namaPelanggan: 'Toko Mitra Usaha',
      items: [
        ItemTransaksi(
          produkId: '1',
          namaProduk: 'Silinder Gas LPG 3kg',
          jumlah: 30,
          hargaSatuan: 35000,
          subtotal: 1050000,
        ),
        ItemTransaksi(
          produkId: '3',
          namaProduk: 'Regulator Gas Tekanan Rendah',
          jumlah: 5,
          hargaSatuan: 65000,
          subtotal: 325000,
        ),
      ],
      total: 1375000,
      status: StatusTransaksi.selesai,
    ),
    Transaksi(
      id: '3',
      nomorTransaksi: 'TRX-003/2024',
      tanggal: DateTime.now(),
      tipe: TipeTransaksi.penjualan,
      namaPelanggan: 'CV Bersama Maju',
      items: [
        ItemTransaksi(
          produkId: '2',
          namaProduk: 'Silinum Gas LPG 12kg',
          jumlah: 5,
          hargaSatuan: 95000,
          subtotal: 475000,
        ),
      ],
      total: 475000,
      status: StatusTransaksi.pending,
    ),
  ];

  static final List<Pelanggan> _pelanggan = [
    Pelanggan(
      id: '1',
      nama: 'PT Maju Jaya',
      nomorTelepon: '081234567890',
      email: 'info@majujaya.com',
      alamat: 'Jl. Raya Industri No. 45',
      kota: 'Surabaya',
      tanggalTerdaftar: DateTime.now().subtract(const Duration(days: 120)),
      totalBelanja: 2500000,
      jumlahTransaksi: 8,
    ),
    Pelanggan(
      id: '2',
      nama: 'Toko Mitra Usaha',
      nomorTelepon: '082345678901',
      email: 'toko@mitrausaha.com',
      alamat: 'Jl. Perdagangan No. 12',
      kota: 'Sidoarjo',
      tanggalTerdaftar: DateTime.now().subtract(const Duration(days: 90)),
      totalBelanja: 3200000,
      jumlahTransaksi: 12,
    ),
    Pelanggan(
      id: '3',
      nama: 'CV Bersama Maju',
      nomorTelepon: '083456789012',
      email: 'cv@bersamamaju.com',
      alamat: 'Jl. Kebun Raya No. 78',
      kota: 'Gresik',
      tanggalTerdaftar: DateTime.now().subtract(const Duration(days: 60)),
      totalBelanja: 1800000,
      jumlahTransaksi: 5,
    ),
  ];

  // Getters
  List<Produk> getProduk() => _produk;
  List<Transaksi> getTransaksi() => _transaksi;
  List<Pelanggan> getPelanggan() => _pelanggan;
  List<Mitra> getMitra() => _mitra;
  List<Pengiriman> getPengiriman() => _pengiriman;
  List<StokMitra> getStokMitra() => _stokMitra;
  List<EvaluasiRepurchasing> getEvaluasi() => _evaluasi;

  Mitra? getMitraById(String id) {
    try {
      return _mitra.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  Produk? getProdukById(String id) {
    try {
      return _produk.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<StokMitra> getStokByMitra(String mitraId) {
    return _stokMitra.where((s) => s.mitraId == mitraId).toList();
  }

  List<Pengiriman> getPengirimanByMitra(String mitraId) {
    return _pengiriman.where((p) => p.mitraId == mitraId).toList();
  }

  void addPengiriman(Pengiriman pengiriman) {
    _pengiriman.insert(0, pengiriman);
    
    final mitra = getMitraById(pengiriman.mitraId);
    if (mitra != null) {
      mitra.tanggalPengirimanTerakhir = pengiriman.tanggal;
    }

    for (var item in pengiriman.items) {
      final existingStok = _stokMitra.where(
        (s) => s.mitraId == pengiriman.mitraId && s.produkId == item.produkId,
      );

      if (existingStok.isNotEmpty) {
        final oldStok = existingStok.first;
        _stokMitra.remove(oldStok);
        _stokMitra.add(StokMitra(
          mitraId: pengiriman.mitraId,
          mitraNama: pengiriman.mitraNama,
          produkId: item.produkId,
          namaProduk: item.namaProduk,
          stokTerpinjam: oldStok.stokTerpinjam + item.jumlah,
          tanggalPengirimanTerakhir: pengiriman.tanggal,
        ));
      } else {
        _stokMitra.add(StokMitra(
          mitraId: pengiriman.mitraId,
          mitraNama: pengiriman.mitraNama,
          produkId: item.produkId,
          namaProduk: item.namaProduk,
          stokTerpinjam: item.jumlah,
          tanggalPengirimanTerakhir: pengiriman.tanggal,
        ));
      }
    }

    _removeEvaluasiAlert(pengiriman.mitraId);
  }

  void _removeEvaluasiAlert(String mitraId) {
    _evaluasi.removeWhere((e) => e.mitraId == mitraId && e.status == 'belum_ditindak');
  }

  void addEvaluasi(EvaluasiRepurchasing evaluasi) {
    _evaluasi.add(evaluasi);
  }

  void updateEvaluasiStatus(String evaluasiId, String status, String tindakan) {
    final index = _evaluasi.indexWhere((e) => e.id == evaluasiId);
    if (index != -1) {
      final old = _evaluasi[index];
      _evaluasi[index] = EvaluasiRepurchasing(
        id: old.id,
        mitraId: old.mitraId,
        mitraNama: old.mitraNama,
        hariTanpaPengiriman: old.hariTanpaPengiriman,
        tanggalAlert: old.tanggalAlert,
        status: status,
        tindakan: tindakan,
        tanggalTindakan: DateTime.now(),
      );
    }
  }

  void generateAlertsForInactivePartners() {
    for (var mitra in _mitra) {
      if (mitra.perluAlert) {
        final existingAlert = _evaluasi.firstWhere(
          (e) => e.mitraId == mitra.id && e.status == 'belum_ditindak',
          orElse: () => EvaluasiRepurchasing(
            id: '',
            mitraId: '',
            mitraNama: '',
            hariTanpaPengiriman: 0,
            tanggalAlert: DateTime.now(),
          ),
        );

        if (existingAlert.id.isEmpty) {
          _evaluasi.add(EvaluasiRepurchasing(
            id: 'eval-${DateTime.now().millisecondsSinceEpoch}',
            mitraId: mitra.id,
            mitraNama: mitra.nama,
            hariTanpaPengiriman: mitra.hariTanpaPengiriman,
            tanggalAlert: DateTime.now(),
          ));
        }
      }
    }
  }

  List<Mitra> getMitraWithPendingAlerts() {
    return _mitra.where((m) => m.perluAlert).toList();
  }

  void addTransaksi(Transaksi transaksi) {
    _transaksi.insert(0, transaksi);
  }

  void updateProdukStok(String produkId, int jumlahBaru) {
    final index = _produk.indexWhere((p) => p.id == produkId);
    if (index != -1) {
      _produk[index] = Produk(
        id: _produk[index].id,
        nama: _produk[index].nama,
        sku: _produk[index].sku,
        stok: jumlahBaru,
        harga: _produk[index].harga,
        kategori: _produk[index].kategori,
      );
    }
  }

  double getTotalPenjualan() {
    return _transaksi
        .where((t) =>
            t.tipe == TipeTransaksi.penjualan &&
            t.status == StatusTransaksi.selesai)
        .fold(0, (sum, t) => sum + t.total);
  }

  int getTransaksiPending() {
    return _transaksi
        .where((t) => t.status == StatusTransaksi.pending)
        .length;
  }

  int getTotalProduk() => _produk.length;

  int getTotalPelanggan() => _pelanggan.length;

  int getTotalMitra() => _mitra.length;

  int getTotalPengiriman() => _pengiriman.length;
}
