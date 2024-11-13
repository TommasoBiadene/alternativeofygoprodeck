import 'dart:ffi';

import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class CardDetailPage extends StatelessWidget {
  final dynamic card;

  CardDetailPage({required this.card});

  @override
  Widget build(BuildContext context) {
    // Recupera tutte le informazioni dalla carta
    var cardName = card['name'] ?? 'Nome non disponibile';
    var cardType = card['type'] ?? 'Tipo non disponibile';
    var cardDesc = card['desc'] ?? 'Descrizione non disponibile';
    var cardAtk =
        card['atk'] != null ? card['atk'].toString() : 'Non disponibile';
    var cardDef =
        card['def'] != null ? card['def'].toString() : 'Non disponibile';
    var cardAttribute = card['attribute'] ?? 'Non disponibile';
    var cardRace = card['race'] ?? 'Non disponibile';
    var cardLinkVal = card['linkval'] != null
        ? card['linkval'].toString()
        : 'Non disponibile';
    var cardLinkMarkers = card['linkmarkers']?.join(", ") ?? 'Non disponibile';
    var cardImageUrl =
        card['card_images'] != null && card['card_images'].isNotEmpty
            ? card['card_images'][0]['image_url']
            : '';
    var cardSets = card['card_sets'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(cardName),
        backgroundColor: const Color.fromARGB(255, 37, 171, 238),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine della carta
            cardImageUrl.isNotEmpty
                ? Center(
                    child: Image.network(cardImageUrl,
                        height: 300, fit: BoxFit.contain))
                : Center(child: Icon(Icons.image_not_supported, size: 100)),
            SizedBox(height: 20),

            // Nome della carta
            Center(
              child: Text(
                cardName,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900]),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _banStatus("TCG", card['banlist_info']?['ban_tcg'] ?? ' '),
              SizedBox(width: 50),
              _banStatus("OCG", card['banlist_info']?['ban_ocg'] ?? ' '),
            ]),
            SizedBox(height: 10),

            // Descrizione della carta
            Card(
              elevation: 5,
              color: Colors.blueGrey[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '$cardDesc',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey[800]),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Card info:',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900])),

            // Attributi della carta
            _buildCardInfoRow('Attribute', cardAttribute),
            _buildCardInfoRow('Type', cardRace),
            _buildCardInfoRow('ATK', cardAtk),
            _buildCardInfoRow('DEF', cardDef),

            _buildCardInfoRow('Link Val', cardLinkVal),
            _buildCardInfoRow('Link Markers', cardLinkMarkers),
            SizedBox(height: 10),
            /* _buildCardInfoRow("Banlist TGC",
                card['banlist_info']?['ban_tcg'] ?? 'free from jail'),*/

            Text('Edizioni:',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900])),
            SizedBox(height: 10),

            ...cardSets.map<Widget>((edition) {
              //var setName = edition['set_name'] ?? 'Nome non disponibile';
              var setCode = edition['set_code'] ?? 'Codice non disponibile';
              var setRarity = edition['set_rarity'] ?? 'Rarità non disponibile';
              //setCode = setCode.split('-')[0];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardInfoRow(setCode, setRarity),
                  //_buildCardInfoRow('Rarità', setRarity),
                  SizedBox(height: 10), // Spazio tra le edizioni
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _banStatus(String ban, String type) {
    if (type == 'Forbidden') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$ban ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Image.asset(
            'assets/limited_0.png',
            width: 28,
            height: 28,
          )
        ],
      );
    } else if (type == 'Limited') {
      return Row(
        children: [
          Text(
            '$ban: ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            'assets/limited_1.png',
            width: 28,
            height: 28,
          )
        ],
      );
    } else if (type == 'Semi-Limited') {
      return Row(
        children: [
          Text(
            '$ban: ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            'assets/limited_2.png',
            width: 28,
            height: 28,
          )
        ],
      );
    } else
      return SizedBox();
  }

  // Funzione per costruire le righe con le informazioni card
  Widget _buildCardInfoRow(String label, String value) {
    if (!(value == 'Non disponibile')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800]),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else
      return SizedBox();
  }

  // Funzione per lanciare l'URL in un browse
}
