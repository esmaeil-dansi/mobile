class Message {
  String name;
  String owner;
  String creation;
  String modified;
  String modified_by;
  String user_tags;
  String comments;
  String assign;
  String liked_by;
  int docstatus;
  int idx;
  String status;
  String subject1;
  String message;
  String seen;
  int comment_count;

  Message(
      this.name,
      this.owner,
      this.creation,
      this.modified,
      this.modified_by,
      this.user_tags,
      this.comments,
      this.assign,
      this.liked_by,
      this.docstatus,
      this.idx,
      this.status,
      this.subject1,
      this.message,
      this.seen,
      this.comment_count);

  static Message? fromJson(List<dynamic> values) {
    try {
      return Message(
        values[0],
        values[1],
        values[2],
        values[3],
        values[4],
        "",
        "values[6]",
        " values[7]",
        "values[8]",
        values[9],
        values[10],
        values[11],
        values[12],
        values[13].toString().split("<")[2].replaceAll("p>", "").replaceAll("&nbsp;", ""),
        "values[14]",
        values[15],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}
