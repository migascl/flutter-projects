import 'package:flutter/material.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/views/widgets/futureimage.dart';

// This widgets shows a contract's information
class ContractView extends StatelessWidget {
  const ContractView({super.key, required this.contract});

  final Contract contract;

  @override
  Widget build(BuildContext context) {
    print("Contract/V: Building...");
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 8),
          child: Divider(
            thickness: 4,
            color: Colors.white,
            indent: MediaQuery.of(context).size.width * 0.45,
            endIndent: MediaQuery.of(context).size.width * 0.45,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            color: Theme.of(context).canvasColor,
          ),
          child: Column(
            children: [
              Text(
                "Contrato nº${contract.id}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Contratante",
                            style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(height: 16),
                        FutureImage(
                          image: contract.club.picture!,
                          errorImageUri: 'assets/images/placeholder-club.png',
                          height: 64,
                          aspectRatio: 1 / 1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          contract.club.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Contratado",
                            style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(height: 16),
                        FutureImage(
                          image: contract.player.picture!,
                          errorImageUri: 'assets/images/placeholder-player.png',
                          height: 64,
                          aspectRatio: 1 / 1,
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          contract.player.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Card(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text("Posição",
                                style: Theme.of(context).textTheme.subtitle1),
                            const SizedBox(height: 8),
                            Text(contract.position.name,
                                style: Theme.of(context).textTheme.headline6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text("Número",
                                style: Theme.of(context).textTheme.subtitle1),
                            const SizedBox(height: 8),
                            Text("${contract.number}",
                                style: Theme.of(context).textTheme.headline6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Prazo",
                          style: Theme.of(context).textTheme.subtitle1),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(DateUtilities().toYMD(contract.period.start),
                              style: Theme.of(context).textTheme.headline6),
                          Text("a",
                              style: Theme.of(context).textTheme.subtitle1),
                          Text(DateUtilities().toYMD(contract.period.end),
                              style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("(${contract.remainingTime.inDays} dias restantes)",
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
