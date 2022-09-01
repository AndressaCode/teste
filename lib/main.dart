import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// const request = 'https://api.hgbrasil.com/finance?key=c00dd66a';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.amber,
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.amberAccent,
        textTheme: ButtonTextTheme.primary,
      ),
    ),
    home: BuscaAcoes(),
  ));
}

class BuscaAcoes extends StatefulWidget {
  @override
  State<BuscaAcoes> createState() => _BuscaAcoesState();
}

class _BuscaAcoesState extends State<BuscaAcoes> {
  String _search;
  final acaoController = TextEditingController();

  Future<Map> _searchStock() async {
    http.Response response;

    response = await http.get(Uri.parse(
        // "https://api.hgbrasil.com/finance?key=c00dd66a"));
        "https://api.hgbrasil.com/finance/stock_price?key=c00dd66a&symbol=$_search"));


    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _searchStock().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Busca de ações'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: acaoController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                    style: const TextStyle(color: Colors.amber),
                    // onSubmitted: (text){
                    //   setState(() {
                    //     _search = text;
                    //   });
                    // },
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _search = acaoController.text;
                  });
                },
              ),
            ],
          ),
          FutureBuilder<Map>(
              future: _searchStock(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      var stockName = snapshot.data['results'];
                      return Text('Ação:  $stockName');
                    }
                }
              })
        ],
      ),
    );
  }
}