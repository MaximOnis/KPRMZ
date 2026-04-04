import 'package:flutter/material.dart';

class OilCalculatorScreen extends StatefulWidget {
  const OilCalculatorScreen({super.key});

  @override
  State<OilCalculatorScreen> createState() => _OilCalculatorScreenState();
}

class _OilCalculatorScreenState extends State<OilCalculatorScreen> {
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _sController = TextEditingController();
  final TextEditingController _vController = TextEditingController();
  final TextEditingController _oController = TextEditingController();
  final TextEditingController _wController = TextEditingController();
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _qController = TextEditingController();

  String _results = '';

  double _parseInput(String text) {
    text = text.replaceAll(',', '.'); 
    return double.tryParse(text) ?? 0;
  }

  Map<String, String> calculate() {
    double H = _parseInput(_hController.text);
    double C = _parseInput(_cController.text);
    double S = _parseInput(_sController.text);
    double V = _parseInput(_vController.text);
    double O = _parseInput(_oController.text);
    double W = _parseInput(_wController.text);
    double A = _parseInput(_aController.text);
    double Q = _parseInput(_qController.text);

    double Hp = H * (100 - W - A) / 100;
    double Cp = C * (100 - W - A) / 100;
    double Sp = S * (100 - W - A) / 100;
    double Op = O * (100 - W - A) / 100;
    double Ap = A * (100 - W) / 100;
    double Vp = V * (100 - W) / 100;

    double Qp = Q * (100 - W - A) / 100 - 0.025 * W;

    return {
      'Hp': Hp.toStringAsFixed(2),
      'Cp': Cp.toStringAsFixed(2),
      'Sp': Sp.toStringAsFixed(2),
      'Vp': Vp.toStringAsFixed(2),
      'Op': Op.toStringAsFixed(2),
      'Ap': Ap.toStringAsFixed(2),
      'Wp': W.toStringAsFixed(2),
      'Qp': Qp.toStringAsFixed(2),
    };
  }

  void displayResults() {
    Map<String, String> results = calculate();
    setState(() {
      _results = '''
Hᵖ = ${results['Hp']}%
Cᵖ = ${results['Cp']}%
Sᵖ = ${results['Sp']}%
Vᵖ = ${results['Vp']} мг/кг
Oᵖ = ${results['Op']}%
Aᵖ = ${results['Ap']}%
Wᵖ = ${results['Wp']}%

Qp = ${results['Qp']} МДж/кг
''';
    });
  }

  void clearFields() {
    setState(() {
      _hController.clear();
      _cController.clear();
      _sController.clear();
      _vController.clear();
      _oController.clear();
      _wController.clear();
      _aController.clear();
      _qController.clear();
      _results = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade100, Colors.white],
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
                  'Калькулятор мазуту',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildInputCard('Hᶢ(%)', _hController),
                _buildInputCard('Cᶢ(%)', _cController),
                _buildInputCard('Sᶢ(%)', _sController),
                _buildInputCard('Oᶢ(%)', _oController),
                _buildInputCard('Vᶢ(мг/кг)', _vController),
                _buildInputCard('Wᶢ(%)', _wController),
                _buildInputCard('Aᶢ(%)', _aController),
                _buildInputCard('Qᶢ(МДж/кг)', _qController),
                const SizedBox(height: 20),
                Row(
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
                        child:
                        const Text('Розрахувати', style: TextStyle(fontSize: 16)),
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
                        child:
                        const Text('Очистити', style: TextStyle(fontSize: 16)),
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
        title: const Text('Калькулятор мазуту'),
        backgroundColor: Colors.brown,
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
    _vController.dispose();
    _oController.dispose();
    _wController.dispose();
    _aController.dispose();
    _qController.dispose();
    super.dispose();
  }
}