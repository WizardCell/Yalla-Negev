import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/surveys/question.dart';
import '../../../../models/surveys/survey.dart';
import '../../../../providers/survey_provider.dart';
import '../../../../utils/locale_helper.dart';
import '../../../widgets/question_widgets.dart';

class SurveyPreview extends StatefulWidget {
  const SurveyPreview({super.key, required this.surveyId});

  final String surveyId;

  @override
  SurveyPreviewState createState() => SurveyPreviewState();
}

class SurveyPreviewState extends State<SurveyPreview> {
  SupportedLocale _currentLocale = SupportedLocale.en;
  bool _isDescriptionExpanded = false;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<SurveyProvider>(
      builder: (context, surveyProvider, child) {
        final survey = surveyProvider.getSurveyById(widget.surveyId);

        if (survey == null) {
          return const Center(child: Text('Survey not found.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLanguageSwitcher(),
              const SizedBox(height: 16),
              _buildHeader(theme, survey),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDescription(theme, survey),
                      const SizedBox(height: 8.0),
                      _buildSurveyInfo(theme, survey),
                      const SizedBox(height: 16),
                      ...survey.questions.asMap().entries.map((entry) {
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
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageSwitcher() {
    return Center(
      child: SegmentedButton(
        segments: const [
          ButtonSegment(value: SupportedLocale.en, label: Text('EN')),
          ButtonSegment(value: SupportedLocale.he, label: Text('עב')),
          ButtonSegment(value: SupportedLocale.ar, label: Text('عر')),
        ],
        selected: {_currentLocale},
        onSelectionChanged: (newSelection) {
          setState(() {
            _currentLocale = newSelection.first;
          });
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Survey survey) {
    var l10n = S.of(context);
    final startDate =
        survey.startDateTime?.toLocal().toString().split(' ')[0] ?? 'N/A';
    final endDate =
        survey.endDateTime?.toLocal().toString().split(' ')[0] ?? 'N/A';

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
                if (survey.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      MdiIcons.fromString(survey.icon),
                      size: 32.0,
                    ),
                  ),
                Expanded(
                  child: buildLocalizedText(
                    context,
                    survey.name,
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
            Row(
              children: [
                Icon(Icons.star_outline, size: 20, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  '${survey.points} ${l10n.points}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
              ],
            ),
            /*Row(
              children: [
                Icon(Icons.article_outlined,
                    size: 20, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  '${l10n.maxReportsPerUserTotalShort}: ${survey.maxPerUserPerDay}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                Icon(Icons.article_rounded,
                    size: 20, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  '${l10n.maxReportsPerUserTotalShort}: ${survey.maxPerUserTotal}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),*/
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

  Widget _buildDescription(ThemeData theme, Survey survey) {
    var l10n = S.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final style = theme.textTheme.bodyMedium;
        final descriptionText = survey.description.getLocalizedText(context);
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
              buildLocalizedText(
                context,
                survey.description,
                _currentLocale,
                style,
                maxLines: _isDescriptionExpanded ? null : 2,
                overflow: _isDescriptionExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
              if (isOverflowing)
                Text(
                  _isDescriptionExpanded ? l10n.less : l10n.more,
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

  Widget _buildSurveyInfo(ThemeData theme, Survey survey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (survey.graphicsUrl != null &&
            survey.graphicsUrl!.isNotEmpty &&
            survey.graphicsUrl!.startsWith("https://"))
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image.network(survey.graphicsUrl!),
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
        return DateTimeQuestion(question: question, locale: locale);
      case QuestionType.time:
        return DateTimeQuestion(question: question, locale: locale);
      case QuestionType.date:
        return DateTimeQuestion(question: question, locale: locale);
      default:
        return const SizedBox.shrink();
    }
  }
}
