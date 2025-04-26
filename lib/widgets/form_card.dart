import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  final String title;
  final TextEditingController totalController;
  final TextEditingController parcelaController;
  final TextEditingController clienteController;
  final TextEditingController contatoController;
  final VoidCallback onSubmit;
  final String clienteLabel;

  const FormCard({
    super.key,
    required this.title,
    required this.totalController,
    required this.parcelaController,
    required this.clienteController,
    required this.contatoController,
    required this.onSubmit,
    required this.clienteLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                Theme.of(context).brightness == Brightness.dark
                    ? [Colors.grey[850]!, Colors.grey[900]!]
                    : [Colors.white, Colors.grey[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: totalController,
              decoration: const InputDecoration(
                labelText: 'Valor Total (R\$)*',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: parcelaController,
              decoration: const InputDecoration(
                labelText: 'Parcela Inicial (R\$)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: clienteController,
              decoration: InputDecoration(labelText: 'Pessoa'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contatoController,
              decoration: const InputDecoration(
                labelText: 'Contato (Opcional)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text('Registrar ${title.split(' ').last}'),
            ),
          ],
        ),
      ),
    );
  }
}
