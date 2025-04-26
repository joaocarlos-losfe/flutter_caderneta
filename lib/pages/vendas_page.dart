import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../widgets/form_card.dart';
import '../widgets/list_card.dart';
import '../widgets/dialogs.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({super.key});

  @override
  VendasPageState createState() => VendasPageState();
}

class VendasPageState extends State<VendasPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _parcelaController = TextEditingController();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  List<Map<String, dynamic>> _vendas = [];

  @override
  void initState() {
    super.initState();
    _loadVendas();
  }

  Future<void> _loadVendas() async {
    final vendas = await _dbHelper.getVendas();
    setState(() {
      _vendas = vendas;
    });
  }

  Future<void> _addVenda(BuildContext context) async {
    if (_totalController.text.isEmpty || _clienteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preencha os campos obrigatórios'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final venda = {
      'total': double.parse(_totalController.text),
      'cliente': _clienteController.text,
      'contato': _contatoController.text,
      'data': DateTime.now().toIso8601String(),
      'encerrada': 0,
    };

    final vendaId = await _dbHelper.insertVenda(venda);
    if (_parcelaController.text.isNotEmpty) {
      await _dbHelper.insertParcela({
        'venda_id': vendaId,
        'valor': double.parse(_parcelaController.text),
        'data': DateTime.now().toIso8601String(),
      });
    }

    _clearFields();
    await _loadVendas();
  }

  void _clearFields() {
    _totalController.clear();
    _parcelaController.clear();
    _clienteController.clear();
    _contatoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormCard(
              title: 'Nova Venda',
              totalController: _totalController,
              parcelaController: _parcelaController,
              clienteController: _clienteController,
              contatoController: _contatoController,
              onSubmit: () => _addVenda(context),
              clienteLabel: 'Cliente',
            ),
            const SizedBox(height: 24),
            ListCard(
              title: 'Vendas Registradas',
              items: _vendas,
              isVenda: true,
              onAddParcela:
                  (id) =>
                      showAddParcelaDialog(context, id, _dbHelper, _loadVendas),
              onEdit:
                  (item) => showEditDialog(
                    context,
                    item,
                    true,
                    _dbHelper,
                    _loadVendas,
                  ),
              onDelete:
                  (id) => showDeleteDialog(
                    context,
                    id,
                    true,
                    _dbHelper,
                    _loadVendas,
                  ),
              onEncerrar:
                  (id) => _dbHelper.encerrarVenda(id).then((_) {
                    _loadVendas();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Venda encerrada com sucesso'),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
