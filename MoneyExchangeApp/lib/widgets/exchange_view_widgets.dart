import 'package:MoneyExchangeApp/service/data.dart';
import 'package:MoneyExchangeApp/src/calculator.dart';
import 'package:flutter/material.dart';


/* Widget For showing exchange rates in a listview
/  parameter: Context - context , countries- List of countries , currencies - List of currencies
/  return  : widget element
*/
Widget listView({context, List <String> countries, List <String> currencies}) {
  return SingleChildScrollView(
    child: Container(
      child: Column(
        children: <Widget>[
          Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 140,
              child: ListView.builder(
                  itemCount: countries.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                Calculator(
                                    country: countries[index],
                                    rate: currencies[index]
                                ))
                        );
                      },
                      child: Container(
                        height: 95,
                        margin: EdgeInsets.all(7),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blueAccent),
                          color: Colors.blueGrey[800],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Image(image: AssetImage(
                                  "assets/${countries[index]}.png")),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                width: 250,
                                child: Align(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${countryName['${countries[index]}']}",
                                        style: TextStyle(fontSize: 15,
                                            color: Colors.white),),
                                      SizedBox(height: 5),
                                      Text("${currencies[index]} ကျပ်",
                                        style: TextStyle(fontSize: 20,
                                            color: Colors.white),),
                                    ],),
                                )
                            ),
                            Container(
                              height: 90,
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.calculate_outlined, size: 50,
                                color: Colors.yellow[50],),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              )
          ),
        ],),
    ),
  );
}

/* Widget For updating exchange rates and showing rate information
/  parameter: Context - context , getLatestCurrencies- function for get latest currencies from the api
/  return  : widget element
*/
Widget updateRatesContainer({Function getLatestCurrencies,DateTime value,context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    width: MediaQuery
        .of(context)
        .size
        .width,
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
        Text(value.toString().substring(0, 16)),
        SizedBox(width: 10),
        IconButton(icon: Icon(Icons.refresh), onPressed: () {
          getLatestCurrencies();
        }, iconSize: 20,),
      ],),
  );
}

/* Widget For showing error message
/  parameter: getLatestCurrencies- function for get latest currencies from the api
/  return  : widget element
*/
Widget showErrorMessage(Function getLatestCurrencies) {
  return Container(
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
            Text('အင်တာနက်ချိတ်ဆက်ပြီး',
              style: TextStyle(color: Colors.white),),
            Text('ထပ်ကြိုးစားပါ', style: TextStyle(color: Colors.white),),
            IconButton(icon: Icon(Icons.refresh, color: Colors.white,),
                onPressed: () {
                  getLatestCurrencies();
                })
          ],),
      ));
}