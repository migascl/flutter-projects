import 'package:flutter/material.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/views/widgets/futureimage.dart';

// Club's squad player tile. It displays basic player information from a contract.
class SquadTile extends StatelessWidget {
  const SquadTile(
      {super.key,
      required this.contract,
      this.dense = false,
      this.showAlert = false,
      this.onTap});

  final Contract contract;
  final bool dense;
  final bool showAlert; // Flag to show contract alerts (i.e. expiration)
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        dense: dense,
        leading: FutureImage(
          image: contract.player.picture!,
          errorImageUri: 'assets/images/placeholder-player.png',
          height: (dense) ? 32 : 48,
          aspectRatio: 1 / 1,
        ),
        title: Text(
            "${contract.number}. ${contract.player.nickname ?? contract.player.name}"),
        subtitle: Text(contract.position.name),
        // Show warning icon that shows a tooltip with remaining contract duration and expiry date
        trailing: (contract.needsRenovation && showAlert)
            ? Tooltip(
                message:
                    'Contrato expira em ${contract.remainingTime.inDays} dias!\n(${contract.period.end.toLocal()})',
                textAlign: TextAlign.center,
                child: const Icon(
                  Icons.warning_rounded,
                  size: 32,
                  color: Colors.amber,
                ),
              )
            : null,
        onTap: () => onTap?.call());
  }
}
