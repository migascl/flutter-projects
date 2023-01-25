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
  final VoidCallback? onTap;

  @override
  State<ContractTile> createState() => _ContractTileState();
}

class _ContractTileState extends State<ContractTile> {
  Widget? _trailing;

  late var overlay;

  @override
  Widget build(BuildContext context) {
    if (widget.showAlert) {
      if (!widget.contract.active) {
        _trailing = Tooltip(
          message:
              'Expirado à ${DateTime.now().difference(widget.contract.period.end).inDays} dias!',
          textAlign: TextAlign.center,
          child: const Icon(
            Icons.cancel_rounded,
            size: 32,
            color: Colors.red,
          ),
        );
      } else if (widget.contract.needsRenovation) {
        _trailing = Tooltip(
          message:
              'Contrato expira em ${widget.contract.remainingTime.inDays} dias!\n(${DateUtilities().toYMD(widget.contract.period.end)})',
          textAlign: TextAlign.center,
          child: const Icon(
            Icons.warning_rounded,
            size: 32,
            color: Colors.amber,
          ),
        );
      }
    }
    return ListTile(
        dense: widget.dense,
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
        title: (widget.showClub)
            ? Text(widget.contract.club.name)
            : Text(
                "${widget.contract.number}. ${widget.contract.player.nickname ?? widget.contract.player.name}"),
        subtitle: (widget.showClub)
            ? Text(
                "Ínicio: ${DateUtilities().toYMD(widget.contract.period.start)} | Fim: ${DateUtilities().toYMD(widget.contract.period.end)}")
            : Text(widget.contract.position.name),
        // Show warning icon that shows a tooltip with remaining contract duration and expiry date if contract is active
        trailing: _trailing,
        onTap: () => widget.onTap?.call(),
        onLongPress: (widget.dense)
            ? null
            : () {
                overlay = Overlay.of(context)?.context.findRenderObject();
                showMenu(
                  context: context,
                  position: RelativeRect.fromRect(
                      TapDownDetails().globalPosition & const Size(40, 40),
                      // smaller rect, the touch area
                      Offset.zero & overlay.size // Bigger rect, the entire screen
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
                              "Tem a certeza que pretende eliminar exame ${widget.contract.id}? Esta operação não é reversível!"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Provider.of<ContractProvider>(context, listen: false)
                                      .delete(widget.contract);
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
        /*
      onLongPress: () => (widget.dense)
          ? print("yuh")
          : PopupMenuButton(
              onSelected: (int value) {

              // Exam tile popup menu options
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Remover'),
                ),
              ],
            ),

       */
        );
  }
}
