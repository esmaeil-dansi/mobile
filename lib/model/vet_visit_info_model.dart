class VetVisitInfoModel {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? nameDamp;
  String? rahbar;
  String? codeN;
  String? department;
  String? nationalIdDoc;
  String? tamin;
  int? bime;
  int? pelak;
  String? pelakAz;
  String? pelakTa;
  String? nationalId;
  String? galleh;
  int? galleD;
  String? name1;
  String? province;
  String? city;
  int? age;
  int? teeth1;
  int? teeth2;
  int? teeth3;
  int? eye1;
  int? eye2;
  int? eye3;
  int? eye4;
  int? eye5;
  int? breth1;
  int? breth2;
  int? breth3;
  int? mucus1;
  int? mucus2;
  int? mucus3;
  int? mucus4;
  int? mucus5;
  int? ear1;
  int? ear2;
  int? skin1;
  int? skin2;
  int? skin3;
  int? skin4;
  int? skin5;
  int? skin6;
  int? leech1;
  int? leech2;
  int? leech3;
  int? mouth1;
  int? mouth2;
  int? mouth3;
  int? mouth4;
  int? hoof1;
  int? hoof2;
  int? hoof3;
  int? hoof4;
  int? urine1;
  int? urine2;
  int? urine3;
  int? nodes1;
  int? nodes2;
  int? crown1;
  int? crown2;
  int? crown3;
  int? sole1;
  int? sole2;
  int? sole3;
  String? fullName;
  String? address;
  String? types;
  int? number;
  String? result;
  String? licenseSalamat;
  String? geolocation;
  String? doctype;

  VetVisitInfoModel(
      {this.name,
        this.owner,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.docstatus,
        this.idx,
        this.nameDamp,
        this.rahbar,
        this.codeN,
        this.department,
        this.nationalIdDoc,
        this.tamin,
        this.bime,
        this.pelak,
        this.pelakAz,
        this.pelakTa,
        this.nationalId,
        this.galleh,
        this.galleD,
        this.name1,
        this.province,
        this.city,
        this.age,
        this.teeth1,
        this.teeth2,
        this.teeth3,
        this.eye1,
        this.eye2,
        this.eye3,
        this.eye4,
        this.eye5,
        this.breth1,
        this.breth2,
        this.breth3,
        this.mucus1,
        this.mucus2,
        this.mucus3,
        this.mucus4,
        this.mucus5,
        this.ear1,
        this.ear2,
        this.skin1,
        this.skin2,
        this.skin3,
        this.skin4,
        this.skin5,
        this.skin6,
        this.leech1,
        this.leech2,
        this.leech3,
        this.mouth1,
        this.mouth2,
        this.mouth3,
        this.mouth4,
        this.hoof1,
        this.hoof2,
        this.hoof3,
        this.hoof4,
        this.urine1,
        this.urine2,
        this.urine3,
        this.nodes1,
        this.nodes2,
        this.crown1,
        this.crown2,
        this.crown3,
        this.sole1,
        this.sole2,
        this.sole3,
        this.fullName,
        this.address,
        this.types,
        this.number,
        this.result,
        this.licenseSalamat,
        this.geolocation,
        this.doctype});

  VetVisitInfoModel.fromJson(Map<String?, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    nameDamp = json['name_damp'];
    rahbar = json['rahbar'];
    codeN = json['code_n'];
    department = json['department'];
    nationalIdDoc = json['national_id_doc'];
    tamin = json['tamin'];
    bime = json['bime'];
    pelak = json['pelak'];
    pelakAz = json['pelak_az'];
    pelakTa = json['pelak_ta'];
    nationalId = json['national_id'];
    galleh = json['galleh'];
    galleD = json['galle_d'];
    name1 = json['name_1'];
    province = json['province'];
    city = json['city'];
    age = json['age'];
    teeth1 = json['teeth_1'];
    teeth2 = json['teeth_2'];
    teeth3 = json['teeth_3'];
    eye1 = json['eye_1'];
    eye2 = json['eye_2'];
    eye3 = json['eye_3'];
    eye4 = json['eye_4'];
    eye5 = json['eye_5'];
    breth1 = json['breth_1'];
    breth2 = json['breth_2'];
    breth3 = json['breth_3'];
    mucus1 = json['mucus_1'];
    mucus2 = json['mucus_2'];
    mucus3 = json['mucus_3'];
    mucus4 = json['mucus_4'];
    mucus5 = json['mucus_5'];
    ear1 = json['ear_1'];
    ear2 = json['ear_2'];
    skin1 = json['skin_1'];
    skin2 = json['skin_2'];
    skin3 = json['skin_3'];
    skin4 = json['skin_4'];
    skin5 = json['skin_5'];
    skin6 = json['skin_6'];
    leech1 = json['leech_1'];
    leech2 = json['leech_2'];
    leech3 = json['leech_3'];
    mouth1 = json['mouth_1'];
    mouth2 = json['mouth_2'];
    mouth3 = json['mouth_3'];
    mouth4 = json['mouth_4'];
    hoof1 = json['hoof_1'];
    hoof2 = json['hoof_2'];
    hoof3 = json['hoof_3'];
    hoof4 = json['hoof_4'];
    urine1 = json['urine_1'];
    urine2 = json['urine_2'];
    urine3 = json['urine_3'];
    nodes1 = json['nodes_1'];
    nodes2 = json['nodes_2'];
    crown1 = json['crown_1'];
    crown2 = json['crown_2'];
    crown3 = json['crown_3'];
    sole1 = json['sole_1'];
    sole2 = json['sole_2'];
    sole3 = json['sole_3'];
    fullName = json['full_name'];
    address = json['address'];
    types = json['types'];
    number = json['number'];
    result = json['result'];
    licenseSalamat = json['license_salamat'];
    geolocation = json['geolocation'];
    doctype = json['doctype'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['docstatus'] = this.docstatus;
    data['idx'] = this.idx;
    data['name_damp'] = this.nameDamp;
    data['rahbar'] = this.rahbar;
    data['code_n'] = this.codeN;
    data['department'] = this.department;
    data['national_id_doc'] = this.nationalIdDoc;
    data['tamin'] = this.tamin;
    data['bime'] = this.bime;
    data['pelak'] = this.pelak;
    data['pelak_az'] = this.pelakAz;
    data['pelak_ta'] = this.pelakTa;
    data['national_id'] = this.nationalId;
    data['galleh'] = this.galleh;
    data['galle_d'] = this.galleD;
    data['name_1'] = this.name1;
    data['province'] = this.province;
    data['city'] = this.city;
    data['age'] = this.age;
    data['teeth_1'] = this.teeth1;
    data['teeth_2'] = this.teeth2;
    data['teeth_3'] = this.teeth3;
    data['eye_1'] = this.eye1;
    data['eye_2'] = this.eye2;
    data['eye_3'] = this.eye3;
    data['eye_4'] = this.eye4;
    data['eye_5'] = this.eye5;
    data['breth_1'] = this.breth1;
    data['breth_2'] = this.breth2;
    data['breth_3'] = this.breth3;
    data['mucus_1'] = this.mucus1;
    data['mucus_2'] = this.mucus2;
    data['mucus_3'] = this.mucus3;
    data['mucus_4'] = this.mucus4;
    data['mucus_5'] = this.mucus5;
    data['ear_1'] = this.ear1;
    data['ear_2'] = this.ear2;
    data['skin_1'] = this.skin1;
    data['skin_2'] = this.skin2;
    data['skin_3'] = this.skin3;
    data['skin_4'] = this.skin4;
    data['skin_5'] = this.skin5;
    data['skin_6'] = this.skin6;
    data['leech_1'] = this.leech1;
    data['leech_2'] = this.leech2;
    data['leech_3'] = this.leech3;
    data['mouth_1'] = this.mouth1;
    data['mouth_2'] = this.mouth2;
    data['mouth_3'] = this.mouth3;
    data['mouth_4'] = this.mouth4;
    data['hoof_1'] = this.hoof1;
    data['hoof_2'] = this.hoof2;
    data['hoof_3'] = this.hoof3;
    data['hoof_4'] = this.hoof4;
    data['urine_1'] = this.urine1;
    data['urine_2'] = this.urine2;
    data['urine_3'] = this.urine3;
    data['nodes_1'] = this.nodes1;
    data['nodes_2'] = this.nodes2;
    data['crown_1'] = this.crown1;
    data['crown_2'] = this.crown2;
    data['crown_3'] = this.crown3;
    data['sole_1'] = this.sole1;
    data['sole_2'] = this.sole2;
    data['sole_3'] = this.sole3;
    data['full_name'] = this.fullName;
    data['address'] = this.address;
    data['types'] = this.types;
    data['number'] = this.number;
    data['result'] = this.result;
    data['license_salamat'] = this.licenseSalamat;
    data['geolocation'] = this.geolocation;
    data['doctype'] = this.doctype;
    return data;
  }
}
