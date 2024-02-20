import 'dart:convert';
import 'dart:typed_data';
import 'package:depremplusim/main.dart';
import 'package:depremplusim/model/depremcont.dart';
import 'package:depremplusim/page/auth/login_view.dart';
import 'package:depremplusim/page/auth/sign_in_page.dart';

import 'package:depremplusim/page/notifi/notifi_page.dart';
import 'package:depremplusim/page/settings/settings_page.dart';
import 'package:depremplusim/page/notifi/notifi_page.dart';
import 'package:depremplusim/page/settings/settings_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kartal/kartal.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:xml/xml.dart';
final controller = Get.put(depremlerController());

class Filter {
  final String name;
  final String value;

  Filter(this.name, this.value);
}

DateTime parseDateTime(String dateTimeString) {
 // print("************");
 // print("ilk tarih" + dateTimeString);
  // gelen tarihi zaman nesnesine değiştir
  try {
    final parts = dateTimeString.split(' ');
    if (parts.length != 2) {
      throw FormatException('Geçersiz tarih saat dizisi');
    }
    final datePart = parts[0];
    final timePart = parts[1];
 // print("saatten ayrılmış tarih" + datePart);
  final dateSeparator = datePart.contains('-') ? '-' : '.';

    final dateParts = datePart.split(dateSeparator);
 //  print("seperator ile ayrılmış tarih " + dateParts.toString());
 if (dateParts.length != 3) {
      throw FormatException('Geçersiz saat formatı');
    }
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);
  //  print("taih yıl ay gün" + year.toString() + month.toString() + day.toString());
  //  print("tarhi kısmı bitti şimdi saat");
  //  print("split edilmemiş saat " + timePart);
    final timeParts = timePart.split(':');
  //  print("split edilmiş saat " + timeParts.toString());
    if (timeParts.length != 3) {
      throw FormatException('Geçersiz saat formatı !');
    }

    final hour = int.parse(timeParts[0]);
//   print("saat $hour ");
    final minute = int.parse(timeParts[1]);
  //  print("dakika $minute ");
    final seconds = timeParts[2].split('.')[0];
   //  print("saniye ilk $seconds");
final second = int.parse(seconds);
     //     print("saniye ikinci $seconds");
//  print("0000000000000");
    return DateTime(year, month, day, hour, minute, second);
  } catch (e) {
  //  print('Hata: $e');
    return DateTime.now(); // Hata durumunda geçerli tarihi ve saati döndürün
  }
}
class depremler {
  final DateTime name;
  final String location;
  final double latitude;
  final double longitude;
  final double magnitude;
  final double depth;

  depremler({
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.magnitude,
    required this.depth,
  });
 
  factory depremler.fromXmlElement(XmlElement element) {
    print("gelen lok");
    print(element.getAttribute('lokasyon')); 
    return depremler(
      name:  parseDateTime( element.getAttribute('name') ?? ''),
      location: element.getAttribute('lokasyon') ?? '',
      latitude: double.parse(element.getAttribute('lat') ?? '0.0'),
      longitude: double.parse(element.getAttribute('lng') ?? '0.0'),
      magnitude: double.parse(element.getAttribute('mag') ?? '0.0'),
      depth: double.parse(element.getAttribute('Depth') ?? '0.0'),
    );
  }
}
Set<Marker> _createMarkers(List<depremler> e,markerIcon) {


    return e.map <Marker> ((eq) {
    return Marker(
              icon :markerIcon, // İkonu özelleştirin
      markerId: MarkerId(eq.name.toString()),
      position: LatLng(
        double.parse(eq.latitude.toString()), 
        double.parse(eq.longitude.toString())
      ),
      infoWindow: InfoWindow(
        title: eq.location.toString(), 
        snippet: "${eq.name} - ${eq.magnitude}"
      ),
    );
  }) .toSet() ;

}

filtre(List<depremler> data,List<int>buyukluk,List<String>tarih ){
  // tarih sıralama bas tarih, son tarih bir ay icinde 2023.08.01 01:19:48
  // eğer bir aydanfazlaysa fetch yeniden çekilmeli

  var bastarih;
// once tarih filtresi yapılacak
// sonra buyukluk filtresi yapılacak
for (var i = 0; i < data.length; i++) {
  if(data[i].magnitude>5){
    print(data[i].name);
  }
}
// buyukluk
//tarih

}
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Düzenlemeleri burada yapabilirsiniz.
    final double x = scaffoldGeometry.scaffoldSize.width - 60.0;
    final double y = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height - 55.0;
    return Offset(x, y);
  }
}

