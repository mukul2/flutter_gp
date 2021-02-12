class ProductModel {
  String id;
  String name;
  String img;
  String price;
  String category;
  String subcategory;
  String description;

  ProductModel(
      {this.id,
        this.name,
        this.img,
        this.price,
        this.category,
        this.subcategory,
        this.description});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    price = json['price'];
    category = json['category'];
    subcategory = json['subcategory'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;
    data['price'] = this.price;
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    data['description'] = this.description;
    return data;
  }
}