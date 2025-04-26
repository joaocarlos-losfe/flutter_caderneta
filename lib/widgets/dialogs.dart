import 'package:flutter/material.dart';
import '../services/database_helper.dart';

Future<void> showAddParcelaDialog(
  BuildContext context,
  int id,
  DatabaseHelper dbHelper,
  VoidCallback onUpdate,
) async {
  final lastParcela = await (dbHelper.getLastParcelaVenda(id));
  final TextEditingController parcelaController = TextEditingController(
    text: lastParcela != null ? lastParcela['valor'].toString() : '',
  );
  if (context.mounted) {
    await showDialog(
      context: context,
      builder:
          (dialogContext) => Dialog(
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adicionar Parcela',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: parcelaController,
                    decoration: InputDecoration(
                      labelText: 'Valor da Parcela (R\$)',
                      hintText:
                          lastParcela != null
                              ? 'Última: R\$${lastParcela['valor'].toStringAsFixed(2)}'
                              : null,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (parcelaController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Preencha o valor da parcela',
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                            return;
                          }
                          final parcela = {
                            'valor': double.parse(parcelaController.text),
                            'data': DateTime.now().toIso8601String(),
                          };
                          if (id < 0) {
                            parcela['compra_id'] = -id;
                            await dbHelper.insertParcelaCompra(parcela);
                          } else {
                            parcela['venda_id'] = id;
                            await dbHelper.insertParcela(parcela);
                          }
                          if (context.mounted) {
                            Navigator.pop(dialogContext);
                          }
                          onUpdate();
                        },
                        child: const Text('Adicionar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

Future<void> showEditDialog(
  BuildContext context,
  Map<String, dynamic> item,
  bool isVenda,
  DatabaseHelper dbHelper,
  VoidCallback onUpdate,
) async {
  final TextEditingController totalController = TextEditingController(
    text: item['total'].toString(),
  );
  final TextEditingController clienteController = TextEditingController(
    text: isVenda ? item['cliente'] : item['fornecedor'],
  );
  final TextEditingController contatoController = TextEditingController(
    text: item['contato'],
  );

  await showDialog(
    context: context,
    builder:
        (dialogContext) => Dialog(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isVenda ? 'Editar Venda' : 'Editar Compra',
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
                  controller: clienteController,
                  decoration: InputDecoration(
                    labelText: isVenda ? 'Cliente*' : 'Fornecedor*',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contatoController,
                  decoration: const InputDecoration(
                    labelText: 'Contato (Opcional)',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (totalController.text.isEmpty ||
                            clienteController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Preencha os campos obrigatórios',
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                          return;
                        }
                        final updatedItem = {
                          'total': double.parse(totalController.text),
                          isVenda ? 'cliente' : 'fornecedor':
                              clienteController.text,
                          'contato': contatoController.text,
                          'data': item['data'],
                          'encerrada': item['encerrada'],
                        };
                        if (isVenda) {
                          await dbHelper.updateVenda(item['id'], updatedItem);
                        } else {
                          await dbHelper.updateCompra(item['id'], updatedItem);
                        }
                        if (context.mounted) {
                          Navigator.pop(dialogContext);
                        }
                        onUpdate();
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
  );
}

Future<void> showDeleteDialog(
  BuildContext context,
  int id,
  bool isVenda,
  DatabaseHelper dbHelper,
  VoidCallback onUpdate,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (dialogContext) => Dialog(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirmar Exclusão',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Deseja excluir esta ${isVenda ? 'venda' : 'compra'}? Esta ação não pode be desfeita.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text('Excluir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
  );

  if (confirmed == true) {
    if (isVenda) {
      await dbHelper.deleteVenda(id);
    } else {
      await dbHelper.deleteCompra(id);
    }
    onUpdate();
  }
}
