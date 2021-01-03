import 'dart:convert';

import 'package:MoneyExchangeApp/service/data.dart';
import 'package:MoneyExchangeApp/src/calculator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_admob/firebase_admob.dart';

class ExchangeView extends StatefulWidget {
  @override
  _ExchangeViewState createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView> {
  BannerAd myBannerAd;
  List <String> countries = new List();
  List <String> currencies = new List();
  bool _loading = true;
  bool isLoadingFailed = false;
  DateTime myDateTime;
  int lastUpdateValue;
  DateTime formattedValue;
 
  BannerAd biuldBannerAd(){
    return BannerAd(
      adUnitId: 'ca-app-pub-8107971978330636/7979626862',
      //adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event){
        if (event == MobileAdEvent.loaded){
          myBannerAd..show();
        }
        print("BannerAd $event");
      },
    );
  }

  getLatestCurrencies() async{
    _loading = true;
    await http.get("https://forex.cbm.gov.mm/api/latest").then(
      (value){
        Map<String, dynamic> jsonData = jsonDecode(value.body);
        lastUpdateValue = int.parse(jsonData["timestamp"]);
        jsonData["rates"].forEach((key,value){
          setState(() {
            _loading = false;
            isLoadingFailed = false;
            formattedValue = DateTime.fromMicrosecondsSinceEpoch(lastUpdateValue*1000000);
            countries.add(key.toString());
            currencies.add(value.toString());
          });
        });
      }).catchError((error){
        setState(() {
          _loading = false;
          isLoadingFailed = true;
        });
      });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-8107971978330636~3227005393');
    myBannerAd = biuldBannerAd()..load();
    getLatestCurrencies();
    super.initState();
  }

  @override
  void dispose() { 
    myBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ဗဟိုဘဏ်နိုင်ငံခြားငွေလဲလှယ်နှုန်း"),
        elevation: 0.0,
      ),
          body: _loading ? Center(
                 child: Container(
                   alignment: Alignment.center,
                  child: CircularProgressIndicator(),
               ),
              ) : isLoadingFailed?
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                         gradient: LinearGradient(
                          colors: [
                              Colors.blueGrey[800],
                              Colors.blueGrey[500],
                              Colors.blueGrey[300],
                              ]
                        ),
                      ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ 
                            Icon(Icons.wifi_off, size: 50, color: Colors.white,),
                            Text('အင်တာနက်ချိတ်ဆက်ပြီး',style: TextStyle(color: Colors.white),),
                            Text('ထပ်ကြိုးစားပါ',style: TextStyle(color: Colors.white),),
                            IconButton(icon: Icon(Icons.refresh, color: Colors.white,),
                                 onPressed: (){
                                   getLatestCurrencies();
                                 })
                    ],),
                  ))        
               : Column(
              children: <Widget>[
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                 width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     colors: [
                        Colors.blueGrey[800],
                        Colors.blueGrey[500],
                         Colors.blueGrey[200],
                        ]
                   ),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Text("Last Update ~ "),
                     Text(formattedValue.toString().substring(0,16)),
                     SizedBox(width: 10),
                     IconButton(icon: Icon(Icons.refresh), onPressed: (){
                       getLatestCurrencies();
                     }, iconSize: 20,),
                   ],),
               ),
// Scroll View
              SingleChildScrollView(
           child: Container(
                    child: Column(
               children: <Widget>[
                 Container(
                  //height: 520,
                  height: MediaQuery.of(context).size.height-140,
                     child:  ListView.builder(
                          // padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount : countries.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index ){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context)=> Calculator(
                                  country: countries[index],
                                  rate: currencies[index]
                                )));
                             },
                            child: Container(
                                height: 95,
                                 margin: EdgeInsets.all(7),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.blueAccent),
                                      color: Colors.blueGrey[800],
                                     ),
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Image(image: AssetImage("assets/${countries[index]}.png")),
                                      ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 250,
                                      //  color: Colors.red,
                                      child: Align(
                                          child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                        Text("${countryName['${countries[index]}']}",style: TextStyle(fontSize: 15, color: Colors.white),),
                                        SizedBox(height: 5),
                                        Text("${currencies[index]} ကျပ်", style: TextStyle(fontSize: 20 ,color: Colors.white ),),
                                        
                                      ],),
                                          )
                                        ),
                                        Container(
                                          height: 90,
                                          alignment: Alignment.centerLeft,
                                          child: Icon(Icons.calculate_outlined, size: 50, color: Colors.yellow[50],),
                                        ),
                                          ],),
                            ),
                          );
                        }
                     )
                   ),
             ],),
           ),
        ),
        ],
      ),
    );
  }
}