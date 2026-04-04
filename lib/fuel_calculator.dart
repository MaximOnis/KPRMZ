import 'package:flutter/material.dart';

class FuelCalculatorScreen extends StatefulWidget {
  const FuelCalculatorScreen({super.key});

  @override
  State<FuelCalculatorScreen> createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _sController = TextEditingController();
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _oController = TextEditingController();
  final TextEditingController _wController = TextEditingController();
  final TextEditingController _aController = TextEditingController();

  String _results = '';
  double _parseInput(String text) {
    text = text.replaceAll(',', '.'); // замінюємо кому на крапку
    return double.tryParse(text) ?? 0;
  }

  Map<String, String> calculate() {
    double H = _parseInput(_hController.text);
    double C = _parseInput(_cController.text);
    double S = _parseInput(_sController.text);
    double N = _parseInput(_nController.text);
    double O = _parseInput(_oController.text);
    double W = _parseInput(_wController.text);
    double A = _parseInput(_aController.text);

    double Kpc = 100 / (100 - W);
    double Kpg = 100 / (100 - W - A);

    double Hc = H * Kpc;
    double Cc = C * Kpc;
    double Sc = S * Kpc;
    double Nc = N * Kpc;
    double Oc = O * Kpc;
    double Ac = A * Kpc;

    double Hg = H * Kpg;
    double Cg = C * Kpg;
    double Sg = S * Kpg;
    double Ng = N * Kpg;
    double Og = O * Kpg;

    double Qph = (339 * C + 1030 * H - 108.8 * (O - S) - 25 * W);
    double Qch = (Qph / 1000 + 0.025 * W) * Kpc;
    double Qgh = (Qph / 1000 + 0.025 * W) * Kpg;

    return {
      'Kpc': Kpc.toStringAsFixed(2),
      'Kpg': Kpg.toStringAsFixed(2),
      'Hc': Hc.toStringAsFixed(2),
      'Cc': Cc.toStringAsFixed(2),
      'Sc': Sc.toStringAsFixed(2),
      'Nc': Nc.toStringAsFixed(2),
      'Oc': Oc.toStringAsFixed(2),
      'Ac': Ac.toStringAsFixed(2),
      'Hg': Hg.toStringAsFixed(2),
      'Cg': Cg.toStringAsFixed(2),
      'Sg': Sg.toStringAsFixed(2),
      'Ng': Ng.toStringAsFixed(2),
      'Og': Og.toStringAsFixed(2),
      'Qph': Qph.toStringAsFixed(2),
      'Qch': Qch.toStringAsFixed(2),
      'Qgh': Qgh.toStringAsFixed(2),
    };
  }

  void displayResults() {
    Map<String, String> results = calculate();
    setState(() {
      _results = '''
Коефіцієнт переходу від робочої до сухої маси: ${results['Kpc']}
Коефіцієнт переходу від робочої до горючої маси: ${results['Kpg']}

Hᶜ = ${results['Hc']}%
Cᶜ = ${results['Cc']}%
Sᶜ = ${results['Sc']}%
Nᶜ = ${results['Nc']}%
Oᶜ = ${results['Oc']}%
Aᶜ = ${results['Ac']}%

Hᶢ = ${results['Hg']}%
Cᶢ = ${results['Cg']}%
Sᶢ = ${results['Sg']}%
Nᶢ = ${results['Ng']}%
Oᶢ = ${results['Og']}%

Qph = ${results['Qph']} МДж/кг
Qch = ${results['Qch']} МДж/кг
Qgh = ${results['Qgh']} МДж/кг
''';
    });
  }

  void clearFields() {
    setState(() {
      _hController.clear();
      _cController.clear();
      _sController.clear();
      _nController.clear();
      _oController.clear();
      _wController.clear();
      _aController.clear();
      _results = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Калькулятор палива',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildInputCard('Hᵖ(%)', _hController),
                _buildInputCard('Cᵖ(%)', _cController),
                _buildInputCard('Sᵖ(%)', _sController),
                _buildInputCard('Nᵖ(%)', _nController),
                _buildInputCard('Oᵖ(%)', _oController),
                _buildInputCard('Wᵖ(%)', _wController),
                _buildInputCard('Aᵖ(%)', _aController),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: displayResults,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Розрахувати', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: clearFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Очистити', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_results.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Text(
                      _results,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Калькулятор палива'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildInputCard(String label, TextEditingController controller) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hController.dispose();
    _cController.dispose();
    _sController.dispose();
    _nController.dispose();
    _oController.dispose();
    _wController.dispose();
    _aController.dispose();
    super.dispose();
  }
}