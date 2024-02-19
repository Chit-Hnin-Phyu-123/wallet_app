class NotificationModel
{
  String? title;
  String? body;
  NotificationModel({ this.title, this.body });
  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(title: json['title'], body: json['body']);
}