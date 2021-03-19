class ResultModel {
  int randomNumber;
  int drawNumber;
  int drawPrice;
  int totalWinner;
  String key;
  String hash;

  ResultModel(
      {this.randomNumber,
      this.drawNumber,
      this.drawPrice,
      this.totalWinner,
      this.key,
      this.hash});

  ResultModel.fromJson(Map<String, dynamic> json) {
    randomNumber = json['randomNumber'];
    drawNumber = json['drawNumber'];
    drawPrice = json['drawPrice'];
    totalWinner = json['totalWinner'];
    key = json['key'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['randomNumber'] = this.randomNumber;
    data['drawNumber'] = this.drawNumber;
    data['drawPrice'] = this.drawPrice;
    data['totalWinner'] = this.totalWinner;
    data['key'] = this.key;
    data['hash'] = this.hash;

    return data;
  }
}