class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
@override


 BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
 var ay=9;
  var yil=2023;
  var ozel="2";
// ilk sırala

ilksira()async{
  final data = await controller.sirala(3);
   // 1 buyukten kucuge
    // 2 kucukten buyuge

    // 3 en son
    // 4 en eski
  
 await controller.depremlers(data);
}


void initState() {
  addCustomIcon();


  var a = controller.fetchDataTurkey(0,0,2) ;


  a.then((value) => controller.depremlers(value)).then((value) {
      ilksira();

  },);
  super.initState();
}
void addCustomIcon() {
  BitmapDescriptor.fromAssetImage(

           ImageConfiguration(

 size: Size(25, 25),
             
          ), "assets/icon/red2.png",
   // Görüntü genişliği
  )
      .then(
    (icon) {
      setState(() {
        markerIcon = icon;  
      });
    },
  );}
  // harita için ilk konum
 
  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor:Color.fromARGB(255, 37, 1, 1),
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Son Depremler',
            style: context.general.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
          Config.login=="1" ?    IconButton(
                onPressed: () {
                  context.route.navigateToPage(const NotifiPage());
                },
                icon: SvgPicture.asset("assets/icon/icon_notifi.svg",color: Colors.white,),color: Colors.white,)
                
                : Container()
                
                ,
         Config.login=="1" ?   IconButton(
                onPressed: () {
                  context.route.navigateToPage(const SettingsPage());
                },
                icon: SvgPicture.asset("assets/icon/icon_settings1.svg",color: Colors.white,)): 

Container(),

          ],
         // bottom: TabBar(
          //  labelColor: Colors.white,
          //  unselectedLabelColor: Colors.white,
          //  labelStyle: context.general.textTheme.titleMedium
           //     ?.copyWith(fontWeight: FontWeight.bold),
         //   indicatorColor: context.general.colorScheme.surfaceTint,
         //   tabs: const [
         //     Tab(
           //     text: "TÜRKİYE",
         //     ),
            
         //   ],
       //   ),
        ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(),

           floatingActionButton:
       
      Obx(() {
       return controller.getfiltrelendi() ? FloatingActionButton (onPressed: () {
          controller.fetchDataTurkey(0,0,1);
        },
        backgroundColor: Colors.red,
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
       Text("Filtre Sıfırla" ,
       textAlign:  TextAlign.center
       ,
       style: context.general.textTheme.titleMedium?.copyWith(
           color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10,
          ),),
        Icon(Icons.close,color: Colors.white,)
        

       ],),) : Container();
      }),
      bottomNavigationBar:             FilterSortRow(),

        body:
       
    Turkiyedepremler(markerIcon:markerIcon),
        
       //  TabBarView(
          //        physics: NeverScrollableScrollPhysics(), // Bu satır kaydırmayı devre dışı bırakır

        //  children: [
            // Türkiye depremleri için widget
       //      Turkiyedepremler(markerIcon:markerIcon),
            // Dünya depremleri için widget
         //   EarthView(
           //   ulke: '',
          //  )
     //     ],
        
     
   //     )  ),
    
      ));
  }
}


class Turkiyedepremler extends StatefulWidget {
 var markerIcon;
 
   Turkiyedepremler({
    super.key,
    required this.markerIcon,
  });
 static final CameraPosition _kInitialPosition = CameraPosition(
  target: LatLng(39.925533, 32.866287), 
    zoom: 5
  );

  @override
  State<Turkiyedepremler> createState() => _TurkiyedepremlerState();
}

