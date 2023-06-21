import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class MyHomePage extends StatefulWidget {
  final EthereumAddress contractAddress;
  final Credentials credentials;

  MyHomePage({required this.contractAddress, required this.credentials});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Web3Client _client;
  late HealthRecordContract _contract;

  @override
  void initState() {
    super.initState();
    _client = Web3Client('https://mainnet.infura.io/v3/<your-project-id>', Client());
    _contract = HealthRecordContract(_client, widget.contractAddress);
  }

  Future<void> _addRecord() async {
    final transaction = Transaction.callContract(
      contract: _contract.contract,
      function: _contract.addRecordFunction,
      parameters: [
        'John Doe', // Name
        BigInt.from(30), // Age
        BigInt.from(180), // Height
        BigInt.from(75), // Weight
        ['Pollen', 'Peanuts'], // Allergies
        ['Flu', 'COVID-19'] // Vaccinations
      ],
      from: widget.credentials.address,
    );

    final gas = await _client.getGasPrice();
    final response = await widget.credentials.signTransaction(transaction, _client, maxGas: 100000, gasPrice: gas);
    await _client.sendTransaction(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _addRecord,
          child: Text('Add Record'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _client.dispose();
    super.dispose();
  }
}

class HealthRecordContract {
  final Web3Client client;
  final EthereumAddress contractAddress;

  late DeployedContract _contract;
  late Function _addRecordFunction;

  HealthRecordContract(this.client, this.contractAddress) {
    _contract = DeployedContract(
      ContractAbi.fromJson('[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"string","name":"_name","type":"string"},{"internalType":"uint256","name":"_age","type":"uint256"},{"internalType":"uint256","name":"_height","type":"uint256"},{"internalType":"uint256","name":"_weight","type":"uint256"},{"internalType":"string[]","name":"_allergies","type":"string[]"},{"internalType":"string[]","name":"_vaccinationsTaken","type":"string[]"}],"name":"addRecord","outputs":[],"stateMutability":"nonpayable","type":"function"}]'),
      contractAddress,
    );
    _addRecordFunction = _contract.function('addRecord');
  }

  DeployedContract get contract => _contract;
  Function get addRecordFunction => _addRecordFunction;
}
