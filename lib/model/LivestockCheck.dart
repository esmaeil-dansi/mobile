class LivestockCheck {
  String? dam;
  String? plk;
  int? raas;
  String? nzd;
  double? bcs;
  int? age;

  int? segt;
  int? segtNo;
  int? shepesh;
  int? shepeshNo;
  int? zaf;
  int? zafNo;
  int? pica;
  int? picaNo;
  int? langesh;
  int? langeshNo;
  int? sorfe;
  int? sorfeNo;


  LivestockCheck({
    this.dam,
    this.plk,
    this.raas,
    this.nzd,
    this.bcs,
    this.age,
    this.segt,
    this.segtNo,
    this.shepesh,
    this.shepeshNo,
    this.zaf,
    this.zafNo,
    this.pica,
    this.picaNo,
    this.langesh,
    this.langeshNo,
    this.sorfe,
    this.sorfeNo,
  });

  factory LivestockCheck.fromJson(Map<String, dynamic> json) {
    return LivestockCheck(
      dam: json['dam'],
      plk: json['plk'],
      raas: json['raas'],
      nzd: json['nzd'],
      bcs: (json['bcs'] as num?)?.toDouble(),
      age: json['age'],
      segt: json['seght'],
      segtNo: json['seght_no'],
      shepesh: json['shepesh'],
      shepeshNo: json['shepesh_no'],
      zaf: json['zaf'],
      zafNo: json['zaf_no'],
      pica: json['pica'],
      picaNo: json['pica_no'],
      langesh: json['langesh'],
      langeshNo: json['langesh_no'],
      sorfe: json['sorfe'],
      sorfeNo: json['sorfe_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dam': dam,
      'plk': plk,
      'raas': raas,
      'nzd': nzd,
      'bcs': bcs,
      'age': age,
      'seght': segt,
      'seght_no': segtNo,
      'shepesh': shepesh,
      'shepesh_no': shepeshNo,
      'zaf': zaf,
      'zaf_no': zafNo,
      'pica': pica,
      'pica_no': picaNo,
      'langesh': langesh,
      'langesh_no': langeshNo,
      'sorfe': sorfe,
      'sorfe_no': sorfeNo,
    };
  }
}
