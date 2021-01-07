import 'dart:convert';

import 'package:MoneyExchangeApp/widgets/exchange_view_widgets.dart';
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

  BannerAd biuldBannerAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-8107971978330636/7979626862',
      //adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          myBannerAd..show();
        }
        print("BannerAd $event");
      },
    );
  }

  // Function for fetching latest exchnage rate from the api
  getLatestCurrencies() async {
    _loading = true;
    await http.get("https://forex.cbm.gov.mm/api/latest").then(
            (value) {
          Map<String, dynamic> jsonData = jsonDecode(value.body);
          lastUpdateValue = int.parse(jsonData["timestamp"]);
          jsonData["rates"].forEach((key, value) {
            setState(() {
              _loading = false;
              isLoadingFailed = false;
              formattedValue = DateTime.fromMicrosecondsSinceEpoch(
                  lastUpdateValue * 1000000);
              countries.add(key.toString());
              currencies.add(value.toString());
            });
          });
        }).catchError((error) {
      setState(() {
        _loading = false;
        isLoadingFailed = true;
      });
    });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(
        appId: 'ca-app-pub-8107971978330636~3227005393');
    myBannerAd = biuldBannerAd()
      ..load();
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
              ) : isLoadingFailed ?
              showErrorMessage(getLatestCurrencies)
              : Column(
                children: <Widget>[
                  // Container for updating exchange rates
                  updateRatesContainer(getLatestCurrencies: getLatestCurrencies,value: formattedValue,context: context),

                  // Scroll View for exchange rates
                  listView(
                  context: context, countries: countries, currencies: currencies),
                  ],
                ),
    );
  }
}