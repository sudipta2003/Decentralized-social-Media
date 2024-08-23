import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'dart:convert';

class TwitterDappMainPage extends StatefulWidget {
  const TwitterDappMainPage({super.key});

  @override
  _TwitterDappMainPageState createState() => _TwitterDappMainPageState();
}

class _TwitterDappMainPageState extends State<TwitterDappMainPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _tweets = [];
  late Web3Client _web3client;
  late EthereumAddress _contractAddress;
  late DeployedContract _contract;
  late ContractFunction _postTweetFunction;
  late ContractFunction _getTweetsFunction;

  @override
  void initState() {
    super.initState();
    _initializeWeb3();
  }

  Future<void> _initializeWeb3() async {
    _web3client = Web3Client(
      'https://open-campus-codex-sepolia.drpc.org',
      http.Client(),
    );

    String abiString = await rootBundle.loadString('abi.json');
    final jsonAbi = jsonDecode(abiString);

    _contractAddress =
        EthereumAddress.fromHex('0x08601fa4241b63d05ea9d9e5336f83631346bb82');

    _contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(jsonAbi), 'TwitterDapp'),
      _contractAddress,
    );

    _postTweetFunction = _contract.function('postTweet');
    _getTweetsFunction = _contract.function('getTweets');

    _fetchTweets();
  }

  Future<void> _postTweet() async {
    if (_controller.text.isEmpty) return;

    try {
      var credentials = EthPrivateKey.fromHex(
          'cfdfe5c6dcb52db401f7dd538c723ad811c3dc33622abeea380a2a698ebe5e3d');

      await _web3client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: _contract,
          function: _postTweetFunction,
          parameters: [_controller.text],
        ),
        chainId: 656476,
      );

      _fetchTweets();
      _controller.clear();
    } catch (e) {
      print('Error posting tweet: $e');
    }
  }

  Future<void> _fetchTweets() async {
    final result = await _web3client.call(
      contract: _contract,
      function: _getTweetsFunction,
      params: [],
    );

    final fetchedTweets = (result[0] as List).map((tweetData) {
      final user = tweetData[0] as EthereumAddress;
      final content = tweetData[1] as String;
      final timestamp = tweetData[2] as BigInt;
      final formattedTime =
          DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000)
              .toLocal()
              .toString();
      return {
        'user': user.toString(),
        'content': content,
        'time': formattedTime
      };
    }).toList();

    setState(() {
      _tweets.clear();
      _tweets.addAll(fetchedTweets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('TwitterDapp'),
            const SizedBox(width: 10),
            Image.asset(
              'assets/logo.png',
              height: 40, // Set the desired height for the image
              width: 40, // Set the desired width for the image
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tweets.length,
              itemBuilder: (context, index) {
                final tweet = _tweets[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tweet['content']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              tweet['time']!,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'User: ${tweet['user']}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Write a tweet...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _postTweet,
                    child: const Text('Post Tweet'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: TwitterDappMainPage(),
  ));
}
