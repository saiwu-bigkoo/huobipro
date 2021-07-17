class DepthEntity {
  late double price;
  late double vol;

  DepthEntity(this.price, this.vol);

  @override
  String toString() {
    return 'Data{price: $price, vol: $vol}';
  }
}
