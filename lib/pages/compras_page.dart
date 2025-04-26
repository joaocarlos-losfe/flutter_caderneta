import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../widgets/form_card.dart';
import '../widgets/list_card.dart';
import '../widgets/dialogs.dart';

class ComprasPage extends StatefulWidget {
  const ComprasPage({super.key});

  @override
  ComprasPageState createState() => ComprasPageState();
}

class ComprasPageState extends State<ComprasPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _parcelaController = TextEditingController();
  final TextEditingController _fornecedorController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  List<Map<String, dynamic>> _compras = [];

  @override
  void initState() {
    super.initState();
    _loadCompras();
  }

  Future<void> _loadCompras() async {
    final compras = await _dbHelper.getCompras();
    setState(() {
      _compras = compras;
    });
  }

  Future<void> _addCompra(BuildContext context) async {
    if (_totalController.text.isEmpty || _fornecedorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preencha os campos obrigatórios'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final compra = {
      'total': double.parse(_totalController.text),
      'fornecedor': _fornecedorController.text,
      'contato': _contatoController.text,
      'data': DateTime.now().toIso8601String(),
      'encerrada': 0,
    };

    final compraId = await _dbHelper.insertCompra(compra);
    if (_parcelaController.text.isNotEmpty) {
      await _dbHelper.insertParcelaCompra({
        'compra_id': compraId,
        'valor': double.parse(_parcelaController.text),
        'data': DateTime.now().toIso8601String(),
      });
    }

    _clearFields();
    await _loadCompras();
  }

  void _clearFields() {
    _totalController.clear();
    _parcelaController.clear();
    _fornecedorController.clear();
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
              title: 'Nova Compra',
              totalController: _totalController,
              parcelaController: _parcelaController,
              clienteController: _fornecedorController,
              contatoController: _contatoController,
              onSubmit: () => _addCompra(context),
              clienteLabel: 'Fornecedor',
            ),
            const SizedBox(height: 24),
            ListCard(
              title: 'Compras Registradas',
              items: _compras,
              isVenda: false,
              onAddParcela:
                  (id) => showAddParcelaDialog(
                    context,
                    id,
                    _dbHelper,
                    _loadCompras,
                  ),
              onEdit:
                  (item) => showEditDialog(
                    context,
                    item,
                    false,
                    _dbHelper,
                    _loadCompras,
                  ),
              onDelete:
                  (id) => showDeleteDialog(
                    context,
                    id,
                    false,
                    _dbHelper,
                    _loadCompras,
                  ),
              onEncerrar:
                  (id) => _dbHelper.encerrarCompra(id).then((_) {
                    _loadCompras();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Compra encerrada com sucesso'),
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
