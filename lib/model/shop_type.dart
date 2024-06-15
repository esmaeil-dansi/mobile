enum ShopType {
  DAM,
  TOTOR,
  NAHADA;

  String getName() {
    if (this == ShopType.DAM) {
      return "دام";
    } else if (this == ShopType.TOTOR) {
      return "طیور و ماکیان";
    }
    return "نهاده";
  }
}
