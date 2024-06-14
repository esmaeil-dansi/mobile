class MessageUser {
  String name;
  String email;

  MessageUser({this.name ="", this.email = ""});

  static MessageUser fromJson(Map<String, dynamic> data) {
    return MessageUser(name: data["description"], email: data["value"]);
  }
}
