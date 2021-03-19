class PaymentSuccessModel {
  final String ORDERID;
  final String TXNID;
  final String STATUS;
  final String RESPCODE;
  final String CHECKSUMHASH;
  final int AMOUNT;
  final int coins;

  PaymentSuccessModel({
    this.coins,
    this.ORDERID,
    this.TXNID,
    this.STATUS,
    this.RESPCODE,
    this.CHECKSUMHASH,
    this.AMOUNT,
  });
}
