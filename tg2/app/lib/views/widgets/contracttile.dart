import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/views/widgets/futureimage.dart';
import 'package:tg2/utils/dateutils.dart';

import '../../provider/contract_provider.dart';

// Club's squad player tile. It displays basic player information from a contract.
// It can display either the club or player depending on the flag its given
class ContractTile extends StatefulWidget {
  ContractTile({
    super.key,
    required this.contract,
    required this.showClub,
    this.dense = false,
    this.showAlert = false,
    this.onTap,
  });

  final Contract contract; // Widget contract data
  final bool showClub; // Flag to select between showing club or player
  final bool dense; // Flag to render in dense mode
  final bool showAlert; // Flag to show contract alerts (i.e. expiration)
  final VoidCallback? onTap; // Function to call when tapped

  @override
  State<ContractTile> createState() => _ContractTileState();
}

class _ContractTileState extends State<ContractTile> {
  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showDropDown() {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40), // Touch area
          Offset.zero & overlay.semanticBounds.size // Screen space
          ),
      items: <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: Text('Remover'),
        ),
      ],
    ).then((value) {
      switch (value) {
        case 0:
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Atenção!'),
              content: Text(
                  'Tem a certeza que pretende eliminar contrato #${widget.contract.id}? Esta operação não é reversível!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Provider.of<ContractProvider>(context, listen: false).delete(widget.contract);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Eliminar')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar')),
              ],
            ),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(),
      onLongPress: (widget.dense) ? null : _showDropDown,
      onTapDown: _storePosition,
      child: ListTile(
        dense: widget.dense,
        enabled: (widget.contract.active),
        // Expired contracts are shown as disabled
        // Either show player or club picture
        leading: FutureImage(
          image:
              (widget.showClub) ? widget.contract.club.picture! : widget.contract.player.picture!,
          errorImageUri: (widget.showClub)
              ? 'assets/images/placeholder-club.png'
              : 'assets/images/placeholder-player.png',
          height: (widget.dense) ? 42 : null,
          aspectRatio: 1 / 1,
          borderRadius: (widget.showClub) ? null : BorderRadius.circular(100),
        ),
        // If set to show player, show player shirt number on the title
        title: (widget.showClub)
            ? Text(widget.contract.club.name)
            : Text(
                '${widget.contract.number}. ${widget.contract.player.nickname ?? widget.contract.player.name}'),
        // Don't show any subtitle if set to dense, and only show player shirt number if title set to show the club
        subtitle: (widget.dense)
            ? Text(widget.contract.position.name)
            : Text(
                '${(widget.showClub) ? 'Número: ${widget.contract.number}\n' : ''}Posição: ${widget.contract.position.name}'),
        // Show warning icon that shows a tooltip with remaining contract duration and expiry date if contract is active
        trailing: (widget.showAlert && widget.contract.needsRenovation && widget.contract.active)
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
      ),
    );
  }
}
