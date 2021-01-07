import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:MoneyExchangeApp/service/data.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  final String country, rate;

  Calculator({@required this.country, this.rate});
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  double _value = 0.0;
  double _valueTwo = 0.0;

  void _onChanged(String value) {
    setState((){
      _value = int.parse(value) / double.parse(widget.rate.replaceAll(',', ''));
    });
  }

  void _onChangedTwo(String value) {
    setState((){
      _valueTwo = int.parse(value) * double.parse(widget.rate.replaceAll(',', ''));
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ငွေလဲလှယ်နှုန်းတွက်ချက်ရန်"),
        elevation: 0.0,
      ),
       body: Container(
        width: MediaQuery.of(context).size.width,
         child: Column(
           children:<Widget>[

             // Showing current currency container
             Container(
               alignment: Alignment.center,
               decoration: BoxDecoration(
                   gradient: LinearGradient(
                     colors: [
                        Colors.blueGrey[800],
                        Colors.blueGrey[500],
                         Colors.blueGrey[200],
                        ]
                   ),
                 ),
               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                 margin: EdgeInsets.only(bottom: 10),
                 width: MediaQuery.of(context).size.width,
                 child: Text(countryName[widget.country]+" - ${widget.country}", 
                              style: TextStyle(color: Colors.white, fontSize: 20),),
              ),

              // Showing current rates
              Container(
                height: 50,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('လက်ရှိနှုန်း : 1 ${widget.country} = ${widget.rate} ကျပ်',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
              ),

              // Exchange rate calculation container
              Container(
                margin: EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[

                  // {currencies} -> MMK text
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Text("${widget.country}",style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),)
                        ),
                        Icon(Icons.arrow_forward, size: 15,),
                        Container(
                          child: Text("MMK",style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),)
                        ),
                      ],)
                  ),

                  // Calculation container
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 40),
                    child: Row(children: <Widget>[
                       Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                            color: Colors.grey[200],
                          ),
                          width: 100,
                          child: TextField(
                            textAlign: TextAlign.end,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '0',
                          ),
                          onChanged: _onChangedTwo,
                          keyboardType: TextInputType.number,
                          )
                        ),
                        Text("  ${widget.country} :  ",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                            color: Colors.grey[200],
                          ),
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(FlutterMoneyFormatter(amount: _valueTwo).output.nonSymbol,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),),
                        ),
                        Container(
                          width: 50,
                          child: Text('  MMK',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),),
                        ),
                    ],)
                  )

                ],),
              ),

              SizedBox(height: 30),

              // MMK -> {currencies} text
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Column(children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Text("MMK",style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),)
                        ),
                        Icon(Icons.arrow_forward, size: 15,),
                        Container(
                          child: Text("${widget.country}",style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),)
                        ),
                      ],)
              ),

              // calculation area
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 40),
                child: Row(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                        color: Colors.grey[200],
                      ),
                      width: 100,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: '0',
                      ),
                      textAlign: TextAlign.end,
                      onChanged: _onChanged,
                      keyboardType: TextInputType.number,
                      )
                    ),
                    Text(" MMK :  ",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                        color: Colors.grey[200],
                      ),
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(FlutterMoneyFormatter(amount: _value).output.nonSymbol,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                    ),
                    Container(
                      width: 50,
                      child: Text('  ${widget.country}',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                    ),
                ],)
              )
              ],),
              ),

           ]
         ),
       ),
    );
  }
}