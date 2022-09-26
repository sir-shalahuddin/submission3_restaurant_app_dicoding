class Item{
  Item({
    required this.name,
  });

  String name;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
