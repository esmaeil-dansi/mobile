class Agent {
  String value;
  String description;

  String getName() {
    return description.split(",").first;
  }

  String getProvince() {
    return description.split(",").last;
  }

  Agent(this.value, this.description);

  static Agent? fromJson(Map<String, dynamic> data) {
    try{
      return new Agent(data["value"], data["description"]);
    }catch(e){
      return null;
    }

  }
}
