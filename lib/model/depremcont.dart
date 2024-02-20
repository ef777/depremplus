import 'package:depremplusim/page/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class depremlerController extends GetxController {
  
Future<List<depremler>> fetchDataTurkey(ay,yil,ozel
//son24saat =1
//sonHafta =2
//SonAY =3
//  ornek  url = 'http://udim.koeri.boun.edu.tr/zeqmap/xmlt/202308.xml';

) async {
    _isLoading.value = true; // Yükleme başladığında _isLoading değerini true yapın
  filtrelendi.value = false;
var url;
 url = 'http://udim.koeri.boun.edu.tr/zeqmap/xmlt/202308.xml';
  if (ozel != 0){
    if (ozel==1){
      _secilentarih = "Son 24 Saat";
       url = 'http://udim.koeri.boun.edu.tr/zeqmap/xmlt/son24saat.xml';
    }
    if (ozel==2){
            _secilentarih = "Son Hafta";

       url = 'http://udim.koeri.boun.edu.tr/zeqmap/xmlt/sonHafta.xml';
    }
    if (ozel==3){
            _secilentarih = "Son Ay";

       url = 'http://udim.koeri.boun.edu.tr/zeqmap/xmlt/SonAY.xml';
    }
  } 
  else {
          _secilentarih = "Seçtiğiniz ${ay}/${yil} tarihinde";

 url = 'http://udim.koeri.boun.edu.tr/zeqmap/xmlt/${yil+ay}.xml';
  }

  final headers = {
    'Accept': '*/*',
    'Referer': 'http://udim.koeri.boun.edu.tr/zeqmap/hgmmap.asp',
    'X-Requested-With': 'XMLHttpRequest',
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36',
  };

  try {
    print("fetch data başladı");
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
        final xmlData = '''
    ${response.body}
  ''';

  final document = XmlDocument.parse(xmlData);
  print("fetch data parse edildi" );
  final depremlers = await document.findAllElements('earhquake')
      .map((element) => depremler.fromXmlElement(element))
      .toList();
          print("fetch data bitti");
          print("modele gelen data uzunlugu" + depremlers.length.toString());
   _isLoading.value = false;
          return depremlers;

    } else {
      print('HTTP isteği başarısız: ${response.statusCode}');
         _isLoading.value = false;

      return [];
    }
  } catch (e) {
    print('Hata oluştu: $e');
       _isLoading.value = false;

    return [];
  }
}

  var depremlers = RxList<depremler>(); 
   var filtrelendi = false.obs;
   get getfiltrelendi => filtrelendi;
  filtrele (double maxbuyuk,double minbuyuk,double maxderin,double minderin,TimeOfDay ilksaat, TimeOfDay sonsaat ){
    List<depremler> yedekListe=[];
    filtrelendi.value = true;
    yedekListe = List.from(depremlers.value); // Yedekleme
    _isLoading.value = true;
    print("önceki filtrelenmis depremler uzunlugu" + yedekListe.length.toString()); 
    if (maxbuyuk != 0){
      yedekListe.removeWhere((element) => element.magnitude > maxbuyuk);
    }
    if (minbuyuk != 0){
      yedekListe.removeWhere((element) => element.magnitude < minbuyuk);
    }
    if (maxderin != 0){
      yedekListe.removeWhere((element) => element.depth > maxderin);
    }
    if (minderin != 0){
      yedekListe.removeWhere((element) => element.depth < minderin);
    }
    if (ilksaat != 0){
      print(ilksaat.hour.toString() + " " + ilksaat.minute.toString());
      yedekListe.removeWhere((element) => element.name.hour < ilksaat.hour);
    }
    if (sonsaat != 0){
      yedekListe.removeWhere((element) => element.name.hour > sonsaat.hour);
    }
    print("sonraki filtrelenmisdepremler uzunlugu" + yedekListe.length.toString()); 
    _isLoading.value = false;
    return yedekListe;





  }
  sirala(gelen
    // 1 buyukten kucuge
    // 2 kucukten buyuge

    // 3 en son
    // 4 en eski
  ){
     List<depremler> yedekListe=[];
     yedekListe = List.from(depremlers.value); // Yedekleme

     _isLoading.value = true;
     print("önceki filtrelenmisdepremler uzunlugu" + yedekListe.length.toString()); 
    
    if (gelen == 1){
      yedekListe.sort((a, b) => b.magnitude.compareTo(a.magnitude));
       _isLoading.value = false; 
      return yedekListe;
    }
    if (gelen == 2){
      yedekListe.sort((a, b) => a.magnitude.compareTo(b.magnitude));
             _isLoading.value = false; 

      return yedekListe;
    }
    if (gelen == 3){
      yedekListe.sort((a, b) => b.name.compareTo(a.name));
             _isLoading.value = false; 

      return yedekListe;
    }
    if (gelen == 4){
      yedekListe.sort((a, b) => a.name.compareTo(b.name));
             _isLoading.value = false; 

      return yedekListe;
    } 
   



  }
   var _isLoading = false.obs;

      String _secilentarih = "Son 25 Saat";
 get secilentarih => _secilentarih;
  get isLoading => _isLoading.value;
  Future<RxList<depremler>> getdepremlers() async {
  // veriyi çek
  
  return controller.depremlers; 
}

}