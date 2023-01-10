import 'package:flutter/material.dart';
import '../../models/contract_model.dart';
import 'club/club_view.dart';

// TODO STYLING
// This widgets shows a contract's information
class ContractView extends StatelessWidget {
  const ContractView({super.key, required this.contract});

  final Contract contract;

  @override
  Widget build(BuildContext context) {
    print("Contract/V: Building...");
    return Column(
      children: [
        Text(contract.player.name),
        Text(contract.club.name),
        Text(contract.period.toString()),
      ],
    );
  }
}