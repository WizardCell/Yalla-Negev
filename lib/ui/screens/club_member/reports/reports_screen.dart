import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yalla_negev/generated/l10n.dart';
import 'package:yalla_negev/providers/survey_provider.dart';
import 'package:yalla_negev/ui/screens/admin/surveys_manager/surveys_list_tile.dart';
import 'package:yalla_negev/ui/widgets/report_category_widget.dart';
import 'package:yalla_negev/ui/theme/app_colors.dart';
import 'package:yalla_negev/utils/assets_helper.dart';

import '../../admin/surveys_manager/surveys_list.dart';

class ViewReportsScreen extends StatefulWidget {
  const ViewReportsScreen({super.key});

  @override
  ViewReportsScreenState createState() => ViewReportsScreenState();
}

class ViewReportsScreenState extends State<ViewReportsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSurveys(); // Fetch the surveys here
    });
  }

  void _fetchSurveys() {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    surveyProvider.getAllSurveys();
  }

  Future<void> _refreshSurveys() async {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    await surveyProvider.getAllSurveys();
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  Widget _buildBody(SurveysStatus status, SurveyProvider surveyProvider) {
    switch (status) {
      case SurveysStatus.notLoaded:
      case SurveysStatus.loading:
        return _buildLoadingIndicator();
      case SurveysStatus.loaded:
        return Column(
          children: [
            _buildTopBar(context, surveyProvider),
            Expanded(
              child: _buildSurveysList(context, surveyProvider),
            ),
          ],
        );
      case SurveysStatus.error:
      default:
        return _buildErrorIndicator(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SurveyProvider>(builder: (context, surveyProvider, child) {
      return Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Hide the keyboard when tapping outside
          },
          child: _buildBody(surveyProvider.status, surveyProvider),
        ),
      );
    });
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SpinKitWanderingCubes(
        color: AppColors.primaryColor,
        size: 50.0,
      ),
    );
  }

  Widget _buildErrorIndicator(BuildContext context) {
    return Center(
      child: Text(S.of(context).error),
    );
  }

  Widget _buildTopBar(BuildContext context, SurveyProvider surveyProvider) {
    var l10n = S.of(context);
    var categories = surveyProvider.reportCategories;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.lightThemeColor
            : AppColors.darkThemeColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: l10n.search,
              hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            onChanged: (value) => surveyProvider.updateSearchQuery(value),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var category = categories[index];
                return GestureDetector(
                  onTap: () {
                    surveyProvider.updateSelectedCategories(category.id);
                  },
                  child: ReportCategoryWidget(
                    icon: MdiIcons.fromString(category.icon) ?? MdiIcons.file,
                    title: category.typeTitle,
                    isSelected: surveyProvider.selectedCategoryIds
                        .contains(category.id),
                  ),
                );
              },
            ),
          ),
          _buildFilterSummary(context, surveyProvider),
        ],
      ),
    );
  }

  Widget _buildFilterSummary(
      BuildContext context, SurveyProvider surveyProvider) {
    var l10n = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.showingSurveys(
              surveyProvider.filteredSurveys.length,
              surveyProvider.surveys.length,
            ),
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          TextButton(
            onPressed: () {
              surveyProvider.resetFilters();
              _searchController.clear();
              FocusScope.of(context).unfocus();
            },
            child: Text(l10n.resetFilters,
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveysList(
      BuildContext context, SurveyProvider surveyProvider) {
    var surveys = surveyProvider.filteredSurveys;

    if (surveys.isEmpty) {
      return _buildNoResultsFound(context);
    }

    return RefreshIndicator(
      onRefresh: _refreshSurveys,
      child: ListView.builder(
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          return SurveysListTile(
            survey: surveys[index],
            surveyListType: SurveyListType.clubMember,
          );
        },
      ),
    );
  }

  Widget _buildNoResultsFound(BuildContext context) {
    var l10n = S.of(context);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(AssetsHelper.camel1),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noQuestionnairesFound,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
