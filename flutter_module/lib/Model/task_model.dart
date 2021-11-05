class TaskModel {
  final int section;
  final String task_id; // "10001",
  final String task_max; // "200",
  final String task_remain;
  final String reward_type; // 奖励类型：1=金币，2=红包券
  final String type; // 任务类型：1=当天任务，2=专属任务
  final String reward_amount; // "30",
  final int task_keep_min; // "0",
  final String app_icon; // "https://upload.q2d7f6.jpeg",
  final String app_url; // "",
  final String app_name; // "",
  final String app_keyword; // "",
  final String app_package_id;
  final String app_rank;
  final List zs_task_info; // [
  final bool is_expire; //是否过期，1=是，0=否
  final bool is_done; //是否满足试玩条件，1=是，0=否 是否已经试玩了
  final bool reward_status; //是否已经领奖，1=是，0=否
  final bool subscribe; //是否试玩，1=是，0=否
  int status; //状态：-1=已经取消，0=未开始，1=进行中，2=开始试玩
  final int done_secs; // = 0;
  int pass_secs = 0;

  TaskModel({
    this.section,
    this.task_id, // "10001",
    this.task_max, // "200",
    this.task_remain,
    this.reward_type, // 奖励类型：1=金币，2=红包券
    this.type, // 任务类型：1=当天任务，2=专属任务
    this.reward_amount, // "30",
    this.task_keep_min, // "0",
    this.app_icon, // "https://upload.q2d7f6.jpeg",
    this.app_url, // "",
    this.app_name, // "",
    this.app_keyword, // "",
    this.app_package_id,
    this.app_rank,
    this.zs_task_info, // [
    this.is_expire, //是否过期，1=是，0=否
    this.is_done, //是否满足试玩条件，1=是，0=否 是否已经试玩了
    this.reward_status, //是否已经领奖，1=是，0=否
    this.subscribe, //是否试玩，1=是，0=否
    this.status, //状态：-1=已经取消，0=未开始，1=进行中，2=开始试玩
    this.done_secs, // = 0,
    this.pass_secs, // = 332634,
  });

  factory TaskModel.fromJson(Map json) {
    return TaskModel(
      task_id: json['task_id'], // "10001"'
      task_max: json['task_max'], // "200"'
      task_remain: json['task_remain'],
      reward_type: json['reward_type'].toString(), // 奖励类型：1=金币，2=红包券
      type: json['type'].toString(), // 任务类型：1=当天任务，2=专属任务
      reward_amount: json['reward_amount'].toString(), // "30",
      task_keep_min: json['task_keep_min'], // "0",
      app_icon: json['app_icon'], // "https://upload.q2d7f6.jpeg",
      app_url: json['app_url'], // "",
      app_name: json['app_name'], // "",
      app_keyword: json['app_keyword'], // "",
      app_package_id: json['app_package_id'],
      app_rank: json['app_rank'],
      zs_task_info: json['zs_task_info'], // [
      is_expire: (json['is_expire'] == 1) ? true : false, //是否过期，1=是，0=否
      is_done: (json['is_done'] == 1) ? true : false, //是否满足试玩条件，1=是，0=否 是否已经试玩了
      reward_status:
          (json['reward_status'] == 1) ? true : false, //是否已经领奖，1=是，0=否
      subscribe: json['subscribe'] == 1 ? true : false, //是否试玩，1=是，0=否
      status: int.parse((json['status'] == null)
          ? '0'
          : json['status'].toString()), //状态：-1=已经取消，0=未开始，1=进行中，2=开始试玩
      done_secs: json['done_secs'], // = 0,
      pass_secs: json['pass_secs'], // = 332634,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['task_id'] = this.task_id;
    data['task_max'] = this.task_max;
    data['task_remain'] = this.task_remain;
    data['reward_type'] = this.reward_type;
    data['type'] = this.type;
    data['reward_amount'] = this.reward_amount;
    data['task_keep_min'] = this.task_keep_min;
    data['app_icon'] = this.app_icon;
    data['app_url'] = this.app_url;
    data['app_package_id'] = this.app_package_id;
    data['app_name'] = this.app_name;
    data['app_keyword'] = this.app_keyword;
    data['app_rank'] = this.app_rank;
    data['zs_task_info'] = this.zs_task_info;
    data['is_expire'] = this.is_expire;
    data['is_done'] = this.is_done;
    data['reward_status'] = this.reward_status;
    data['subscribe'] = this.subscribe;
    data['status'] = this.status;
    data['done_secs'] = this.done_secs;
    data['pass_secs'] = this.pass_secs;
    return data;
  }
}
