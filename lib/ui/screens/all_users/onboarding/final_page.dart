import 'package:flutter/material.dart';
import 'package:yalla_negev/utils/assets_helper.dart';
import '../../../../generated/l10n.dart';

class FinalPage extends StatelessWidget {
  final S l10n;
  bool doNotShowAgain = false;
  final ValueChanged<bool?>? onCheckboxChanged;

  FinalPage({
    super.key,
    required this.l10n,
    required this.doNotShowAgain,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.youAreAllSet, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage(AssetsHelper.camel1),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: doNotShowAgain,
                onChanged: onCheckboxChanged,
              ),
              Text(l10n.doNotShowAgain),
            ],
          ),
        ],
      ),
    );
  }
}
