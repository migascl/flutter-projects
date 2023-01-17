import 'package:flutter/material.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/views/widgets/futureimage.dart';

import '../../utils/dateutils.dart';

// Club's squad player tile. It displays basic player information from a contract.
class ContractTile extends StatefulWidget {
  const ContractTile({
    super.key,
    required this.contract,
    required this.showClub,
    this.dense = false,
    this.showAlert = false,
    this.onTap,
  });

  final Contract contract;
  final bool showClub;
  final bool dense;
  final bool showAlert; // Flag to show contract alerts (i.e. expiration)
  final VoidCallback? onTap;

  @override
  State<ContractTile> createState() => _ContractTileState();
}

class _ContractTileState extends State<ContractTile> {
  var _count = 0;
  var _tapPosition;

  void _showCustomMenu() {}

  void _storePosition(TapDownDetails details) {
    setState(() => _tapPosition = details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _storePosition,
      child: ListTile(
        dense: widget.dense,
        leading: FutureImage(
          image: (widget.showClub)
              ? widget.contract.club.picture!
              : widget.contract.player.picture!,
          errorImageUri: (widget.showClub)
              ? 'assets/images/placeholder-club.png'
              : 'assets/images/placeholder-player.png',
          height: (widget.dense) ? 32 : 48,
          aspectRatio: 1 / 1,
        ),
        title: (widget.showClub)
            ? Text(widget.contract.club.name)
            : Text(
                "${widget.contract.number}. ${widget.contract.player.nickname ?? widget.contract.player.name}"),
        subtitle: (widget.showClub)
            ? Text(
                "Ínicio: ${DateUtilities().toYMD(widget.contract.period.start)} | Fim: ${DateUtilities().toYMD(widget.contract.period.end)}")
            : Text(widget.contract.position.name),
        // Show warning icon that shows a tooltip with remaining contract duration and expiry date if contract is active
        trailing: (widget.contract.needsRenovation &&
                widget.showAlert &&
                widget.contract.active)
            ? Tooltip(
                message:
                    'Contrato expira em ${widget.contract.remainingTime.inDays} dias!\n(${DateUtilities().toYMD(widget.contract.period.end)})',
                textAlign: TextAlign.center,
                child: const Icon(
                  Icons.warning_rounded,
                  size: 32,
                  color: Colors.amber,
                ),
              )
            : null,
        onTap: () => widget.onTap?.call(),
        onLongPress: () {
          final RenderBox overlay =
              Overlay.of(context)?.context.findRenderObject() as RenderBox;
          showMenu(
            context: context,
            position: RelativeRect.fromRect(
              _tapPosition & const Size(40, 40),
              Offset.zero & overlay.size,
            ),
            items: <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Editar'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Remover'),
              ),
            ],
          ).then((value) {
            if (value == null) return;
            if (value == 0) {
              // TODO EDIT CONTRACT
            }
            if (value == 1) {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Atenção!'),
                        content: Text(
                            "Tem a certeza que pretende eliminar contrato ${widget.contract.id}? Esta operação não é reversível!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // TODO REMOVE CONTRACT
                              Navigator.of(context).pop();
                            },
                            child: const Text('Eliminar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ));
            }
          });
        },
      ),
    );
  }
}
