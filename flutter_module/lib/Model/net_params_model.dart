class NetParamsModel {
  final String battery_level;
  final String battery_state;
  final String brightness;
  final String network;
  final String last_boot_time;
  final String total_disk_space;

  final String free_disk_space;
  final String device_zTheta;
  final String modelName;
  final String idfa;
  final String sys_ver;
  final String device_id;
  final String version;
  final String channel;
  final String game_id;
  final String sys;
  final String timestamp;
  final String nonce;
  final String sign;

  NetParamsModel(
      {this.battery_level,
      this.battery_state,
      this.brightness,
      this.network,
      this.last_boot_time,
      this.total_disk_space,
      this.free_disk_space,
      this.device_zTheta,
      this.modelName,
      this.idfa,
      this.sys_ver,
      this.device_id,
      this.version,
      this.channel,
      this.game_id,
      this.sys,
      this.timestamp,
      this.nonce,
      this.sign});

  factory NetParamsModel.fromJson(Map json) {
    return NetParamsModel(
      battery_level: json['battery_level'].toString(),
      battery_state: json['battery_state'].toString(),
      brightness: json['brightness'].toString(),
      network: json['network'].toString(),
      last_boot_time: json['last_boot_time'],
      total_disk_space: json['total_disk_space'],
      free_disk_space: json['free_disk_space'],
      device_zTheta: json['device_zTheta'],
      modelName: json['modelName'],
      idfa: json['idfa'],
      sys_ver: json['sys_ver'],
      device_id: json['device_id'],
      version: json['version'],
      channel: json['channel'],
      game_id: json['game_id'],
      sys: json['sys'],
      timestamp: json['timestamp'],
      nonce: json['nonce'],
      sign: json['sign'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['battery_level'] = this.battery_level;
    json['battery_state'] = this.battery_state;
    json['brightness'] = this.brightness;
    json['network'] = this.network;
    json['last_boot_time'] = this.last_boot_time;
    json['total_disk_space'] = this.total_disk_space;
    json['free_disk_space'] = this.free_disk_space;
    json['device_zTheta'] = this.device_zTheta;
    json['modelName'] = this.modelName;
    json['idfa'] = this.idfa;
    json['sys_ver'] = this.sys_ver;
    json['device_id'] = this.device_id;
    json['version'] = this.version;
    json['channel'] = this.channel;
    json['game_id'] = this.game_id;
    json['sys'] = this.sys;
    json['timestamp'] = this.timestamp;
    json['nonce'] = this.nonce;
    json['sign'] = this.sign;
  }
}
