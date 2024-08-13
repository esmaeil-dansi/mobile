class AddVetVisitFormModel {
  int? docstatus;
  String? doctype;
  String? name;
  int? iIslocal;
  int? iUnsaved;
  String? owner;
  int? bime;
  int? pelak;
  String? galleh;
  String? types;
  String? result;
  String? nationalId;
  String? geolocation;
  String? rahbar;
  String? department;
  String? name1;
  String? province;
  String? city;
  String? fullName;
  String? address;
  String? codeN;
  String? nationalIdDoc;
  String? pelakAz;
  String? pelakTa;
  int? galleD;
  int? age;
  int? teeth1;
  int? teeth2;
  int? teeth3;
  int? eye5;
  int? eye4;
  int? eye3;
  int? eye2;
  int? eye1;
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
  int? leech3;
  int? leech2;
  int? leech1;
  int? mouth1;
  int? mouth2;
  int? mouth3;
  int? mouth4;
  int? hoof4;
  int? hoof3;
  int? hoof2;
  int? hoof1;
  int? urine1;
  int? urine2;
  int? urine3;
  int? nodes1;
  int? nodes2;
  String? nodes3;
  int? crown3;
  int? crown2;
  int? crown1;
  int? sole1;
  int? sole2;
  int? sole3;
  int? number;
  String? imageDam;
  String? imageDam1;
  String? imageDam2;
  String? imageDam3;
  String? licenseSalamat;
  double? lat;
  double? lon;
  String? disapprovalReason;
  String? nameDamp;

  AddVetVisitFormModel({
    this.docstatus = 0,
    this.doctype = "Vet Visit",
    this.name = "new-vet-visit-1",
    this.iIslocal = 1,
    this.iUnsaved = 1,
    this.owner,
    this.bime,
    this.pelak,
    this.galleh,
    this.lat,
    this.geolocation,
    this.lon,
    this.types,
    this.result,
    this.nationalId,
    this.rahbar,
    this.department,
    this.name1,
    this.province,
    this.city,
    this.fullName,
    this.address,
    this.codeN,
    this.nationalIdDoc,
    this.pelakAz,
    this.pelakTa,
    this.galleD,
    this.age,
    this.teeth1,
    this.teeth2,
    this.teeth3,
    this.eye5,
    this.eye4,
    this.eye3,
    this.eye2,
    this.eye1,
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
    this.leech3,
    this.leech2,
    this.leech1,
    this.mouth1,
    this.mouth2,
    this.mouth3,
    this.mouth4,
    this.hoof4,
    this.hoof3,
    this.hoof2,
    this.hoof1,
    this.urine1,
    this.urine2,
    this.urine3,
    this.nodes1,
    this.nodes2,
    this.nodes3,
    this.crown3,
    this.crown2,
    this.crown1,
    this.sole1,
    this.sole2,
    this.sole3,
    this.number,
    this.imageDam,
    this.imageDam1,
    this.imageDam2,
    this.imageDam3,
    this.licenseSalamat,
    this.disapprovalReason,
    this.nameDamp,
  });

  AddVetVisitFormModel.fromJson(Map<String, dynamic> json) {
    docstatus = json['docstatus'] ?? 0;
    doctype = json['doctype'] ?? "Vet Visit";
    name = json['name'] ?? "new-vet-visit-1";
    iIslocal = json['__islocal'] ?? 1;
    iUnsaved = json['__unsaved'] ?? 1;
    owner = json['owner'];
    bime = json['bime'];
    pelak = json['pelak'];
    galleh = json['galleh'];
    types = json['types'];
    result = json['result'];
    nationalId = json['national_id'];
    rahbar = json['rahbar'];
    department = json['department'];
    name1 = json['name_1'];
    province = json['province'];
    city = json['city'];
    fullName = json['full_name'];
    address = json['address'];
    codeN = json['code_n'];
    nationalIdDoc = json['national_id_doc'];
    pelakAz = json['pelak_az'];
    pelakTa = json['pelak_ta'];
    galleD = json['galle_d'];
    age = json['age'];
    teeth1 = json['teeth_1'];
    teeth2 = json['teeth_2'];
    teeth3 = json['teeth_3'];
    eye5 = json['eye_5'];
    eye4 = json['eye_4'];
    eye3 = json['eye_3'];
    eye2 = json['eye_2'];
    eye1 = json['eye_1'];
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
    leech3 = json['leech_3'];
    leech2 = json['leech_2'];
    leech1 = json['leech_1'];
    mouth1 = json['mouth_1'];
    mouth2 = json['mouth_2'];
    mouth3 = json['mouth_3'];
    mouth4 = json['mouth_4'];
    hoof4 = json['hoof_4'];
    hoof3 = json['hoof_3'];
    hoof2 = json['hoof_2'];
    hoof1 = json['hoof_1'];
    urine1 = json['urine_1'];
    urine2 = json['urine_2'];
    urine3 = json['urine_3'];
    nodes1 = json['nodes_1'];
    nodes2 = json['nodes_2'];
    nodes3 = json['nodes_3'];
    crown3 = json['crown_3'];
    crown2 = json['crown_2'];
    crown1 = json['crown_1'];
    sole1 = json['sole_1'];
    sole2 = json['sole_2'];
    sole3 = json['sole_3'];
    number = json['number'];
    imageDam = json['image_dam'];
    imageDam1 = json['image_dam1'];
    imageDam2 = json['image_dam2'];
    imageDam3 = json['image_dam3'];
    licenseSalamat = json['license_salamat'];
    lat = json['lat'];
    lon = json['lon'];
    disapprovalReason = json['disapproval_reason'];
    nameDamp = json['name_damp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docstatus'] = docstatus;
    data['doctype'] = doctype;
    data['name'] = name;
    data['__islocal'] = iIslocal;
    data['__unsaved'] = iUnsaved;
    data['owner'] = owner;
    data['bime'] = bime;
    data['lon'] = lon;
    data['lat'] = lat;
    data['pelak'] = pelak;
    data['galleh'] = galleh;
    data['types'] = types;
    data['result'] = result;
    data['national_id'] = nationalId;
    data['rahbar'] = rahbar;
    data['department'] = department;
    data['name_1'] = name1;
    data['province'] = province;
    data['city'] = city;
    data['full_name'] = fullName;
    data['address'] = address;
    data['code_n'] = codeN;
    data['national_id_doc'] = nationalIdDoc;
    data['pelak_az'] = pelakAz;
    data['pelak_ta'] = pelakTa;
    data['galle_d'] = galleD;
    data['age'] = age;
    data['teeth_1'] = teeth1;
    data['teeth_2'] = teeth2;
    data['teeth_3'] = teeth3;
    data['eye_5'] = eye5;
    data['eye_4'] = eye4;
    data['eye_3'] = eye3;
    data['eye_2'] = eye2;
    data['eye_1'] = eye1;
    data['breth_1'] = breth1;
    data['breth_2'] = breth2;
    data['breth_3'] = breth3;
    data['mucus_1'] = mucus1;
    data['mucus_2'] = mucus2;
    data['mucus_3'] = mucus3;
    data['mucus_4'] = mucus4;
    data['mucus_5'] = mucus5;
    data['ear_1'] = ear1;
    data['ear_2'] = ear2;
    data['skin_1'] = skin1;
    data['skin_2'] = skin2;
    data['skin_3'] = skin3;
    data['skin_4'] = skin4;
    data['skin_5'] = skin5;
    data['skin_6'] = skin6;
    data['leech_3'] = leech3;
    data['leech_2'] = leech2;
    data['leech_1'] = leech1;
    data['mouth_1'] = mouth1;
    data['mouth_2'] = mouth2;
    data['mouth_3'] = mouth3;
    data['mouth_4'] = mouth4;
    data['hoof_4'] = hoof4;
    data['hoof_3'] = hoof3;
    data['hoof_2'] = hoof2;
    data['hoof_1'] = hoof1;
    data['urine_1'] = urine1;
    data['urine_2'] = urine2;
    data['urine_3'] = urine3;
    data['nodes_1'] = nodes1;
    data['nodes_2'] = nodes2;
    data['nodes_3'] = nodes3;
    data['crown_3'] = crown3;
    data['crown_2'] = crown2;
    data['crown_1'] = crown1;
    data['sole_1'] = sole1;
    data['sole_2'] = sole2;
    data['sole_3'] = sole3;
    data['number'] = number;
    data['image_dam1'] = imageDam1;
    data['image_dam2'] = imageDam2;
    data['image_dam3'] = imageDam3;
    data['image_dam'] = imageDam;
    data['license_salamat'] = licenseSalamat;
    data['disapproval_reason'] = disapprovalReason;
    data['name_damp'] = nameDamp;
    data['geolocation'] =
        "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[${lon},${lat}]}}]}";
    return data;
  }
}
