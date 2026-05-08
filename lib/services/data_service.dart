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

  List<Produk> getProduk() => _produk;
  List<Transaksi> getTransaksi() => _transaksi;
  List<Pelanggan> getPelanggan() => _pelanggan;

  Produk? getProdukById(String id) {
    try {
      return _produk.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
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
}
