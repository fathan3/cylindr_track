import 'package:flutter/material.dart';

class Mitra {
  final String id;
  final String nama;
  final String lokasi;
  final String nomorTelepon;
  final String alamat;
  final DateTime tanggalKerjasama;
  DateTime? tanggalPengirimanTerakhir;
  final bool aktif;

  Mitra({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.nomorTelepon,
    required this.alamat,
    required this.tanggalKerjasama,
    this.tanggalPengirimanTerakhir,
    this.aktif = true,
  });

  int get hariTanpaPengiriman {
    if (tanggalPengirimanTerakhir == null) {
      return DateTime.now().difference(tanggalKerjasama).inDays;
    }
    return DateTime.now().difference(tanggalPengirimanTerakhir!).inDays;
  }

  bool get perluAlert => hariTanpaPengiriman >= 30;
}

class Pengiriman {
  final String id;
  final String nomorPengiriman;
  final DateTime tanggal;
  final String mitraId;
  final String mitraNama;
  final String lokasi;
  final List<ItemPengiriman> items;
  final String catatan;
  final String status;

  Pengiriman({
    required this.id,
    required this.nomorPengiriman,
    required this.tanggal,
    required this.mitraId,
    required this.mitraNama,
    required this.lokasi,
    required this.items,
    required this.catatan,
    this.status = 'terkirim',
  });
}

class ItemPengiriman {
  final String produkId;
  final String namaProduk;
  final int jumlah;

  ItemPengiriman({
    required this.produkId,
    required this.namaProduk,
    required this.jumlah,
  });
}

class StokMitra {
  final String mitraId;
  final String mitraNama;
  final String produkId;
  final String namaProduk;
  final int stokTerpinjam;
  final DateTime tanggalPengirimanTerakhir;

  StokMitra({
    required this.mitraId,
    required this.mitraNama,
    required this.produkId,
    required this.namaProduk,
    required this.stokTerpinjam,
    required this.tanggalPengirimanTerakhir,
  });
}

class EvaluasiRepurchasing {
  final String id;
  final String mitraId;
  final String mitraNama;
  final int hariTanpaPengiriman;
  final DateTime tanggalAlert;
  final String status;
  final String? tindakan;
  final DateTime? tanggalTindakan;

  EvaluasiRepurchasing({
    required this.id,
    required this.mitraId,
    required this.mitraNama,
    required this.hariTanpaPengiriman,
    required this.tanggalAlert,
    this.status = 'belum_ditindak',
    this.tindakan,
    this.tanggalTindakan,
  });
}

class Produk {
  final String id;
  final String nama;
  final String sku;
  final int stok;
  final double harga;
  final String kategori;

  Produk({
    required this.id,
    required this.nama,
    required this.sku,
    required this.stok,
    required this.harga,
    required this.kategori,
  });
}

class Transaksi {
  final String id;
  final String nomorTransaksi;
  final DateTime tanggal;
  final TipeTransaksi tipe;
  final String namaPelanggan;
  final List<ItemTransaksi> items;
  final double total;
  final StatusTransaksi status;

  Transaksi({
    required this.id,
    required this.nomorTransaksi,
    required this.tanggal,
    required this.tipe,
    required this.namaPelanggan,
    required this.items,
    required this.total,
    required this.status,
  });
}

class ItemTransaksi {
  final String produkId;
  final String namaProduk;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;

  ItemTransaksi({
    required this.produkId,
    required this.namaProduk,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });
}

class Pelanggan {
  final String id;
  final String nama;
  final String nomorTelepon;
  final String email;
  final String alamat;
  final String kota;
  final DateTime tanggalTerdaftar;
  final double totalBelanja;
  final int jumlahTransaksi;

  Pelanggan({
    required this.id,
    required this.nama,
    required this.nomorTelepon,
    required this.email,
    required this.alamat,
    required this.kota,
    required this.tanggalTerdaftar,
    required this.totalBelanja,
    required this.jumlahTransaksi,
  });
}

enum TipeTransaksi { penjualan, pembelian, retur }

enum StatusTransaksi { pending, selesai, batal }

extension TipeTransaksiExt on TipeTransaksi {
  String get label {
    switch (this) {
      case TipeTransaksi.penjualan:
        return 'Penjualan';
      case TipeTransaksi.pembelian:
        return 'Pembelian';
      case TipeTransaksi.retur:
        return 'Retur';
    }
  }
}

extension StatusTransaksiExt on StatusTransaksi {
  String get label {
    switch (this) {
      case StatusTransaksi.pending:
        return 'Pending';
      case StatusTransaksi.selesai:
        return 'Selesai';
      case StatusTransaksi.batal:
        return 'Batal';
    }
  }

  Color get color {
    switch (this) {
      case StatusTransaksi.pending:
        return const Color(0xFFFFA726);
      case StatusTransaksi.selesai:
        return const Color(0xFF66BB6A);
      case StatusTransaksi.batal:
        return const Color(0xFFEF5350);
    }
  }
}
