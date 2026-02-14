class ContactItem {
  final String name;
  final String phone;

  ContactItem({
    required this.name,
    required this.phone,
  });

  ContactItem copyWith({
    String? name,
    String? phone,
  }) {
    return ContactItem(
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          phone == other.phone;

  @override
  int get hashCode => name.hashCode ^ phone.hashCode;
}