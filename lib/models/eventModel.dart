class EventModel {
  String uid;
  int gameId;
  int entryFee;
  int prize;
  int totalPlayer;
  int totalParticipated;
  String time;
  String status;
    String appType;
  String gameType;
  String hostName;
  String roomId;
  String roomPassword;

  EventModel(
      {
        this.uid,
        this.gameId,
        this.time,
        this.status,
        this.appType,
        this.gameType,
        this.entryFee,
        this.prize,
        this.totalPlayer,
        this.totalParticipated,
        this.hostName,
        this.roomId,
        this.roomPassword});

  Map toMap(EventModel eventModel) {
    var data = Map<String, dynamic>();
    data['uid'] = eventModel.uid;
    data['gameId'] = eventModel.gameId;
    data['time'] = eventModel.time;
    data['status'] = eventModel.status;
    data['appType'] = eventModel.appType;
    data['gameType'] = eventModel.gameType;
    data['entryFee'] = eventModel.entryFee;
    data['prize'] = eventModel.prize;
    data['totalPlayer'] = eventModel.totalPlayer;
    data['totalParticipated'] = eventModel.totalParticipated;
    data['hostName'] = eventModel.hostName;
    data['roomId'] = eventModel.roomId;
    data['roomPassword'] = eventModel.roomPassword;
    return data;
  }

  EventModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.gameId = mapData['gameId'];
    this.time = mapData['time'];
    this.status = mapData['status'];
    this.appType = mapData['appType'];
    this.status = mapData['status'];
    this.gameType = mapData['gameType'];
    this.entryFee = mapData['entryFee'];
    this.prize = mapData['prize'];
    this.totalPlayer = mapData['totalPlayer'];
    this.totalParticipated = mapData['totalParticipated'];
    this.hostName = mapData['hostName'];
    this.roomId = mapData['roomId'];
    this.roomPassword = mapData['roomPassword'];
  }
}
