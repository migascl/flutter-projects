import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/views/widgets/futureimage.dart';
import 'package:tg2/provider/contract_provider.dart';

// Club's squad player tile. It displays basic player information from a contract.
// It can display either the club or player depending on the flag its given
class ContractTile extends StatefulWidget {
  const ContractTile({super.key, required this.contract, required this.showClub, this.onTap, this.onDelete});

  final Contract contract; // Widget contract data
  final bool showClub; // Flag to select between showing club or player
  final VoidCallback? onTap; // Function to call when tapped
  final VoidCallback? onDelete; // Function to call when deleted

  @override
  State<ContractTile> createState() => _ContractTileState();
}

class _ContractTileState extends State<ContractTile> {
  var tapPosition;

  bool isLoading = false;

  void storePosition(TapDownDetails details) {
    tapPosition = details.globalPosition;
  }

  void showDropDown() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          tapPosition & const Size(40, 40), // Touch area
          Offset.zero & overlay.semanticBounds.size // Screen space
          ),
      items: <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: Text('Remover'),
        ),
      ],
    ).then(
      (value) {
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
                    onPressed: () async {
                      await Provider.of<ContractProvider>(context, listen: false).delete(widget.contract);
                      widget.onDelete?.call();
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
              ),
            );
            break;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: storePosition,
      child: ListTile(
        onTap: widget.onTap?.call,
        onLongPress: showDropDown,
        //enabled: (widget.contract.active),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        // Either show player or club picture
        leading: FutureImage(
          image: (widget.showClub) ? widget.contract.club.logo! : widget.contract.player.picture!,
          aspectRatio: 1 / 1,
          borderRadius: (widget.showClub) ? null : BorderRadius.circular(100),
        ),
        // If set to show player, show player shirt number on the title
        title: (widget.showClub)
            ? Text(widget.contract.club.nicknameFallback)
            : Text('${widget.contract.shirtNumber}. ${widget.contract.player.nickname ?? widget.contract.player.name}'),
        // Don't show any subtitle if set to dense, and only show player shirt number if title set to show the club
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Posição: ${widget.contract.position.name}'),
            Text(
                'Contrato: ${DateFormat.yM('pt_PT').format(widget.contract.period.start)} - ${DateFormat.yM('pt_PT').format(widget.contract.period.end)}'),
          ],
        ),
        // Show warning icon that shows a tooltip with remaining contract duration and expiry date if contract is active
        trailing: (widget.contract.needsRenovation && widget.contract.active)
            ? Tooltip(
                message:
                    'Contrato expira em ${widget.contract.remainingTime.inDays} dias!\n(${DateFormat.yMd('pt_PT').format(widget.contract.period.end)})',
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
