class SettlementModel {
  String? tId;
  String? id;
  String? driverId;
  String? cashPayment;
  String? onlinePayment;
  String? refferalAmount;
  String? joiningBonus;
  String? incentiveBonus;
  String? adminCommisionByCash;
  String? adminCommissionByOnline;
  String? totalCommision;
  String? totalPromoBonus;
  String? adminPaidDriver;
  String? totalDueDriver;
  String? paymentStatus;
  String? day;
  String? cratedAt;
  String? firstDate;
  String? lastDate;

  SettlementModel(
      {this.tId,
      this.id,
      this.driverId,
      this.cashPayment,
      this.onlinePayment,
      this.refferalAmount,
      this.joiningBonus,
      this.incentiveBonus,
      this.adminCommisionByCash,
      this.adminCommissionByOnline,
      this.totalCommision,
      this.totalPromoBonus,
      this.adminPaidDriver,
      this.totalDueDriver,
      this.paymentStatus,
      this.day,
      this.cratedAt,
      this.firstDate,
      this.lastDate});

  SettlementModel.fromJson(Map<String, dynamic> json) {
    tId = json['t_id'];
    id = json['id'];
    driverId = json['driver_id'];
    cashPayment = json['cash_payment'];
    onlinePayment = json['online_payment'];
    refferalAmount = json['refferal_amount'];
    joiningBonus = json['joining_bonus'];
    incentiveBonus = json['incentive_bonus'];
    adminCommisionByCash = json['admin_commision_by_cash'];
    adminCommissionByOnline = json['admin_commission_by_online'];
    totalCommision = json['total_commision'];
    totalPromoBonus = json['total_promo_bonus'];
    adminPaidDriver = json['admin_paid_driver'];
    totalDueDriver = json['total_due_driver'];
    paymentStatus = json['payment_status'];
    day = json['day'];
    cratedAt = json['crated_at'];
    firstDate = json['first_date'];
    lastDate = json['last_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['t_id'] = this.tId;
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['cash_payment'] = this.cashPayment;
    data['online_payment'] = this.onlinePayment;
    data['refferal_amount'] = this.refferalAmount;
    data['joining_bonus'] = this.joiningBonus;
    data['incentive_bonus'] = this.incentiveBonus;
    data['admin_commision_by_cash'] = this.adminCommisionByCash;
    data['admin_commission_by_online'] = this.adminCommissionByOnline;
    data['total_commision'] = this.totalCommision;
    data['total_promo_bonus'] = this.totalPromoBonus;
    data['admin_paid_driver'] = this.adminPaidDriver;
    data['total_due_driver'] = this.totalDueDriver;
    data['payment_status'] = this.paymentStatus;
    data['day'] = this.day;
    data['crated_at'] = this.cratedAt;
    data['first_date'] = this.firstDate;
    data['last_date'] = this.lastDate;
    return data;
  }
}
