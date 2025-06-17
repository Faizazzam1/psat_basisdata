class Toko {
  final int? id;
  final String? namaProduk;
  final int? harga;
  final String? desc;
  final int? stock;

  Toko({this.id, this.namaProduk, this.harga, this.desc, this.stock});

  factory Toko.fromMap(Map<String, dynamic> map) {
    return Toko(
      id: map['id'],
      namaProduk: map['nama_produk'],
      harga: map['harga'],
      desc: map['desc'],
      stock: map['stock'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_produk': namaProduk,
      'harga': harga,
      'desc': desc,
      'stock': stock,
    };
  }
}
