enum ProductType {
  dam,
  nahada
}

extension ProductLabel on ProductType {
  String get label {
    switch (this) {
      case ProductType.dam:
        return 'دام';
      case ProductType.nahada:
        return 'نهاده';
    }
  }
}
