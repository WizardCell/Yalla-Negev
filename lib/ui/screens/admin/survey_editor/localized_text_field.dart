import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../models/surveys/localized_text.dart';
import '../../../../generated/l10n.dart';
import '../../../../providers/localized_text_provider.dart';

class LocalizedTextField extends StatelessWidget {
  final String label;
  final LocalizedText initialValue;
  final ValueSetter<LocalizedText> onSaved;
  final VoidCallback? onRemove;
  final String? removeText;

  const LocalizedTextField({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.onSaved,
    this.onRemove,
    this.removeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<LocalizedText>(
      initialValue: initialValue,
      validator: (value) {
        if (value == null || !value.areAllValuesNotEmpty()) {
          return ''; // Return a non-null value to indicate an error.
        }
        return null;
      },
      builder: (FormFieldState<LocalizedText> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCompletionIndicator(field.value),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _editTexts(context, field),
                  icon: const Icon(Icons.edit),
                  label: Text(S.of(context).edit),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildLanguageRow('EN', field.value?.en),
            _buildLanguageRow('עב', field.value?.he),
            _buildLanguageRow('عر', field.value?.ar),
            if (onRemove != null && removeText != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onRemove,
                child: Text(removeText!),
              ),
            ],
          ],
        );
      },
      onSaved: (value) => onSaved(value!),
    );
  }

  Widget _buildCompletionIndicator(LocalizedText? value) {
    bool isComplete = value != null && value.areAllValuesNotEmpty();
    return Icon(
      isComplete ? Icons.check_circle : Icons.error,
      color: isComplete ? Colors.green : Colors.red,
    );
  }

  Widget _buildLanguageRow(String language, String? text) {
    return Row(
      children: [
        Text('$language:'),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text ?? '',
            style: TextStyle(
              color: (text == null || text.isEmpty) ? Colors.red : Colors.black,
              fontStyle: (text == null || text.isEmpty) ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  void _editTexts(BuildContext context, FormFieldState<LocalizedText> field) {
    showDialog(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => LocalizedTextProvider(field.value!),
          child: Consumer<LocalizedTextProvider>(
            builder: (context, provider, child) {
              var l10n = S.of(context);
              return AlertDialog(
                title: Text('${l10n.edit} $label'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEditableTextField(context, 'EN', provider.enController, 'en', provider, 'EN', TextDirection.ltr),
                      _buildEditableTextField(context, 'עב', provider.heController, 'he', provider, 'HE', TextDirection.rtl),
                      _buildEditableTextField(context, 'عر', provider.arController, 'ar', provider, 'AR', TextDirection.rtl),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(l10n.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (provider.enController.text.isNotEmpty &&
                          provider.heController.text.isNotEmpty &&
                          provider.arController.text.isNotEmpty) {
                        provider.saveText();
                        field.didChange(provider.localizedText);
                        onSaved(provider.localizedText); // Trigger rebuild in parent
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.editorValidationError)),
                        );
                      }
                    },
                    child: Text(l10n.save),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEditableTextField(
      BuildContext context,
      String language,
      TextEditingController controller,
      String sourceLang,
      LocalizedTextProvider provider,
      String fieldIdentifier,
      TextDirection textDirection,
      ) {
    var l10n = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          textDirection: textDirection,
          decoration: InputDecoration(
            labelText: language,
            suffixIcon: provider.isTranslating && provider.activeField == fieldIdentifier
                ? SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
            )
                : (provider.activeField == fieldIdentifier && controller.text.isNotEmpty)
                ? IconButton(
              icon: const Icon(Icons.translate),
              onPressed: provider.isTranslating
                  ? null
                  : () async {
                provider.setActiveField(fieldIdentifier);
                await provider.translate(sourceLang, fieldIdentifier);
              },
            )
                : null,
          ),
          onChanged: (value) {
            provider.setActiveField(fieldIdentifier);
          },
          enabled: !provider.isTranslating,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
