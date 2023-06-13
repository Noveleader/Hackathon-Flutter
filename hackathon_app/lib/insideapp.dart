import 'package:flutter/material.dart';
import '/health.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class HealthServices extends ChangeNotifier {
  final List<health> _health = [];
  final String _rpcUrl = dotenv.env['rpcurl']!;
  final String _wsUrl = dotenv.env['wsurl']!;
  final String _privateKey = dotenv.env['privatekey']!;

  late Web3Client _client;
  HealthServices() {
    init();
  }

  Future<void> init() async {
    await dotenv.load();
    try {
      _client = Web3Client(
        _rpcUrl,
        Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(_wsUrl).cast<String>();
        },
      );
    } catch (e) {
      print(e);
    }
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getABI() async {
    String abiFile = await rootBundle.loadString(
        'D:\VS\Hackathon\blockchain_backend\artifacts\contracts\HealthRecord.sol\HealthRecord.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']));
    _contractAddress = EthereumAddress.fromHex(dotenv.env['contractaddress']);
  }

  late EthPrivateKey _creds;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privateKey);
  }

  late ContractFunction _addRecord;
  late ContractFunction _getRecord;
  late ContractFunction _getRecordCount;
  late ContractFunction _shareRecordAccess;
  late ContractFunction _revokeRecordAccess;
  late ContractFunction _hasAccess;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _addRecord = _deployedContract.function('addRecord');
    _getRecord = _deployedContract.function('getRecord');
    _getRecordCount = _deployedContract.function('getRecordCount');
    _shareRecordAccess = _deployedContract.function('shareRecordAccess');
    _revokeRecordAccess = _deployedContract.function('revokeRecordAccess');
    _hasAccess = _deployedContract.function('hasAccess');
  }

  Future<void> fetchDetails() async {
    int totalRecords = await _client.call(
        contract: _deployedContract, function: _getRecordCount, params: []);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Total Records on Platform: $totalRecords'),
          ),
        ],
      ),
    );
  }

  Future<void> getRecord() async {
    List<dynamic> result = await _client
        .call(contract: _deployedContract, function: _getRecord, params: []);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Total Records on Platform: $result'),
          ),
        ],
      ),
    );
  }
}