class _TurkiyedepremlerState extends State<Turkiyedepremler> {
   late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
double height = MediaQuery.of(context).size.height;
return Obx(() {
  if(controller.isLoading) {
    return
     Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ));
  }
    return FutureBuilder<RxList<depremler>>(
        future:  controller.getdepremlers() ,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
           controller.depremlers = snapshot.data!;
           
            return  Container(child: 
              
              Column(children: [

                Container(

            height:height * 0.28,
            
  margin: EdgeInsets.all(0),
  padding: EdgeInsets.all(0), // İçeriği kenarlardan uzaklaştırmak için
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatmak için
   
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1), // Gölgelendirme rengi
        spreadRadius: 3, // Yayılma yarıçapı
        blurRadius: 5, // Bulanıklık yarıçapı
        offset: Offset(0, 3), // Gölgelenme pozisyonu
      ),
    ],
  ), 
            child:    Obx(() {
              

               return GoogleMap(

              initialCameraPosition: Turkiyedepremler._kInitialPosition,
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: _createMarkers( controller.depremlers,widget.markerIcon),
            ); }),),
            
            
            
          
          Container(
            decoration: BoxDecoration(
                color: Colors.transparent,

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 3,
      offset: Offset(0, 3), 
    ),
  ],
), //ddrtyasd
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            child: 
          
          Obx(() =>
          Text(
                 controller.getfiltrelendi() ? "Yaptığınız Filtreye Göre " +"Türkiye'de ${controller.secilentarih.toString()} "  "${controller.depremlers.length.toString()}" + " adet deprem bulundu" :  "Türkiye'de ${controller.secilentarih.toString()} "  "${controller.depremlers.length.toString()}" + " adet deprem bulundu" ,style:  TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 12,
  letterSpacing: 1.5,
  color: Colors.white
)
          )
          ,) ),
      
    
  
            
              Container(
                  height: height * 0.49,
  margin: EdgeInsets.all(5),
  padding: EdgeInsets.all(5), // İçeriği kenarlardan uzaklaştırmak için
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10), // Köşeleri yuvarlatmak için
   
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1), // Gölgelendirme rengi
        spreadRadius: 3, // Yayılma yarıçapı
        blurRadius: 5, // Bulanıklık yarıçapı
        offset: Offset(0, 3), // Gölgelenme pozisyonu
      ),
    ],
  ), child:
            
              
              Obx(() { return  SingleChildScrollView(
                child: Column(
                  children: 
                  
                  List.generate(
                      snapshot.data?.length ?? 0,
                      (index) => GestureDetector(
  onTap: () {
    
    

  final lat = double.parse(controller.depremlers[index].latitude.toString()); 
  final lng = double.parse(controller.depremlers[index].longitude.toString());
  mapController.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 10)  
    )
  );
   mapController.showMarkerInfoWindow(
    MarkerId(controller.depremlers[index].name.toString()) 
  );
   // ...
  },child: depremlerWidget(
                        onBackPressed: () {
  mapController.animateCamera(
    CameraUpdate.newCameraPosition(CameraPosition(
  target: LatLng(39.925533, 32.866287), 
    zoom: 5
  ))
  );
},
                        onTap: () {
},
                            date:  controller.depremlers[index].name,
                            depth:   controller.depremlers[index].depth.toString(),
                            lat:  controller.depremlers[index].latitude.toString(),
                            lon:  controller.depremlers[index].longitude.toString(),
                            mag:  controller.depremlers[index].magnitude.toString(),
                            place:  controller.depremlers[index].location.toString(),
                           
                          )),
                ),
               ) ); 
              })),
              
               
              
                
            
            
              
               ],),
              )  ;
          } else {
            return  Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });});
   }
}



class FilterSortRow extends StatefulWidget {
  @override
  State<FilterSortRow> createState() => _FilterSortRowState();
}

class _FilterSortRowState extends State<FilterSortRow> {
  @override
   double selectedMinSize = 0; // Minimum büyüklük
  double selectedMaxSize = 10; // Maksimum büyüklük
  double selectedMinDepth = 0.0; // Minimum derinlik
  double selectedMaxDepth = 1000; // Maksimum derinlik
  TimeOfDay selectedStartTime = TimeOfDay. now().replacing(hour: 0, minute: 0)
  ; // Başlangıç saatini saklar
  TimeOfDay selectedEndTime = TimeOfDay.now().replacing(hour: 23, minute: 59); // Bitiş saatini saklar

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.08,

