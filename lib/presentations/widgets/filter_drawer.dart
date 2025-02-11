import 'package:bidhub/presentations/widgets/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showFiltersDrawer(
    BuildContext context,
    TextEditingController searchController,
    void Function(double? minPrice, double? maxPrice, bool checkbox)
        onFilterApplied,
    int? precioMasBajo,
    int? precioMasAlto,
    bool subastasCheckbox) {
  final TextEditingController minPriceController = TextEditingController(
    text: precioMasBajo?.toString() ?? '',
  );
  final TextEditingController maxPriceController = TextEditingController(
    text: precioMasAlto?.toString() ?? '',
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      bool checkboxForm = subastasCheckbox;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.filters,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.min_price,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.max_price,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text("Ver solo las Subastas que no han acabado"),
                  value: checkboxForm,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxForm = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final double? minPrice = minPriceController.text.isNotEmpty
                        ? double.tryParse(minPriceController.text)
                        : null;
                    final double? maxPrice = maxPriceController.text.isNotEmpty
                        ? double.tryParse(maxPriceController.text)
                        : null;

                    if (minPrice != null &&
                        maxPrice != null &&
                        minPrice > maxPrice) {
                      ErrorDialog.show(
                          context,
                          AppLocalizations.of(context)!
                              .min_price_greater_than_max_price);
                    } else {
                      onFilterApplied(minPrice, maxPrice, checkboxForm);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.apply_filters,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}
