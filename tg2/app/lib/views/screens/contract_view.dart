import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/views/widgets/futureimage.dart';

import '../widgets/header.dart';

// This widgets shows a contract's information
class ContractView extends StatelessWidget {
  const ContractView({super.key, required this.contract});

  final Contract contract; // Default Widget data

  @override
  Widget build(BuildContext context) {
    print('Contract/V: Building...');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: HeaderWidget(
          headerText: 'Contrato ${contract.id}',
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Contratante', style: Theme.of(context).textTheme.subtitle2),
                              const SizedBox(height: 16),
                              FutureImage(
                                image: contract.club.picture!,
                                errorImageUri: 'assets/images/placeholder-club.png',
                                height: 64,
                                aspectRatio: 1 / 1,
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  contract.club.name,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Contratado', style: Theme.of(context).textTheme.subtitle2),
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
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  contract.player.name,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(height: 64, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Posição', style: Theme.of(context).textTheme.subtitle1),
                            const SizedBox(height: 8),
                            Text(contract.position.name, style: Theme.of(context).textTheme.headline6),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Número',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${contract.number}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      Text(
                        'Duração do Contrato',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            DateFormat.yMd('pt_PT').format(contract.period.start),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text('a', style: Theme.of(context).textTheme.subtitle1),
                          Text(
                            DateFormat.yMd('pt_PT').format(contract.period.end),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Displays contract state, if active, inactive or pending start
                      // If active and close to expiration, display remaining days
                      Text(
                          'Estado: ${(contract.active) ? 'Ativo ${(contract.needsRenovation) ? '(${contract.remainingTime.inDays} dias restantes)' : ''}' : (contract.remainingTime.inDays < 0) ? 'Expirado' : 'Aguardando ínicio efetivo'}',
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    /*
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            color: Theme.of(context).canvasColor,
          ),
          child: Column(
            children: [
              Text(
                'Contrato ${contract.id}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Contratante', style: Theme.of(context).textTheme.subtitle1),
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
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Contratado', style: Theme.of(context).textTheme.subtitle1),
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
                  ),
                ),
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
                            Text('Posição', style: Theme.of(context).textTheme.subtitle1),
                            const Divider(height: 8),
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
                            Text(
                              'Número',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${contract.number}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
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
                      Text(
                        'Duração do Contrato',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            DateUtilities().toYMD(contract.period.start),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text('a', style: Theme.of(context).textTheme.subtitle1),
                          Text(
                            DateUtilities().toYMD(contract.period.end),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Displays contract state, if active, inactive or pending start
                      // If active and close to expiration, display remaining days
                      Text(
                          'Estado: ${(contract.active) ? 'Ativo ${(contract.needsRenovation) ? '(${contract.remainingTime.inDays} dias restantes)' : ''}' : (contract.remainingTime.inDays < 0) ? 'Expirado' : 'Aguardando ínicio efetivo'}',
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

     */
  }
}
