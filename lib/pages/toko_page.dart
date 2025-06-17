import 'package:flutter/material.dart';
import 'package:psat_basis_data/pages/login_page.dart';
import 'package:psat_basis_data/toko/toko.dart';
import 'package:psat_basis_data/toko/toko_database.dart';

class TokoPage extends StatefulWidget {
  const TokoPage({super.key});

  @override
  State<TokoPage> createState() => _TokoPageState();
}

class _TokoPageState extends State<TokoPage> {
  final TokoDatabase db = TokoDatabase();

  final idController = TextEditingController();
  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final stockController = TextEditingController();
  final searchController = TextEditingController();

  List<Toko> hasilPencarian = [];

  void tampilkanForm({Toko? produk}) {
    if (produk != null) {
      idController.text = produk.id?.toString() ?? '';
      namaController.text = produk.namaProduk ?? '';
      hargaController.text = produk.harga?.toString() ?? '';
      deskripsiController.text = produk.desc ?? '';
      stockController.text = produk.stock?.toString() ?? '';
    } else {
      idController.clear();
      namaController.clear();
      hargaController.clear();
      deskripsiController.clear();
      stockController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(produk == null ? 'Tambah Produk' : 'Update Produk'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (produk == null)
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'ID'),
                  keyboardType: TextInputType.number,
                ),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final produkBaru = Toko(
                id: int.tryParse(idController.text),
                namaProduk: namaController.text,
                harga: int.tryParse(hargaController.text),
                desc: deskripsiController.text,
                stock: int.tryParse(stockController.text),
              );

              if (produk == null) {
                await db.createProduk(produkBaru);
              } else {
                await db.updateProduk(produk, produkBaru);
              }

              Navigator.pop(context);
              setState(() {});
            },
            child: Text(produk == null ? 'Tambah' : 'Update'),
          ),
        ],
      ),
    );
  }

  void konfirmasiHapus(Toko produk) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: Text('Yakin ingin menghapus produk "${produk.namaProduk}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await db.deleteProduk(produk);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void cariProduk(String query, List<Toko> semuaProduk) {
    final hasil = semuaProduk.where((produk) {
      final nama = produk.namaProduk?.toLowerCase() ?? '';
      return nama.contains(query.toLowerCase());
    }).toList();

    setState(() {
      hasilPencarian = hasil;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Barang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tampilkanForm(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Toko>>(
        stream: db.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final produkList = snapshot.data!;
          final tampilkanList = searchController.text.isEmpty
              ? produkList
              : hasilPencarian;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Cari Produk',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => cariProduk(value, produkList),
                ),
              ),
              if (tampilkanList.isEmpty)
                const Expanded(
                  child: Center(child: Text('Tidak ada produk yang cocok.')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: tampilkanList.length,
                    itemBuilder: (context, index) {
                      final produk = tampilkanList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(produk.id.toString()),
                          ),
                          title: Text(produk.namaProduk ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Harga: Rp ${produk.harga}'),
                              Text('Stok: ${produk.stock}'),
                              Text('Deskripsi: ${produk.desc}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () =>
                                    tampilkanForm(produk: produk),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => konfirmasiHapus(produk),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
