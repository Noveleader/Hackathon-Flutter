import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myapp/insideapp.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

class ImportWallet extends StatefulWidget {
  const ImportWallet({Key? key}) : super(key: key);

  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  final _formKey = GlobalKey<FormState>();
  final _privateKeyController = TextEditingController();
  final httpClient = Client();
  final String _rpcUrl = dotenv.env['rpcurl']!;

  bool _isLoading = false;
  String? _error;

  bool _isValidPrivateKey(String privateKey) {
    try {
      EthPrivateKey.fromHex(privateKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _importWallet() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final privateKey = _privateKeyController.text;
    if (!_isValidPrivateKey(privateKey)) {
      setState(() {
        _error = 'Invalid private key';
        _isLoading = false;
      });
      return;
    }

    try {
      final credentials = await EthPrivateKey.fromHex(privateKey);
      final address = await credentials.address;
      final ethClient = Web3Client(
        _rpcUrl,
        httpClient,
      );
      final balance = await ethClient.getBalance(address);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HealthServices()),
      );
    } catch (e) {
      setState(() {
        _error = 'Error importing wallet';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _privateKeyController,
                decoration: InputDecoration(labelText: 'Private Key'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a private key';
                  }
                  if (!_isValidPrivateKey(value)) {
                    return 'Invalid private key';
                  }
                  return null;
                },
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _importWallet(),
                child:
                    _isLoading ? CircularProgressIndicator() : Text('Import'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
