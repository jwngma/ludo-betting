class WinnerModel {
  int randomNumber;
  int drawNumber;
  int drawPrice;
  String name;
  String uid;

  WinnerModel(
      {this.randomNumber,
        this.drawNumber,
        this.drawPrice,
        this.name,
        this.uid,
        });

  WinnerModel.fromJson(Map<String, dynamic> json) {
    randomNumber = json['randomNumber'];
    drawNumber = json['drawNumber'];
    drawPrice = json['drawPrice'];
    name = json['name'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['randomNumber'] = this.randomNumber;
    data['drawNumber'] = this.drawNumber;
    data['drawPrice'] = this.drawPrice;
    data['name'] = this.name;
    data['uid'] = this.uid;
    return data;
  }
}