  margin: EdgeInsets.all(0),
  padding: EdgeInsets.all(0), // İçeriği kenarlardan uzaklaştırmak için
  decoration: BoxDecoration(
    color:  Color.fromARGB(255, 74, 1, 1),
    borderRadius: BorderRadius.circular(0), // Köşeleri yuvarlatmak için
    
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1), // Gölgelendirme rengi
        spreadRadius: 3, // Yayılma yarıçapı
        blurRadius: 5, // Bulanıklık yarıçapı
        offset: Offset(0, 3), // Gölgelenme pozisyonu
      ),
    ],
  ), child:
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

   

        FilterSortItem(
          icon: Icons.watch_later_outlined,
          label: 'Tarih',
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: 

                   ListView(
                      children: <Widget>[
                        CustomListItem(
                          icon: Icons.access_time,
                          title: 'Son 24 Saat',
                          onTap: ()async {
                            //son24saat =1
//sonHafta =2
//SonAY =3

final data = await controller.fetchDataTurkey(0, 0, 1);
  
 await controller.depremlers(data);

  
                      
                            Navigator.pop(context);
                          },
                        ),
                        CustomListItem(
                          icon: Icons.calendar_today,
                          title: 'Son Hafta',
                          onTap: () async {
                              //son24saat =1
//sonHafta =2
//SonAY =3                    
                         final data = await controller.fetchDataTurkey(0, 0, 2);

 await controller.depremlers(data);
                            // Son hafta seçeneğine tıklanıldığında yapılacak işlemleri burada yapabilirsiniz.
                            Navigator.pop(context);
                          },
                        ),
                        CustomListItem(
                          icon: Icons.calendar_view_day,
                          title: 'Son Ay',
                          onTap: () async {
                              //son24saat =1
//sonHafta =2
//SonAY =3

                            final data = await controller.fetchDataTurkey(0, 0, 3);
  
  await controller.depremlers(data);
                          
                            // Son ay seçeneğine tıklanıldığında yapılacak işlemleri burada yapabilirsiniz.
                            Navigator.pop(context);
                          },
                        ),
                        CustomListItem(
                          icon: Icons.calendar_today,
                          title: 'Özel Tarih',
                          onTap: () async {
                            // Özel tarih seçeneğine tıklanıldığında özel tarih seçiciyi açabilirsiniz.
                            Navigator.pop(context);
                         DateTime? date=  await  showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2003),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              var ay=  date.month.toString();
                              var yil=  date.year.toString();
                              if (ay.length==1){
                                ay="0"+ay;
                              }
                               print("secilen tarih" + date.month.toString() + date.year.toString());
                                   final data = await controller.fetchDataTurkey(ay, yil, 0);
  
  await controller.depremlers(data);
                            }
                            else {
                              print("tarih seçilmedi");
                            }
                          },
                        ),
                      ],
                    ),
                  
                  // buyukluk
                  // tarih

                );
              },
            );
          },
        ),
        FilterSortItem(
          icon: Icons.filter_list,
          label: 'Filtrele',
          onPressed: () {
            // Filtreleme işlemleri için modal açılabilir.
          
showModalBottomSheet(
  context: context,

  builder: (BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView( // Kaydırılabilir içerik ekleyin
          child:  Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          height: 500.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Büyüklük Seç',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Seçilen Min Büyüklük: ${selectedMinSize.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 13),
              ),
               Text(
                'Seçilen Max Büyüklük: ${selectedMaxSize.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 13),
              ),
              RangeSlider(
                values: RangeValues(selectedMinSize, selectedMaxSize),
                onChanged: (RangeValues newValues) {
                  setState(() {
                    selectedMinSize = newValues.start;
                    selectedMaxSize = newValues.end;
                  });
                },
                min: 0.0,
                max: 10.0,
                labels: RangeLabels(
                  '${selectedMinSize.toStringAsFixed(2)}',
                  '${selectedMaxSize.toStringAsFixed(2)}',
                ),
              ),
              SizedBox(height: 5),
            ExpansionTile(
  title: Text(
    'Derinlik Seç',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Seçilen Min Derinlik: ${selectedMinDepth.toStringAsFixed(2)}',
            
            style: TextStyle(fontSize: 16),
          ),
           Text(
            'Seçilen Max Derinlik: ${selectedMaxDepth.toStringAsFixed(2)}',
            
            style: TextStyle(fontSize: 16),
          ),
          RangeSlider(
            values: RangeValues(selectedMinDepth, selectedMaxDepth),
            onChanged: (RangeValues newValues) {
              setState(() {
                selectedMinDepth = newValues.start;
                selectedMaxDepth = newValues.end;
              });
            },
            min: 0.0,
            max: 1000.0,
            labels: RangeLabels(
              '${selectedMinDepth.toStringAsFixed(2)}',
              '${selectedMaxDepth.toStringAsFixed(2)}',
            ),
          ),
        ],
      ),
    ),
  ],
)
,
              SizedBox(height: 5),
             ExpansionTile(
  title: Text(
    'Başlangıç ve Bitiş Saati Seç',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Başlangıç: ${selectedStartTime.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Bitiş: ${selectedEndTime.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectStartTime(context);
                },
                child: Text('Başlangıç Saati Seç'),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectEndTime(context);
                },
                child: Text('Bitiş Saati Seç'),
              ),
            ],
          ),
        ],
      ),
    ),
  ],
)
,
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: ()async {
                final data = controller.filtrele(selectedMaxSize, selectedMinSize, selectedMaxDepth, selectedMinDepth, selectedStartTime, selectedEndTime);
                
                    await controller.depremlers(data);

                Navigator.pop(context); // Modal'ı kapat
                // her filtrede başında verileri yeniden çekmem lazım
                // filtreyi iptal butonu koymam lazım
                },
                child: Text('Filtrele'),
              ),
            ],
          ),
          )  );
      },
    );
  },
);
              
              
            
          
        
      
    

      
    
          },
        ),
        FilterSortItem(
          icon: Icons.sort,
          label: 'Sırala',
          onPressed: () {
            // Sıralama işlemleri için modal açılabilir.
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  // Filtreleme ayarları burada olacak
                  child: 

                   ListView(
                      children: <Widget>[
CustomListItem(
                          icon: Icons.access_time,
                          title: 'Büyüklüğe göre(Büyükten Küçüğe)',
                          onTap: ()async {
                          
                            Navigator.pop(context);

final data = await controller.sirala(1);
   // 1 buyukten kucuge
    // 2 kucukten buyuge

    // 4 en son
    // 3 en eski
  
 await controller.depremlers(data);


                      
                          }),
     
CustomListItem(
                          icon: Icons.access_time,
                          title: 'Büyüklüğe göre(Küçükten Büyüğe)',
                          onTap: ()async {
                          
                            Navigator.pop(context);

final data = await controller.sirala(2);
   // 1 buyukten kucuge
    // 2 kucukten buyuge

    // 3 en son
    // 4 en eski
  
 await controller.depremlers(data);

  
                      
                          }),
 
CustomListItem(
                          icon: Icons.access_time,
                          title: 'Zamana göre(en eski)',
                          onTap: ()async {
                          
                            Navigator.pop(context);

final data = await controller.sirala(4);
   // 1 buyukten kucuge
    // 2 kucukten buyuge

    // 3 en son
    // 4 en eski
  
 await controller.depremlers(data);

  
                      
                          }),
   
CustomListItem(
                          icon: Icons.access_time,
                          title: 'Zamana göre(En son)',
                          onTap: ()async {
                          
                            Navigator.pop(context);

final data = await controller.sirala(3);
   // 1 buyukten kucuge
    // 2 kucukten buyuge

    // 3 en son
    // 4 en eski
  
 await controller.depremlers(data);
  
                      
                          }),
      ],),);

              },
            );
          },
        ),
      ],
      )  );
  }
}

class FilterSortItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  FilterSortItem({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class depremlerWidget extends StatelessWidget {
   depremlerWidget({
    Key? key,
    required this.date,
    required this.lat,
    required this.lon,
    required this.depth,
    required this.mag,
    required this.place,
        required this.onBackPressed,

        required this.onTap    

  }) : super(key: key);

  final DateTime date;
  final String lat;
  final String lon;
  final String depth;
  final String mag;
  final String place;
    final VoidCallback onTap;
  final VoidCallback onBackPressed;
  bool selected=false;

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
double height = MediaQuery.of(context).size.height;
    var tarih = date;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
      padding: EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 74, 1, 1),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Başlık rengi
                  ),
                ),
                SizedBox(height: 4.0),
                 Text(
                  "${tarih.hour}:${tarih.minute}:${tarih.second} - ${tarih.day}.${tarih.month}.${tarih.year}",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey, // Metin rengi
                  ),
                ),
                
              
                 Text(
                  "Derinlik (km): $depth",
                  style: TextStyle(
                    fontSize: 8.0,
                    color: Colors.grey, // Metin rengi
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              width: 48.0,
              height: 48.0,
             
              child: Text(
                mag,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
     selected ?  IconButton(
  icon: Icon(Icons.arrow_back),
  onPressed: onBackPressed
): Container(),
        
       

 ],
      ),
    );
  }
}
class CustomListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  CustomListItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
double height = MediaQuery.of(context).size.height;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.red),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}