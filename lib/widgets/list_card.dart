import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final bool isVenda;
  final Function(int) onAddParcela;
  final Function(Map<String, dynamic>) onEdit;
  final Function(int) onDelete;
  final Function(int) onEncerrar;

  const ListCard({
    super.key,
    required this.title,
    required this.items,
    required this.isVenda,
    required this.onAddParcela,
    required this.onEdit,
    required this.onDelete,
    required this.onEncerrar,
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
            const SizedBox(height: 12),
            items.isEmpty
                ? Text(
                  'Nenhuma ${isVenda ? 'venda' : 'compra'} registrada',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final saldoDevedor =
                        item['total'] - (item['parcela_total'] ?? 0.0);
                    final isEncerrada = item['encerrada'] == 1;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              Theme.of(context).brightness == Brightness.dark
                                  ? [Colors.grey[800]!, Colors.grey[850]!]
                                  : [Colors.grey[50]!, Colors.grey[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      isVenda
                                          ? item['cliente']
                                          : item['fornecedor'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      ),
                                    ),
                                    if (isEncerrada)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Icon(
                                          Icons.check_circle,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          size: 16,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total: R\$${item['total'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  isVenda
                                      ? 'Recebido: R\$${item['parcela_total']?.toStringAsFixed(2) ?? '0.00'}'
                                      : 'Pago: R\$${item['parcela_total']?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Saldo: R\$${saldoDevedor.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color:
                                        saldoDevedor > 0
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.error
                                            : Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  'Data: ${item['data'].substring(0, 10)}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                if (item['contato'].isNotEmpty)
                                  Text(
                                    'Contato: ${item['contato']}',
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              if (!isEncerrada)
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () => onEdit(item),
                                  tooltip:
                                      'Editar ${isVenda ? 'Venda' : 'Compra'}',
                                ),
                              if (!isEncerrada && saldoDevedor == 0)
                                IconButton(
                                  icon: Icon(
                                    Icons.lock,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () => onEncerrar(item['id']),
                                  tooltip:
                                      'Encerrar ${isVenda ? 'Venda' : 'Compra'}',
                                ),
                              if (!isEncerrada)
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () => onAddParcela(item['id']),
                                  tooltip: 'Adicionar Parcela',
                                ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                onPressed: () => onDelete(item['id']),
                                tooltip:
                                    'Excluir ${isVenda ? 'Venda' : 'Compra'}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
