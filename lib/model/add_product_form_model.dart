import 'dart:convert';

import 'package:latlong2/latlong.dart';

import '../utils/location_extractor.dart';

class ProductivityFormModel {
  LatLng? geolocation;
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? id;
  int? damCount;
  String? damType;
  String? nationalId;
  String? province;
  String? mobile;
  String? lastName;
  String? city;
  String? rahbar;
  String? location;
  String? antro1;
  int? antro1Doz;
  String? antro2;
  double? lat;
  double? lon;
  String? antro2Date;
  String? antro2Img;
  int? antro2Doz;
  String? sharbon;
  String? sharbonDate;
  int? sharbonDoz;
  String? abele;
  String? abeleDate;
  String? abeleImg;
  int? abeleDoz;
  String? brucellosis;
  int? brucellosisDoz;
  String? sharbon1;
  int? sharbon1Doz;
  String? taon;
  int? taonDoz;
  String? pasteurose;
  int? pasteuroseDoz;
  String? barfaki;
  String? barfakiDate;
  String? barfakiImg;
  int? barfakiDoz;
  String? ghangharia;
  int? ghanghariaDoz;
  String? agalacci;
  int? agalacciDoz;
  String? iver;
  int? iverDoz;
  String? iver2;
  int? iver2Doz;
  String? spraying1;
  int? spraying1Doz;
  String? spraying2;
  int? spraying2Doz;
  String? iromaction;
  int? iromactionDoz;
  String? froblok;
  int? froblokDoz;
  String? antiparaTab;
  String? antiparaTabName;
  int? antiparaTabDoz;
  String? pashm;
  String? ghoch;
  String? pashm2;
  String? ghochandazi;
  String? somchini;
  int? zayeman;
  int? zayemanWht;
  int? zayemanShir;
  int? seght;
  int? zayesh;
  String? doctype;
  int? iUnsaved;
  String? ghanghariaDate;
  String? ghanghariaImg;
  String? agalacciDate;
  String? agalacciImg;
  String? iverDate;
  String? iverImg;
  String? iver2Date;
  String? iver2Img;
  String? spraying1Date;
  String? spraying2Date;
  String? spraying1Img;
  String? spraying2Img;
  String? iromactionDate;
  String? iromactionImg;
  String? froblokDate;
  String? froblokImg;
  String? antiparaTabDate;
  String? antiparaTabImg;
  String? pashmDate;
  String? pashmImg;
  String? ghochDate;
  String? pashm2Date;
  String? ghochImg;
  String? antro1Date;
  String? antro1Img;
  String? sharbonImg;
  String? pasteuroseDate;
  String? pasteuroseImg;
  String? brucellosisDate;
  String? brucellosisImg;
  String? sharbon1Date;
  String? sharbon1Img;
  String? taonDate;
  String? taonImg;
  String? pashm2Img;
  String? ghochandaziDate;
  String? ghochandaziImg;
  String? somchiniDate;
  String? somchiniImg;

