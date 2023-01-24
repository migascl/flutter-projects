import 'package:flutter/material.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/views/widgets/futureimage.dart';
import 'package:tg2/utils/dateutils.dart';

// Club's squad player tile. It displays basic player information from a contract.
// It can display either the club or player depending on the flag its given
class ContractTile extends StatelessWidget {
  const ContractTile({
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
  final VoidCallback? onTap; // Function   @override

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: dense,
      leading: FutureImage(
        image: (showClub) ? contract.club.picture! : contract.player.picture!,
        errorImageUri: (showClub)
            ? 'assets/images/placeholder-club.png'
            : 'assets/images/placeholder-player.png',
        height: (dense) ? 42 : null,
        aspectRatio: 1 / 1,
        borderRadius: (showClub) ? null : BorderRadius.circular(100),
      ),
      title: (showClub)
          ? Text(contract.club.name)
          : Text(
              "${contract.number}. ${contract.player.nickname ?? contract.player.name}"),
      subtitle: (showClub)
          ? Text(
              "Ínicio: ${DateUtilities().toYMD(contract.period.start)} | Fim: ${DateUtilities().toYMD(contract.period.end)}")
          : Text(contract.position.name),
      // Show warning icon that shows a tooltip with remaining contract duration and expiry date if contract is active
      trailing: (contract.needsRenovation && showAlert && contract.active)
          ? Tooltip(
              message:
                  'Contrato expira em ${contract.remainingTime.inDays} dias!\n(${DateUtilities().toYMD(contract.period.end)})',
              textAlign: TextAlign.center,
              child: const Icon(
                Icons.warning_rounded,
                size: 32,
                color: Colors.amber,
              ),
            )
          : null,
      onTap: () => onTap?.call(),
    );
  }
}
