class DistributionObject {
  int id;
  String name;
  String description;
  int clientName;
  int sexe;
  int productName;
  int email;
  int phoneNumber;
  int note;
  int city;
  int age;
  int quantity;
  int distributed;
  int left;

  DistributionObject({
    required this.id,
    required this.name,
    required this.description,
    required this.clientName,
    required this.sexe,
    required this.productName,
    required this.email,
    required this.phoneNumber,
    required this.note,
    required this.city,
    required this.age,
    required this.quantity,
    required this.distributed,
    required this.left,
  });

  factory DistributionObject.fromJson(Map<String, dynamic> json) {
    return DistributionObject(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      clientName: json['client_name'],
      sexe: json['sexe'],
      productName: json['product_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      note: json['note'],
      city: json['city'],
      age: json['age'],
      quantity: json['totalObject'],
      distributed: json['distributedObject'],
      left: json['leftDistrubutionObject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'client_name': clientName,
      'sexe': sexe,
      'product_name': productName,
      'email': email,
      'phone_number': phoneNumber,
      'note': note,
      'city': city,
      'age': age,
      'quantity': quantity,
    };
  }
}