  ProductivityFormModel({
    this.name = "new-productivity-file-1",
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.docstatus = 0,
    this.idx,
    this.geolocation,
    this.id,
    this.lat,
    this.lon,
    this.damCount,
    this.damType,
    this.nationalId,
    this.province,
    this.mobile,
    this.lastName,
    this.city,
    this.rahbar,
    this.location,
    this.antro1,
    this.antro1Doz,
    this.antro2,
    this.antro2Date,
    this.antro2Img,
    this.antro2Doz,
    this.sharbon,
    this.sharbonDate,
    this.sharbonDoz,
    this.abele,
    this.abeleDate,
    this.abeleImg,
    this.abeleDoz,
    this.brucellosis,
    this.brucellosisDoz,
    this.sharbon1,
    this.sharbon1Doz,
    this.taon,
    this.taonDoz,
    this.pasteurose,
    this.pasteuroseDoz,
    this.barfaki,
    this.barfakiDate,
    this.barfakiImg,
    this.barfakiDoz,
    this.ghangharia,
    this.ghanghariaDoz,
    this.agalacci,
    this.agalacciDoz,
    this.iver,
    this.iverDoz,
    this.iver2,
    this.iver2Doz,
    this.spraying1,
    this.spraying1Doz,
    this.spraying2,
    this.spraying2Doz,
    this.iromaction,
    this.iromactionDoz,
    this.froblok,
    this.froblokDoz,
    this.antiparaTab,
    this.antiparaTabName,
    this.antiparaTabDoz,
    this.pashm,
    this.ghoch,
    this.pashm2,
    this.ghochandazi,
    this.somchini,
    this.zayeman,
    this.zayemanWht,
    this.zayemanShir,
    this.seght,
    this.zayesh,
    this.doctype = "Productivity File",
    this.iUnsaved,
    this.ghanghariaDate,
    this.ghanghariaImg,
    this.agalacciDate,
    this.agalacciImg,
    this.iverDate,
    this.iverImg,
    this.iver2Date,
    this.iver2Img,
    this.spraying1Date,
    this.spraying2Date,
    this.spraying1Img,
    this.spraying2Img,
    this.iromactionDate,
    this.iromactionImg,
    this.froblokDate,
    this.froblokImg,
    this.antiparaTabDate,
    this.antiparaTabImg,
    this.pashmDate,
    this.pashmImg,
    this.ghochDate,
    this.pashm2Date,
    this.ghochImg,
    this.antro1Date,
    this.antro1Img,
    this.sharbonImg,
    this.pasteuroseDate,
    this.pasteuroseImg,
    this.brucellosisDate,
    this.brucellosisImg,
    this.sharbon1Date,
    this.sharbon1Img,
    this.taonDate,
    this.taonImg,
    this.pashm2Img,
    this.ghochandaziDate,
    this.ghochandaziImg,
    this.somchiniDate,
    this.somchiniImg,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['creation'] = this.creation;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['docstatus'] = this.docstatus;
    data['idx'] = this.idx;
    data['id'] = this.id;
    data['dam_count'] = this.damCount;
    data['dam_type'] = this.damType;
    data['national_id'] = this.nationalId;
    data['province'] = this.province;
    data['mobile'] = this.mobile;
    data['last_name'] = this.lastName;
    data['city'] = this.city;
    data['rahbar'] = this.rahbar;
    data['geolocation'] =
        "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{},\"geometry\":{\"type\":\"Point\",\"coordinates\":[$lon,$lat]}}]}";
    data['antro1'] = this.antro1;
    data['antro1_doz'] = this.antro1Doz;
    data['antro2'] = this.antro2;
    data['antro2_date'] = this.antro2Date;
    data['antro2_img'] = this.antro2Img;
    data['antro2_doz'] = this.antro2Doz;
    data['sharbon'] = this.sharbon;
    data['sharbon_date'] = this.sharbonDate;
    data['sharbon_doz'] = this.sharbonDoz;
    data['abele'] = this.abele;
    data['abele_date'] = this.abeleDate;
    data['abele_img'] = this.abeleImg;
    data['abele_doz'] = this.abeleDoz;
    data['brucellosis'] = this.brucellosis;
    data['brucellosis_doz'] = this.brucellosisDoz;
    data['sharbon1'] = this.sharbon1;
    data['sharbon1_doz'] = this.sharbon1Doz;
    data['taon'] = this.taon;
    data['taon_doz'] = this.taonDoz;
    data['pasteurose'] = this.pasteurose;
    data['pasteurose_doz'] = this.pasteuroseDoz;
    data['barfaki'] = this.barfaki;
    data['barfaki_date'] = this.barfakiDate;
    data['barfaki_img'] = this.barfakiImg;
    data['barfaki_doz'] = this.barfakiDoz;
    data['ghangharia'] = this.ghangharia;
    data['ghangharia_doz'] = this.ghanghariaDoz;
    data['agalacci'] = this.agalacci;
    data['agalacci_doz'] = this.agalacciDoz;
    data['iver'] = this.iver;
    data['iver_doz'] = this.iverDoz;
    data['iver2'] = this.iver2;
    data['iver2_doz'] = this.iver2Doz;
    data['spraying1'] = this.spraying1;
    data['spraying1_doz'] = this.spraying1Doz;
    data['spraying2'] = this.spraying2;
    data['spraying2_doz'] = this.spraying2Doz;
    data['iromaction'] = this.iromaction;
    data['iromaction_doz'] = this.iromactionDoz;
    data['froblok'] = this.froblok;
    data['froblok_doz'] = this.froblokDoz;
    data['antipara_tab'] = this.antiparaTab;
    data['antipara_tab_name'] = this.antiparaTabName;
    data['antipara_tab_doz'] = this.antiparaTabDoz;
    data['pashm'] = this.pashm;
    data['ghoch'] = this.ghoch;
    data['pashm2'] = this.pashm2;
    data['ghochandazi'] = this.ghochandazi;
    data['somchini'] = this.somchini;
    data['zayeman'] = this.zayeman;
    data['zayeman_wht'] = this.zayemanWht;
    data['zayeman_shir'] = this.zayemanShir;
    data['seght'] = this.seght;
    data['zayesh'] = this.zayesh;
    data['doctype'] = this.doctype;
    data['__unsaved'] = this.iUnsaved;
    data['ghangharia_date'] = this.ghanghariaDate;
    data['ghangharia_img'] = this.ghanghariaImg;
    data['agalacci_date'] = this.agalacciDate;
    data['agalacci_img'] = this.agalacciImg;
    data['iver_dat'] = this.iverDate;
    data['iver_img'] = this.iverImg;
    data['iver2_date'] = this.iver2Date;
    data['iver2_img'] = this.iver2Img;
    data['spraying1_date'] = this.spraying1Date;
    data['spraying2_date'] = this.spraying2Date;
    data['spraying1_img'] = this.spraying1Img;
    data['spraying2_img'] = this.spraying2Img;
    data['iromaction_date'] = this.iromactionDate;
    data['iromaction_img'] = this.iromactionImg;
    data['froblok_date'] = this.froblokDate;
    data['froblok_img'] = this.froblokImg;
    data['antipara_tab_date'] = this.antiparaTabDate;
    data['antipara_tab_img'] = this.antiparaTabImg;
    data['pashm_date'] = this.pashmDate;
    data['pashm_img'] = this.pashmImg;
    data['ghoch_date'] = this.ghochDate;
    data['pashm2_date'] = this.pashm2Date;
    data['ghoch_img'] = this.ghochImg;
    data['antro1_date'] = this.antro1Date;
    data['antro1_img'] = this.antro1Img;
    data['sharbon_img'] = this.sharbonImg;
    data['pasteurose_date'] = this.pasteuroseDate;
    data['pasteurose_img'] = this.pasteuroseImg;
    data['brucellosis_date'] = this.brucellosisDate;
    data['brucellosis_img'] = this.brucellosisImg;
    data['sharbon1_date'] = this.sharbon1Date;
    data['sharbon1_img'] = this.sharbon1Img;
    data['taon_date'] = this.taonDate;
    data['taon_img'] = this.taonImg;
    data['lat'] = lat;
    data['lon'] = lon;
    data['pashm2_img'] = this.pashm2Img;
    data['ghochandazi_date'] = this.ghochandaziDate;
    data['ghochandazi_img'] = this.ghochandaziImg;
    data['somchini_date'] = this.somchiniDate;
    data['somchini_img'] = this.somchiniImg;
    data['__islocal'] = 1;
    data['__unsaved'] = 0;
    data["_user_tags"] = json.encode(["ANDROID"]);
    return data;
  }

  factory ProductivityFormModel.fromJson(Map<String, dynamic> data) {
    return ProductivityFormModel(
      name: data['name'],
      owner: data['owner'],
      lat: data['lat'],
      lon: data['lon'],
      geolocation:
          LocationExtractor.extractProductLocation(data['geolocation']),
      creation: data['creation'],
      modified: data['modified'],
      modifiedBy: data['modified_by'],
      docstatus: data['docstatus'],
      idx: data['idx'],
      id: data['id'],
      damCount: data['dam_count'],
      damType: data['dam_type'],
      nationalId: data['national_id'],
      province: data['province'],
      mobile: data['mobile'],
      lastName: data['last_name'],
      city: data['city'],
      rahbar: data['rahbar'],
      location: data['location'],
      antro1: data['antro1'],
      antro1Doz: data['antro1_doz'],
      antro2: data['antro2'],
      antro2Date: data['antro2_date'],
      antro2Img: data['antro2_img'],
      antro2Doz: data['antro2_doz'],
      sharbon: data['sharbon'],
      sharbonDate: data['sharbon_date'],
      sharbonDoz: data['sharbon_doz'],
      abele: data['abele'],
      abeleDate: data['abele_date'],
      abeleImg: data['abele_img'],
      abeleDoz: data['abele_doz'],
      brucellosis: data['brucellosis'],
      brucellosisDoz: data['brucellosis_doz'],
      sharbon1: data['sharbon1'],
      sharbon1Doz: data['sharbon1_doz'],
      taon: data['taon'],
      taonDoz: data['taon_doz'],
      pasteurose: data['pasteurose'],
      pasteuroseDoz: data['pasteurose_doz'],
      barfaki: data['barfaki'],
      barfakiDate: data['barfaki_date'],
      barfakiImg: data['barfaki_img'],
      barfakiDoz: data['barfaki_doz'],
      ghangharia: data['ghangharia'],
      ghanghariaDoz: data['ghangharia_doz'],
      agalacci: data['agalacci'],
      agalacciDoz: data['agalacci_doz'],
      iver: data['iver'],
      iverDoz: data['iver_doz'],
      iver2: data['iver2'],
      iver2Doz: data['iver2_doz'],
      spraying1: data['spraying1'],
      spraying1Doz: data['spraying1_doz'],
      spraying2: data['spraying2'],
      spraying2Doz: data['spraying2_doz'],
      iromaction: data['iromaction'],
      iromactionDoz: data['iromaction_doz'],
      froblok: data['froblok'],
      froblokDoz: data['froblok_doz'],
      antiparaTab: data['antipara_tab'],
      antiparaTabName: data['antipara_tab_name'],
      antiparaTabDoz: data['antipara_tab_doz'],
      pashm: data['pashm'],
      ghoch: data['ghoch'],
      pashm2: data['pashm2'],
      ghochandazi: data['ghochandazi'],
      somchini: data['somchini'],
      zayeman: data['zayeman'],
      zayemanWht: data['zayeman_wht'],
      zayemanShir: data['zayeman_shir'],
      seght: data['seght'],
      zayesh: data['zayesh'],
      doctype: data['doctype'],
      iUnsaved: data['__unsaved'],
      ghanghariaDate: data['ghangharia_date'],
      ghanghariaImg: data['ghangharia_img'],
      agalacciDate: data['agalacci_date'],
      agalacciImg: data['agalacci_img'],
      iverDate: data['iver_dat'],
      iverImg: data['iver_img'],
      iver2Date: data['iver2_date'],
      iver2Img: data['iver2_img'],
      spraying1Date: data['spraying1_date'],
      spraying2Date: data['spraying2_date'],
      spraying1Img: data['spraying1_img'],
      spraying2Img: data['spraying2_img'],
      iromactionDate: data['iromaction_date'],
      iromactionImg: data['iromaction_img'],
      froblokDate: data['froblok_date'],
      froblokImg: data['froblok_img'],
      antiparaTabDate: data['antipara_tab_date'],
      antiparaTabImg: data['antipara_tab_img'],
      pashmDate: data['pashm_date'],
      pashmImg: data['pashm_img'],
      ghochDate: data['ghoch_date'],
      pashm2Date: data['pashm2_date'],
      ghochImg: data['ghoch_img'],
      antro1Date: data['antro1_date'],
      antro1Img: data['antro1_img'],
      sharbonImg: data['sharbon_img'],
      pasteuroseDate: data['pasteurose_date'],
      pasteuroseImg: data['pasteurose_img'],
      brucellosisDate: data['brucellosis_date'],
      brucellosisImg: data['brucellosis_img'],
      sharbon1Date: data['sharbon1_date'],
      sharbon1Img: data['sharbon1_img'],
      taonDate: data['taon_date'],
      taonImg: data['taon_img'],
      pashm2Img: data['pashm2_img'],
      ghochandaziDate: data['ghochandazi_date'],
      ghochandaziImg: data['ghochandazi_img'],
      somchiniDate: data['somchini_date'],
      somchiniImg: data['somchini_img'],
    );
  }
}
