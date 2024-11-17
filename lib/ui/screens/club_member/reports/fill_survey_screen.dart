import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../../models/surveys/question.dart';
import '../../../../../models/surveys/survey.dart';
import '../../../../../utils/locale_helper.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/surveys/survey_response.dart';
import '../../../../providers/responses_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/button_styles.dart';
import '../../../widgets/question_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FillSurveyScreen extends StatefulWidget {
  const FillSurveyScreen({super.key, required this.survey});

  final Survey survey;

  @override
  FillSurveyState createState() => FillSurveyState();
}

class FillSurveyState extends State<FillSurveyScreen> {
  SupportedLocale _currentLocale = SupportedLocale.en;
  bool _isDescriptionExpanded = false;
  bool _isSubmitting = false;
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollProgress =
          _scrollController.offset / _scrollController.position.maxScrollExtent;
    });
  }

  void _submitResponses() async {
    final responsesProvider =
        Provider.of<ResponsesProvider>(context, listen: false);
    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    var l10n = S.of(context);

    // Validate required questions
    bool allRequiredFilled = true;
    for (var question in widget.survey.questions) {
      if (question.isRequired) {
        bool isFilled = responsesProvider.responses.containsKey(question.id) &&
            responsesProvider.responses[question.id]!.isNotEmpty;
        if (!isFilled) {
          allRequiredFilled = false;
          break;
        }
      }
    }

    if (!allRequiredFilled) {
      // Show error message and return
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.editorValidationError),
          duration: const Duration(seconds: 3),
        ),
      );
      return; // Prevent submission
    }

    // Show progress indicator on the button
    setState(() {
      _isSubmitting = true;
    });

    // Check location permission
    Position? position;
    if (await Permission.location.isGranted ||
        await Permission.location.request().isGranted) {
      try {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        print('Error getting location: $e');
      }
    }

    final responses = responsesProvider.responses.entries.map((entry) {
      return QuestionResponse(questionId: entry.key, response: entry.value);
    }).toList();

    final surveyResponse = SurveyResponse(
      coordinates: position != null
          ? LatLng(position.latitude, position.longitude)
          : null,
      language: _currentLocale.name,
      pointsCredited: widget.survey.points,
      responses: responses,
      submittedTs: Timestamp.now(),
      surveyId: widget.survey.id,
      userId: authRepository.uid,
    );

    try {
      await responsesProvider.submitSurveyResponse(
          widget.survey.points, widget.survey.name, surveyResponse, context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🎉', // Celebration emoji
                  style: TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.thankYou,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.youGotPoints(surveyResponse.pointsCredited),
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryColor, // Primary color for the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                  ),
                  child: Text(
                    l10n.ok,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.saveError}: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var preferredLocale = Localizations.localeOf(context);
    _currentLocale = getSupportedLocaleFromLocale(preferredLocale);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.survey.name.getLocalizedText(context),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildHeader(theme),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDescription(theme),
                    const SizedBox(height: 8.0),
                    _buildSurveyInfo(theme),
                    const SizedBox(height: 16),
                    ...widget.survey.questions.asMap().entries.map((entry) {
                      int index = entry.key;
                      Question question = entry.value;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQuestionNumber(index + 1, theme),
                            _buildQuestionTypeWidget(
                              context,
                              question,
                              _currentLocale,
                              theme,
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    _buildSubmitButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    var l10n = S.of(context);
    final startDate =
        widget.survey.startDateTime.toLocal().toString().split(' ')[0];
    final endDate =
        widget.survey.endDateTime.toLocal().toString().split(' ')[0];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    MdiIcons.fromString(widget.survey.icon),
                    size: 32.0,
                  ),
                ),
                Expanded(
                  child: buildLocalizedText(
                    context,
                    widget.survey.name,
                    _currentLocale,
                    theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event_available,
                    size: 20, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  startDate,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 6),
                Text(l10n.to,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.hintColor)),
                const SizedBox(width: 4),
                Icon(Icons.event_busy, size: 20, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  endDate,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            /*Row(
              children: [
                Icon(Icons.article_outlined,
                    size: 20, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  '${l10n.maxReportsPerUserPerDayShort}: ${widget.survey.maxPerUserPerDay}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                Icon(Icons.article_rounded,
                    size: 20, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  '${l10n.maxReportsPerUserTotalShort}: ${widget.survey.maxPerUserTotal}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),*/
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star_outline, size: 20, color: theme.primaryColor),
                const SizedBox(width: 16),
                Text(
                  '+${widget.survey.points} ${l10n.points}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _scrollProgress,
              backgroundColor: theme.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final style = theme.textTheme.bodyMedium;
        final descriptionText =
            widget.survey.description.getLocalizedText(context);
        final span = TextSpan(
          text: descriptionText,
          style: style,
        );
        final tp = TextPainter(
          text: span,
          maxLines: _isDescriptionExpanded ? null : 2,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        final isOverflowing = tp.didExceedMaxLines;

        return GestureDetector(
          onTap: () {
            if (isOverflowing) {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                descriptionText,
                style: style,
                maxLines: _isDescriptionExpanded ? null : 2,
                overflow: _isDescriptionExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
              if (isOverflowing)
                Text(
                  _isDescriptionExpanded ? 'less' : '... more',
                  style: style?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSurveyInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.survey.graphicsUrl.isNotEmpty &&
            widget.survey.graphicsUrl.startsWith('https://'))
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image.network(widget.survey.graphicsUrl),
          ),
      ],
    );
  }

  Widget _buildQuestionNumber(int number, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        '$number.',
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuestionTypeWidget(
    BuildContext context,
    Question question,
    SupportedLocale locale,
    ThemeData theme,
  ) {
    final responsesProvider = Provider.of<ResponsesProvider>(context);
    bool isRequired = question.isRequired;
    bool isFilled = responsesProvider.responses.containsKey(question.id) &&
        responsesProvider.responses[question.id]!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child:
                    _buildQuestionWidgetBasedOnType(question, locale, theme)),
            if (isRequired)
              Icon(
                isFilled ? Icons.check_circle : Icons.cancel,
                color: isFilled ? Colors.green : Colors.red,
              ),
          ],
        ),
        if (!isFilled && isRequired)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              S.of(context).required,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionWidgetBasedOnType(
    Question question,
    SupportedLocale locale,
    ThemeData theme,
  ) {
    switch (question.type) {
      case QuestionType.yesNo:
        return YesNoQuestion(question: question, locale: locale);
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestion(question: question, locale: locale);
      case QuestionType.text:
        return TextQuestion(question: question, locale: locale);
      case QuestionType.score:
        return ScoreQuestion(question: question, locale: locale);
      case QuestionType.numerical:
        return NumericalQuestion(question: question, locale: locale);
      case QuestionType.dateTime:
      case QuestionType.time:
      case QuestionType.date:
        return DateTimeQuestion(question: question, locale: locale);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitResponses,
        style: ButtonStyles.primaryButtonStyle,
        child: _isSubmitting
            ? const SpinKitThreeInOut(
                color: Colors.white, size: 24.0) // Show spinner
            : Text(S.of(context).submit),
      ),
    );
  }
}
