class CakeSizePrice {
  final String cakeSize;
  final String cakePrice;
  const CakeSizePrice(this.cakeSize, this.cakePrice);
}

class CakeData {
  final String orderTime;
  final String orderDate;
  final String pickUpTime;
  final String pickUpDate;
  final String cakeCategory;
  final String cakeSize;
  final String customerName;
  final String customerPhone;
  final String partTimer;
  final String remark;
  final bool paystatus;
  final bool pickUpStatus;
  CakeData(
      {this.orderDate,
      this.orderTime,
      this.pickUpDate,
      this.pickUpTime,
      this.cakeCategory,
      this.cakeSize,
      this.customerName,
      this.customerPhone,
      this.partTimer,
      this.remark,
      this.paystatus,
      this.pickUpStatus}) {}
}
