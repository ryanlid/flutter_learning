class Note {
  String uuid;
  String title;
  String category;
  String content;

  Note(this.uuid, this.title, this.category, this.content);

  // 实现两个方法 fromJson 和 toJson 分别用于JSON 与类实例间的相互转换。
  Note.fromJson(Map<String, dynamic> json)
      : uuid = json["uuid"],
        title = json['title'],
        category = json['category'],
        content = json['content'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uuid': uuid,
        'title': title,
        'category': category,
        'content': content
      };
}


