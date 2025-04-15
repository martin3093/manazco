import 'package:flutter/material.dart';
import 'package:manazco/helpers/style_helper.dart';

class QuoteCard extends StatelessWidget {
  final String companyName;
  final String stockPrice;
  final String changePercentage;
  final String formattedDate;
  final bool isPositiveChange;

  const QuoteCard({
    super.key,
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
    required this.formattedDate,
    required this.isPositiveChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(companyName, style: StyleHelper.companyNameStyle),
            const SizedBox(height: 8),
            Text('Precio: $stockPrice', style: StyleHelper.stockPriceStyle),
            Text(
              'Cambio: $changePercentage',
              style:
                  isPositiveChange
                      ? StyleHelper.changePositiveStyle
                      : StyleHelper.changeNegativeStyle,
            ),
            Text(
              'Actualizado: $formattedDate',
              style: StyleHelper.lastUpdatedStyle,
            ),
          ],
        ),
      ),
    );
  }
}
