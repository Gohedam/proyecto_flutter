class Product {
  final int? id;
  final String nombre;
  final DateTime fechaExp;
  final String imagenBase64;

  Product({
    this.id,
    required this.nombre,
    required this.fechaExp,
    required this.imagenBase64,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()),
      nombre: json['nombre'],
      fechaExp: DateTime.parse(json['fecha_exp']),
      imagenBase64: json['imagen'],
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id?.toString() ?? '',
      'nombre': nombre,
      'fecha_exp': fechaExp.toIso8601String().split('T').first,
      'imagen': imagenBase64,
    };
  }
}
