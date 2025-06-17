import 'package:psat_basis_data/toko/toko.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TokoDatabase {
  // Reference ke tabel Supabase
  final database = Supabase.instance.client.from('toko');

  // Create: Tambah produk baru
  Future<void> createProduk(Toko newProduk) async {
    await database.insert(newProduk.toMap());
  }

  // Read: Stream data real-time
  final stream = Supabase.instance.client.from('toko').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((map) => Toko.fromMap(map)).toList());

  // Update: Ubah produk berdasarkan ID
  Future<void> updateProduk(Toko oldProduk, Toko newProduk) async {
    await database.update(newProduk.toMap()).eq('id', oldProduk.id!);
  }

  // Delete: Hapus produk berdasarkan ID
  Future<void> deleteProduk(Toko produk) async {
    await database.delete().eq('id', produk.id!);
  }
}
