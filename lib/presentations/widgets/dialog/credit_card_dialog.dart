import 'package:flutter/material.dart';

class CreditCardDialog extends StatefulWidget {
  const CreditCardDialog({super.key});

  @override
  CreditCardDialogState createState() => CreditCardDialogState();
}

class CreditCardDialogState extends State<CreditCardDialog> {
  final TextEditingController _addBalance = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _ccvController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  String _cardType = '';
  String? _errorMessage;

  void _detectCardType(String number) {
    if (number.startsWith('4')) {
      setState(() => _cardType = 'Visa');
    } else if (number.startsWith(RegExp(r'5[1-5]'))) {
      setState(() => _cardType = 'MasterCard');
    } else {
      setState(() => _cardType = 'Desconocida');
    }
  }

  bool _validateInputs() {
    setState(() => _errorMessage = null);
    if (_cardNumberController.text.length < 16) {
      setState(() => _errorMessage = 'Número de tarjeta inválido.');
      return false;
    }
    if (_ccvController.text.length < 3) {
      setState(() => _errorMessage = 'CCV inválido.');
      return false;
    }
    if (_expiryDateController.text.isEmpty) {
      setState(() => _errorMessage = 'Fecha de caducidad inválida.');
      return false;
    }
    if (_holderNameController.text.isEmpty) {
      setState(() => _errorMessage = 'Titular de la tarjeta requerido.');
      return false;
    }
    if (_cardType == 'Desconocida') {
      setState(() => _errorMessage = 'Tipo de tarjeta no reconocido.');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Tarjeta de Crédito'),
      content: SingleChildScrollView(
        // Add this to allow scrolling if content overflows
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addBalance,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número de tarjeta'),
              onChanged: _detectCardType,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número de tarjeta'),
              onChanged: _detectCardType,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  // Ensure text fields inside Row take up space properly
                  child: TextField(
                    controller: _ccvController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'CCV'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Ensure text fields inside Row take up space properly
                  child: TextField(
                    controller: _expiryDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                        labelText: 'Fecha de caducidad (MM/YY)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _holderNameController,
              decoration:
                  const InputDecoration(labelText: 'Titular de la tarjeta'),
            ),
            const SizedBox(height: 10),
            Text('Tipo: $_cardType',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_validateInputs()) {
              Navigator.pop(context);
            }
          },
          child: const Text('Añadir'),
        ),
      ],
    );
  }
}
