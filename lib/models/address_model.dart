class AddressModel {
  String paytm_wallet;
  String googlepay_wallet;


  AddressModel(
      {this.paytm_wallet,
        this.googlepay_wallet,
      });

  AddressModel.fromJson(Map<String, dynamic> json) {
    paytm_wallet = json['paytm_wallet'];
    googlepay_wallet = json['googlepay_wallet'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paytm_wallet'] = this.paytm_wallet;
    data['googlepay_wallet'] = this.googlepay_wallet;

    return data;
  }
}
