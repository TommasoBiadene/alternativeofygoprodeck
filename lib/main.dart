import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'card_detail_page.dart';  // Importiamo la pagina dei dettagli

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ricerca Carta',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HttpRequest(),
    );
  }
}

class HttpRequest extends StatefulWidget {
  @override
  _HttpRequestState createState() => _HttpRequestState();
}

class _HttpRequestState extends State<HttpRequest> {
  String _response = '';
  List<dynamic> _cards = [];
  TextEditingController _controller = TextEditingController();

  // Funzione che effettua la richiesta HTTP
  Future<void> fetchData(String query) async {
    final url = Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=$query');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['data'] != null && data['data'].isNotEmpty) {
          setState(() {
            _cards = data['data'];
            _response = 'Carte trovate: ${_cards.length}';
          });
        } else {
          setState(() {
            _response = 'Nessuna carta trovata';
            _cards = [];
          });
        }
      } else {
        setState(() {
          _response = 'Errore nella richiesta: ${response.statusCode}';
          _cards = [];
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Errore: $e';
        _cards = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ricerca Carta'),
        backgroundColor:  const Color.fromARGB(255, 37, 171, 238),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Barra di ricerca
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Cerca carta',
                hintText: 'Inserisci il nome della carta...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.blueGrey[50],
              ),
              style: TextStyle(fontSize: 18),
              onSubmitted: (value) {
                 String query = _controller.text.trim();
                if (query.isNotEmpty) {
                  fetchData(query);
                } else {
                  setState(() {
                    _response = '';
                    _cards = [];
                  });
                }
              },



            ),
            SizedBox(height: 20),

            // Bottone per fare la ricerca
            ElevatedButton(
              onPressed: () {
                String query = _controller.text.trim();
                if (query.isNotEmpty) {
                  fetchData(query);
                } else {
                  setState(() {
                    _response = '';
                    _cards = [];
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[600],
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Fai la ricerca', style: TextStyle(color: Colors.white)),
              
            ),
            SizedBox(height: 20),

            // Risultati della ricerca
            Text(
              _response,
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Lista delle carte
            _cards.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        var card = _cards[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: card['card_images'] != null && card['card_images'].isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      card['card_images'][0]['image_url'],
                                      width: 60,
                                      height: 90,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Icon(Icons.image_not_supported),
                            title: Text(
                              card['name'] ?? 'Nome non disponibile',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              card['type'] ?? 'Tipo non disponibile',
                              style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CardDetailPage(card: card),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
