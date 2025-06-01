import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(FutureBetterApp());
}

class FutureBetterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutureBetter',
      theme: ThemeData.dark(),
      home: MatchListPage(),
    );
  }
}

class MatchListPage extends StatefulWidget {
  @override
  _MatchListPageState createState() => _MatchListPageState();
}

class _MatchListPageState extends State<MatchListPage> {
  List matches = [];

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

  Future<void> loadMatches() async {
    final data = await rootBundle.loadString('assets/matches.json');
    setState(() {
      matches = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FutureBetter')),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          var match = matches[index];
          return ListTile(
            title: Text(match['match']),
            subtitle: Text(match['date']),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MatchDetailPage(match: match),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MatchDetailPage extends StatelessWidget {
  final dynamic match;
  MatchDetailPage({required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(match['match'])),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Data: ${match['date']}', style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),
          ...match['markets'].map<Widget>((market) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(market['type'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                ...market['data'].map<Widget>((item) {
                  return ListTile(
                    title: Text(item['outcome']),
                    subtitle: Text('Bookmaker: ${item['bookmaker']}  |  FB: ${item['fb']}'),
                    trailing: Text(
                      item['value'],
                      style: TextStyle(
                        color: item['isValue'] ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
