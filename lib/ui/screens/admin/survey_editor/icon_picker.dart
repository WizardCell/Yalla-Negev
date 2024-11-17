import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:yalla_negev/generated/l10n.dart';  // Assuming you're using localization

class IconPicker extends StatelessWidget {
  final String? selectedIcon;
  final ValueSetter<String> onIconSelected;

  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  static final List<Map<String, IconData>> _icons = [
    {'clipboard-text-outline': MdiIcons.clipboardTextOutline},
    {'clipboard-check-outline': MdiIcons.clipboardCheckOutline},
    {'chart-bar': MdiIcons.chartBar},
    {'bus': MdiIcons.bus},
    {'bus-side': MdiIcons.busSide},
    {'bus-stop': MdiIcons.busStop},
    {'car': MdiIcons.car},
    {'train': MdiIcons.train},
    {'school': MdiIcons.school},
    {'book-open-outline': MdiIcons.bookOpenOutline},
    {'shield-outline': MdiIcons.shieldOutline},
    {'alert-outline': MdiIcons.alertOutline},
    {'police-badge-outline': MdiIcons.policeBadgeOutline},
    {'home-outline': MdiIcons.homeOutline},
    {'bridge': MdiIcons.bridge},
    {'office-building-outline': MdiIcons.officeBuildingOutline},
    {'road-variant': MdiIcons.roadVariant},
    {'traffic-light': MdiIcons.trafficLight},
    {'sign-caution': MdiIcons.signCaution},
    {'hospital-box-outline': MdiIcons.hospitalBoxOutline},
    {'stethoscope': MdiIcons.stethoscope},
    {'medical-bag': MdiIcons.medicalBag},
    {'gavel': MdiIcons.gavel},
    {'bank': MdiIcons.bank},
    {'briefcase-outline': MdiIcons.briefcaseOutline},
    {'account-group-outline': MdiIcons.accountGroupOutline},
    {'scale-balance': MdiIcons.scaleBalance},
    {'account-cash-outline': MdiIcons.accountCashOutline},
  ];

  @override
  Widget build(BuildContext context) {
    var l10n = S.of(context);  // Localized strings

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${l10n.pickIcon}: ", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => _showIconPickerDialog(context),
              icon: selectedIcon != null
                  ? Icon(MdiIcons.fromString(selectedIcon!), size: 36)
                  : const Icon(Icons.add, size: 36),
              tooltip: l10n.icon,
            ),
          ],
        ),
      ),
    );
  }

  void _showIconPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).pickIcon),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                final iconEntry = _icons[index];
                final iconKey = iconEntry.keys.first;
                final iconData = iconEntry[iconKey];

                return GestureDetector(
                  onTap: () {
                    onIconSelected(iconKey);
                    Navigator.of(context).pop();
                  },
                  child: Icon(iconData, size: 32.0),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
