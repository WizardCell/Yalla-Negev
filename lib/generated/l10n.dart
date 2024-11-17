// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
 
      return instance;
    });
  } 

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to YallaNegev!`
  String get welcome {
    return Intl.message(
      'Welcome to YallaNegev!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Yalla Negev`
  String get yallaNegev {
    return Intl.message(
      'Yalla Negev',
      name: 'yallaNegev',
      desc: '',
      args: [],
    );
  }

  /// `A platform that allows you to share your opinion and influence the life of your community`
  String get welcomeDescription {
    return Intl.message(
      'A platform that allows you to share your opinion and influence the life of your community',
      name: 'welcomeDescription',
      desc: '',
      args: [],
    );
  }

  /// `How it works`
  String get getStarted {
    return Intl.message(
      'How it works',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Answer surveys, earn points, and get rewards`
  String get getStartedDescription {
    return Intl.message(
      'Answer surveys, earn points, and get rewards',
      name: 'getStartedDescription',
      desc: '',
      args: [],
    );
  }

  /// `Allow Notifications`
  String get allowNotifications {
    return Intl.message(
      'Allow Notifications',
      name: 'allowNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Grant Permission`
  String get grantPermission {
    return Intl.message(
      'Grant Permission',
      name: 'grantPermission',
      desc: '',
      args: [],
    );
  }

  /// `Permission Granted`
  String get permissionGranted {
    return Intl.message(
      'Permission Granted',
      name: 'permissionGranted',
      desc: '',
      args: [],
    );
  }

  /// `We will send you only important notifications to help you stay updated.`
  String get notificationPermissionDescription {
    return Intl.message(
      'We will send you only important notifications to help you stay updated.',
      name: 'notificationPermissionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Allow Geolocation`
  String get allowGeolocation {
    return Intl.message(
      'Allow Geolocation',
      name: 'allowGeolocation',
      desc: '',
      args: [],
    );
  }

  /// `Some of our surveys require your location to provide you with the best experience.`
  String get geolocationPermissionDescription {
    return Intl.message(
      'Some of our surveys require your location to provide you with the best experience.',
      name: 'geolocationPermissionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `You are all set!`
  String get youAreAllSet {
    return Intl.message(
      'You are all set!',
      name: 'youAreAllSet',
      desc: '',
      args: [],
    );
  }

  /// `Do not show again`
  String get doNotShowAgain {
    return Intl.message(
      'Do not show again',
      name: 'doNotShowAgain',
      desc: '',
      args: [],
    );
  }

  /// `Notify Users`
  String get notifyUsers {
    return Intl.message(
      'Notify Users',
      name: 'notifyUsers',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get notificationTitle {
    return Intl.message(
      'Title',
      name: 'notificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get notificationDescription {
    return Intl.message(
      'Description',
      name: 'notificationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Image URL (optional)`
  String get imageUrlOptional {
    return Intl.message(
      'Image URL (optional)',
      name: 'imageUrlOptional',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a title`
  String get enterTitle {
    return Intl.message(
      'Please enter a title',
      name: 'enterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a description`
  String get enterDescription {
    return Intl.message(
      'Please enter a description',
      name: 'enterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send Notification`
  String get sendNotification {
    return Intl.message(
      'Send Notification',
      name: 'sendNotification',
      desc: '',
      args: [],
    );
  }

  /// `Notification sent successfully!`
  String get notificationSentSuccess {
    return Intl.message(
      'Notification sent successfully!',
      name: 'notificationSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send notification`
  String get notificationSentFailed {
    return Intl.message(
      'Failed to send notification',
      name: 'notificationSentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Admin Configuration`
  String get adminConfiguration {
    return Intl.message(
      'Admin Configuration',
      name: 'adminConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Support Email`
  String get supportEmail {
    return Intl.message(
      'Support Email',
      name: 'supportEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a support email`
  String get pleaseEnterSupportEmail {
    return Intl.message(
      'Please enter a support email',
      name: 'pleaseEnterSupportEmail',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp Link`
  String get whatsappLink {
    return Intl.message(
      'WhatsApp Link',
      name: 'whatsappLink',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a WhatsApp link`
  String get pleaseEnterWhatsappLink {
    return Intl.message(
      'Please enter a WhatsApp link',
      name: 'pleaseEnterWhatsappLink',
      desc: '',
      args: [],
    );
  }

  /// `Save Configuration`
  String get saveConfiguration {
    return Intl.message(
      'Save Configuration',
      name: 'saveConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Configuration updated successfully!`
  String get configurationUpdatedSuccessfully {
    return Intl.message(
      'Configuration updated successfully!',
      name: 'configurationUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update configuration`
  String get failedToUpdateConfiguration {
    return Intl.message(
      'Failed to update configuration',
      name: 'failedToUpdateConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInGoogle',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Delete survey?`
  String get confirmDelete {
    return Intl.message(
      'Delete survey?',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Survey`
  String get deleteSurvey {
    return Intl.message(
      'Delete Survey',
      name: 'deleteSurvey',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this survey?`
  String get deleteConfirmationText {
    return Intl.message(
      'Are you sure you want to delete this survey?',
      name: 'deleteConfirmationText',
      desc: '',
      args: [],
    );
  }

  /// `Swipe to confirm`
  String get swipeToConfirm {
    return Intl.message(
      'Swipe to confirm',
      name: 'swipeToConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Your voice shapes the \nfuture of the Negev!`
  String get voiceShapes {
    return Intl.message(
      'Your voice shapes the \nfuture of the Negev!',
      name: 'voiceShapes',
      desc: '',
      args: [],
    );
  }

  /// `Surveys`
  String get surveys {
    return Intl.message(
      'Surveys',
      name: 'surveys',
      desc: '',
      args: [],
    );
  }

  /// `Questions`
  String get questions {
    return Intl.message(
      'Questions',
      name: 'questions',
      desc: '',
      args: [],
    );
  }

  /// `No questionnaires found`
  String get noQuestionnairesFound {
    return Intl.message(
      'No questionnaires found',
      name: 'noQuestionnairesFound',
      desc: '',
      args: [],
    );
  }

  /// `Reset filters`
  String get resetFilters {
    return Intl.message(
      'Reset filters',
      name: 'resetFilters',
      desc: '',
      args: [],
    );
  }

  /// `Responses saved successfully!`
  String get responsesSaved {
    return Intl.message(
      'Responses saved successfully!',
      name: 'responsesSaved',
      desc: '',
      args: [],
    );
  }

  /// `Showing {filteredSurveys} of {surveys}`
  String showingSurveys(Object filteredSurveys, Object surveys) {
    return Intl.message(
      'Showing $filteredSurveys of $surveys',
      name: 'showingSurveys',
      desc: '',
      args: [filteredSurveys, surveys],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `No users found`
  String get noUsersFound {
    return Intl.message(
      'No users found',
      name: 'noUsersFound',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get leaderboard {
    return Intl.message(
      'Leaderboard',
      name: 'leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Manage Users`
  String get manageUsers {
    return Intl.message(
      'Manage Users',
      name: 'manageUsers',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get userRoleNone {
    return Intl.message(
      'None',
      name: 'userRoleNone',
      desc: '',
      args: [],
    );
  }

  /// `Regular User`
  String get userRoleUser {
    return Intl.message(
      'Regular User',
      name: 'userRoleUser',
      desc: '',
      args: [],
    );
  }

  /// `Club Member`
  String get userRoleClubMember {
    return Intl.message(
      'Club Member',
      name: 'userRoleClubMember',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get userRoleAdmin {
    return Intl.message(
      'Admin',
      name: 'userRoleAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Yes/No`
  String get yesNo {
    return Intl.message(
      'Yes/No',
      name: 'yesNo',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Choice`
  String get multipleChoice {
    return Intl.message(
      'Multiple Choice',
      name: 'multipleChoice',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message(
      'Text',
      name: 'text',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get score {
    return Intl.message(
      'Score',
      name: 'score',
      desc: '',
      args: [],
    );
  }

  /// `Numerical`
  String get numerical {
    return Intl.message(
      'Numerical',
      name: 'numerical',
      desc: '',
      args: [],
    );
  }

  /// `Date & Time`
  String get dateTime {
    return Intl.message(
      'Date & Time',
      name: 'dateTime',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Question Text`
  String get questionText {
    return Intl.message(
      'Question Text',
      name: 'questionText',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `Remove Option`
  String get removeOption {
    return Intl.message(
      'Remove Option',
      name: 'removeOption',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get required {
    return Intl.message(
      'Required',
      name: 'required',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Error saving`
  String get saveError {
    return Intl.message(
      'Error saving',
      name: 'saveError',
      desc: '',
      args: [],
    );
  }

  /// `Add User`
  String get addUser {
    return Intl.message(
      'Add User',
      name: 'addUser',
      desc: '',
      args: [],
    );
  }

  /// `Edit User`
  String get editUser {
    return Intl.message(
      'Edit User',
      name: 'editUser',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `points`
  String get points {
    return Intl.message(
      'points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get manage {
    return Intl.message(
      'Manage',
      name: 'manage',
      desc: '',
      args: [],
    );
  }

  /// `Thank you!`
  String get thankYou {
    return Intl.message(
      'Thank you!',
      name: 'thankYou',
      desc: '',
      args: [],
    );
  }

  /// `You received {points} points`
  String youGotPoints(Object points) {
    return Intl.message(
      'You received $points points',
      name: 'youGotPoints',
      desc: '',
      args: [points],
    );
  }

  /// `Responses`
  String get responses {
    return Intl.message(
      'Responses',
      name: 'responses',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message(
      'Preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `in the ranking`
  String get inTheRanking {
    return Intl.message(
      'in the ranking',
      name: 'inTheRanking',
      desc: '',
      args: [],
    );
  }

  /// `this user`
  String get thisUser {
    return Intl.message(
      'this user',
      name: 'thisUser',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade {user} to «Club Member»`
  String upgradeUser(Object user) {
    return Intl.message(
      'Upgrade $user to «Club Member»',
      name: 'upgradeUser',
      desc: '',
      args: [user],
    );
  }

  /// `Downgrade {user} to «Regular User»`
  String downgradeUser(Object user) {
    return Intl.message(
      'Downgrade $user to «Regular User»',
      name: 'downgradeUser',
      desc: '',
      args: [user],
    );
  }

  /// `Promote {user} to Admin`
  String promoteToAdmin(Object user) {
    return Intl.message(
      'Promote $user to Admin',
      name: 'promoteToAdmin',
      desc: '',
      args: [user],
    );
  }

  /// `Are you really sure that you want to promote {user} to Admin?`
  String promoteToAdminConfirmation(Object user) {
    return Intl.message(
      'Are you really sure that you want to promote $user to Admin?',
      name: 'promoteToAdminConfirmation',
      desc: '',
      args: [user],
    );
  }

  /// `Revoke Admin from {user}`
  String revokeAdmin(Object user) {
    return Intl.message(
      'Revoke Admin from $user',
      name: 'revokeAdmin',
      desc: '',
      args: [user],
    );
  }

  /// `Manually Award Badge`
  String get manualAwardBadge {
    return Intl.message(
      'Manually Award Badge',
      name: 'manualAwardBadge',
      desc: '',
      args: [],
    );
  }

  /// `Select a Badge to Award`
  String get manualAwardBadgeTitle {
    return Intl.message(
      'Select a Badge to Award',
      name: 'manualAwardBadgeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select a badge`
  String get selectBadge {
    return Intl.message(
      'Select a badge',
      name: 'selectBadge',
      desc: '',
      args: [],
    );
  }

  /// `Award Badge`
  String get awardBadge {
    return Intl.message(
      'Award Badge',
      name: 'awardBadge',
      desc: '',
      args: [],
    );
  }

  /// `When the status is upgraded to "Club Member", the user will be able to fill out and send reports`
  String get upgradeUserNotice {
    return Intl.message(
      'When the status is upgraded to "Club Member", the user will be able to fill out and send reports',
      name: 'upgradeUserNotice',
      desc: '',
      args: [],
    );
  }

  /// `With downgrading to the regular user, the user will no longer be able to fill out and send reports`
  String get downgradeUserNotice {
    return Intl.message(
      'With downgrading to the regular user, the user will no longer be able to fill out and send reports',
      name: 'downgradeUserNotice',
      desc: '',
      args: [],
    );
  }

  /// `When the status of an "Admin" is provided, the user will be able to manage users and surveys`
  String get promoteToAdminNotice {
    return Intl.message(
      'When the status of an "Admin" is provided, the user will be able to manage users and surveys',
      name: 'promoteToAdminNotice',
      desc: '',
      args: [],
    );
  }

  /// `When the status of an "Admin" is revoked, the user will no longer be able to manage users and surveys`
  String get revokeAdminNotice {
    return Intl.message(
      'When the status of an "Admin" is revoked, the user will no longer be able to manage users and surveys',
      name: 'revokeAdminNotice',
      desc: '',
      args: [],
    );
  }

  /// `Pending Approval`
  String get pendingApproval {
    return Intl.message(
      'Pending Approval',
      name: 'pendingApproval',
      desc: '',
      args: [],
    );
  }

  /// `You are almost ready for takeoff, and we are happy to see you!`
  String get pendingApprovalS1 {
    return Intl.message(
      'You are almost ready for takeoff, and we are happy to see you!',
      name: 'pendingApprovalS1',
      desc: '',
      args: [],
    );
  }

  /// `We received your application to become a YallaNegev Club member.`
  String get pendingApprovalS2 {
    return Intl.message(
      'We received your application to become a YallaNegev Club member.',
      name: 'pendingApprovalS2',
      desc: '',
      args: [],
    );
  }

  /// `We will notify you when your application is approved.`
  String get pendingApprovalS3 {
    return Intl.message(
      'We will notify you when your application is approved.',
      name: 'pendingApprovalS3',
      desc: '',
      args: [],
    );
  }

  /// `Once your application is approved, you will be able to send reports and collect points.`
  String get pendingApprovalS4 {
    return Intl.message(
      'Once your application is approved, you will be able to send reports and collect points.',
      name: 'pendingApprovalS4',
      desc: '',
      args: [],
    );
  }

  /// `My Reports`
  String get myReports {
    return Intl.message(
      'My Reports',
      name: 'myReports',
      desc: '',
      args: [],
    );
  }

  /// `My points`
  String get myPoints {
    return Intl.message(
      'My points',
      name: 'myPoints',
      desc: '',
      args: [],
    );
  }

  /// `Rewards`
  String get rewards {
    return Intl.message(
      'Rewards',
      name: 'rewards',
      desc: '',
      args: [],
    );
  }

  /// `You have {points} points`
  String youHavePoints(Object points) {
    return Intl.message(
      'You have $points points',
      name: 'youHavePoints',
      desc: '',
      args: [points],
    );
  }

  /// `{badgesCollected} out of {totalBadges} badges collected`
  String badgesCollected(Object badgesCollected, Object totalBadges) {
    return Intl.message(
      '$badgesCollected out of $totalBadges badges collected',
      name: 'badgesCollected',
      desc: '',
      args: [badgesCollected, totalBadges],
    );
  }

  /// `Leaderboard position: {position}`
  String leaderboardPosition(Object position) {
    return Intl.message(
      'Leaderboard position: $position',
      name: 'leaderboardPosition',
      desc: '',
      args: [position],
    );
  }

  /// `Your position is`
  String get yourPosition {
    return Intl.message(
      'Your position is',
      name: 'yourPosition',
      desc: '',
      args: [],
    );
  }

  /// `{rank} place in the ranking`
  String positionInRanking(Object rank) {
    return Intl.message(
      '$rank place in the ranking',
      name: 'positionInRanking',
      desc: '',
      args: [rank],
    );
  }

  /// `You`
  String get you {
    return Intl.message(
      'You',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `Points Details`
  String get pointsDetails {
    return Intl.message(
      'Points Details',
      name: 'pointsDetails',
      desc: '',
      args: [],
    );
  }

  /// `Total Points: {totalPoints}`
  String totalPoints(Object totalPoints) {
    return Intl.message(
      'Total Points: $totalPoints',
      name: 'totalPoints',
      desc: '',
      args: [totalPoints],
    );
  }

  /// `Points History`
  String get pointsHistory {
    return Intl.message(
      'Points History',
      name: 'pointsHistory',
      desc: '',
      args: [],
    );
  }

  /// `Loading points history...`
  String get loadingPointsHistory {
    return Intl.message(
      'Loading points history...',
      name: 'loadingPointsHistory',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load points history.`
  String get failedToLoadPointsHistory {
    return Intl.message(
      'Failed to load points history.',
      name: 'failedToLoadPointsHistory',
      desc: '',
      args: [],
    );
  }

  /// `No points history available.`
  String get noPointsHistoryAvailable {
    return Intl.message(
      'No points history available.',
      name: 'noPointsHistoryAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Points Earned`
  String get earnedPoints {
    return Intl.message(
      'Points Earned',
      name: 'earnedPoints',
      desc: '',
      args: [],
    );
  }

  /// `Points Spent`
  String get spentPoints {
    return Intl.message(
      'Points Spent',
      name: 'spentPoints',
      desc: '',
      args: [],
    );
  }

  /// `Redeem Points`
  String get redeemPoints {
    return Intl.message(
      'Redeem Points',
      name: 'redeemPoints',
      desc: '',
      args: [],
    );
  }

  /// `Redeeming points is currently not supported.`
  String get redeemNotSupported {
    return Intl.message(
      'Redeeming points is currently not supported.',
      name: 'redeemNotSupported',
      desc: '',
      args: [],
    );
  }

  /// `Badges`
  String get badges {
    return Intl.message(
      'Badges',
      name: 'badges',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load badges.`
  String get failedToLoadBadges {
    return Intl.message(
      'Failed to load badges.',
      name: 'failedToLoadBadges',
      desc: '',
      args: [],
    );
  }

  /// `No badges available.`
  String get noBadgesAvailable {
    return Intl.message(
      'No badges available.',
      name: 'noBadgesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Earned Badges`
  String get earnedBadges {
    return Intl.message(
      'Earned Badges',
      name: 'earnedBadges',
      desc: '',
      args: [],
    );
  }

  /// `Unearned Badges`
  String get unearnedBadges {
    return Intl.message(
      'Unearned Badges',
      name: 'unearnedBadges',
      desc: '',
      args: [],
    );
  }

  /// `Error loading responses:`
  String get errorLoadingResponses {
    return Intl.message(
      'Error loading responses:',
      name: 'errorLoadingResponses',
      desc: '',
      args: [],
    );
  }

  /// `Number of responses`
  String get numberOfResponses {
    return Intl.message(
      'Number of responses',
      name: 'numberOfResponses',
      desc: '',
      args: [],
    );
  }

  /// `No data loaded`
  String get noDataLoaded {
    return Intl.message(
      'No data loaded',
      name: 'noDataLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Admin Dashboard`
  String get adminDashboard {
    return Intl.message(
      'Admin Dashboard',
      name: 'adminDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Configuration`
  String get configuration {
    return Intl.message(
      'Configuration',
      name: 'configuration',
      desc: '',
      args: [],
    );
  }

  /// `Badges Editing`
  String get badgesEditingTitle {
    return Intl.message(
      'Badges Editing',
      name: 'badgesEditingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Editing badges from this interface is currently not supported.`
  String get badgesEditingMessage {
    return Intl.message(
      'Editing badges from this interface is currently not supported.',
      name: 'badgesEditingMessage',
      desc: '',
      args: [],
    );
  }

  /// `No categories available`
  String get noCategoriesAvailable {
    return Intl.message(
      'No categories available',
      name: 'noCategoriesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get startDate {
    return Intl.message(
      'Start Date',
      name: 'startDate',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message(
      'End Date',
      name: 'endDate',
      desc: '',
      args: [],
    );
  }

  /// `Max reports per user total`
  String get maxReportsPerUserTotal {
    return Intl.message(
      'Max reports per user total',
      name: 'maxReportsPerUserTotal',
      desc: '',
      args: [],
    );
  }

  /// `Max reports per user per day`
  String get maxReportsPerUserPerDay {
    return Intl.message(
      'Max reports per user per day',
      name: 'maxReportsPerUserPerDay',
      desc: '',
      args: [],
    );
  }

  /// `Max Total`
  String get maxReportsPerUserTotalShort {
    return Intl.message(
      'Max Total',
      name: 'maxReportsPerUserTotalShort',
      desc: '',
      args: [],
    );
  }

  /// `Max / Day`
  String get maxReportsPerUserPerDayShort {
    return Intl.message(
      'Max / Day',
      name: 'maxReportsPerUserPerDayShort',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in the fields correctly`
  String get editorValidationError {
    return Intl.message(
      'Please fill in the fields correctly',
      name: 'editorValidationError',
      desc: '',
      args: [],
    );
  }

  /// `Min Value`
  String get minValue {
    return Intl.message(
      'Min Value',
      name: 'minValue',
      desc: '',
      args: [],
    );
  }

  /// `Max Value`
  String get maxValue {
    return Intl.message(
      'Max Value',
      name: 'maxValue',
      desc: '',
      args: [],
    );
  }

  /// `Option`
  String get option {
    return Intl.message(
      'Option',
      name: 'option',
      desc: '',
      args: [],
    );
  }

  /// `Add Option`
  String get addOption {
    return Intl.message(
      'Add Option',
      name: 'addOption',
      desc: '',
      args: [],
    );
  }

  /// `Remove Question`
  String get removeQuestion {
    return Intl.message(
      'Remove Question',
      name: 'removeQuestion',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Icon`
  String get icon {
    return Intl.message(
      'Icon',
      name: 'icon',
      desc: '',
      args: [],
    );
  }

  /// `Pick Icon`
  String get pickIcon {
    return Intl.message(
      'Pick Icon',
      name: 'pickIcon',
      desc: '',
      args: [],
    );
  }

  /// `Less`
  String get less {
    return Intl.message(
      'Less',
      name: 'less',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Email sent`
  String get emailSent {
    return Intl.message(
      'Email sent',
      name: 'emailSent',
      desc: '',
      args: [],
    );
  }

  /// `Check your inbox!`
  String get checkYourInbox {
    return Intl.message(
      'Check your inbox!',
      name: 'checkYourInbox',
      desc: '',
      args: [],
    );
  }

  /// `There was a problem sending the email`
  String get problemSendingEmail {
    return Intl.message(
      'There was a problem sending the email',
      name: 'problemSendingEmail',
      desc: '',
      args: [],
    );
  }

  /// `Restore password`
  String get restorePassword {
    return Intl.message(
      'Restore password',
      name: 'restorePassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `There was an error logging into the app`
  String get errorLoggingIn {
    return Intl.message(
      'There was an error logging into the app',
      name: 'errorLoggingIn',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Display Name`
  String get displayName {
    return Intl.message(
      'Display Name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while trying to sign you in, please try again later.`
  String get signInError {
    return Intl.message(
      'An error occurred while trying to sign you in, please try again later.',
      name: 'signInError',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while trying to sign you in, please try again later.`
  String get signInGoogleError {
    return Intl.message(
      'An error occurred while trying to sign you in, please try again later.',
      name: 'signInGoogleError',
      desc: '',
      args: [],
    );
  }

  /// `Edit Survey`
  String get editSurvey {
    return Intl.message(
      'Edit Survey',
      name: 'editSurvey',
      desc: '',
      args: [],
    );
  }

  /// `Add Survey`
  String get addSurvey {
    return Intl.message(
      'Add Survey',
      name: 'addSurvey',
      desc: '',
      args: [],
    );
  }

  /// `Add Question`
  String get addQuestion {
    return Intl.message(
      'Add Question',
      name: 'addQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Pick Category`
  String get pickCategory {
    return Intl.message(
      'Pick Category',
      name: 'pickCategory',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load leaderboard`
  String get failedToLoadLeaderboard {
    return Intl.message(
      'Failed to load leaderboard',
      name: 'failedToLoadLeaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Upload Image`
  String get uploadImage {
    return Intl.message(
      'Upload Image',
      name: 'uploadImage',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Upload failed`
  String get uploadFailed {
    return Intl.message(
      'Upload failed',
      name: 'uploadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Pick Survey Image`
  String get pickSurveyImage {
    return Intl.message(
      'Pick Survey Image',
      name: 'pickSurveyImage',
      desc: '',
      args: [],
    );
  }

  /// `No image was selected`
  String get noImageSelected {
    return Intl.message(
      'No image was selected',
      name: 'noImageSelected',
      desc: '',
      args: [],
    );
  }

  /// `You need to grant permission if you want to select a photo`
  String get grantPermissionPhoto {
    return Intl.message(
      'You need to grant permission if you want to select a photo',
      name: 'grantPermissionPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Save Profile`
  String get saveProfile {
    return Intl.message(
      'Save Profile',
      name: 'saveProfile',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Join WhatsApp group`
  String get joinWhatsAppGroup {
    return Intl.message(
      'Join WhatsApp group',
      name: 'joinWhatsAppGroup',
      desc: '',
      args: [],
    );
  }

  /// `Contact the team`
  String get contactTheTeam {
    return Intl.message(
      'Contact the team',
      name: 'contactTheTeam',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp Unavailable`
  String get cannotLaunchWhatsAppTitle {
    return Intl.message(
      'WhatsApp Unavailable',
      name: 'cannotLaunchWhatsAppTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can use this WhatsApp link to contact us:`
  String get useWhatsAppLink {
    return Intl.message(
      'You can use this WhatsApp link to contact us:',
      name: 'useWhatsAppLink',
      desc: '',
      args: [],
    );
  }

  /// `Email Client Unavailable`
  String get cannotLaunchEmailTitle {
    return Intl.message(
      'Email Client Unavailable',
      name: 'cannotLaunchEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can use this e-mail address to contact us:`
  String get useEmailAddress {
    return Intl.message(
      'You can use this e-mail address to contact us:',
      name: 'useEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `The app is designed to support Negev community in its digital transformation`
  String get negevCommunitySupport {
    return Intl.message(
      'The app is designed to support Negev community in its digital transformation',
      name: 'negevCommunitySupport',
      desc: '',
      args: [],
    );
  }

  /// `The data is processed in accordance with the law`
  String get dataProcessedLegally {
    return Intl.message(
      'The data is processed in accordance with the law',
      name: 'dataProcessedLegally',
      desc: '',
      args: [],
    );
  }

  /// `Show welcome onboarding`
  String get showWelcomeOnboarding {
    return Intl.message(
      'Show welcome onboarding',
      name: 'showWelcomeOnboarding',
      desc: '',
      args: [],
    );
  }

  /// `This app is created in our country with ♥`
  String get createdWithLove {
    return Intl.message(
      'This app is created in our country with ♥',
      name: 'createdWithLove',
      desc: '',
      args: [],
    );
  }

  /// `Filters not implemented`
  String get filtersNotImplemented {
    return Intl.message(
      'Filters not implemented',
      name: 'filtersNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Enter your answer here`
  String get enterYourAnswerHere {
    return Intl.message(
      'Enter your answer here',
      name: 'enterYourAnswerHere',
      desc: '',
      args: [],
    );
  }

  /// `Enter a number`
  String get enterANumber {
    return Intl.message(
      'Enter a number',
      name: 'enterANumber',
      desc: '',
      args: [],
    );
  }

  /// `Select a date and time`
  String get selectDateTime {
    return Intl.message(
      'Select a date and time',
      name: 'selectDateTime',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Hebrew`
  String get hebrew {
    return Intl.message(
      'Hebrew',
      name: 'hebrew',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Manage your account`
  String get manageYourAccount {
    return Intl.message(
      'Manage your account',
      name: 'manageYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Manage privacy and security settings`
  String get managePrivacyAndSecuritySettings {
    return Intl.message(
      'Manage privacy and security settings',
      name: 'managePrivacyAndSecuritySettings',
      desc: '',
      args: [],
    );
  }

  /// `Please enter only alphabetic characters and spaces`
  String get enterAlphabetic {
    return Intl.message(
      'Please enter only alphabetic characters and spaces',
      name: 'enterAlphabetic',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 2 characters long`
  String get nameLength {
    return Intl.message(
      'Name must be at least 2 characters long',
      name: 'nameLength',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get enterName {
    return Intl.message(
      'Please enter your name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter only alphanumeric characters`
  String get enterAlphanumeric {
    return Intl.message(
      'Please enter only alphanumeric characters',
      name: 'enterAlphanumeric',
      desc: '',
      args: [],
    );
  }

  /// `Display name must be at least 2 characters long`
  String get displayNameLength {
    return Intl.message(
      'Display name must be at least 2 characters long',
      name: 'displayNameLength',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your display name`
  String get enterDisplayName {
    return Intl.message(
      'Please enter your display name',
      name: 'enterDisplayName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an email address`
  String get enterEmail {
    return Intl.message(
      'Please enter an email address',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email address must contain @`
  String get emailAt {
    return Intl.message(
      'Email address must contain @',
      name: 'emailAt',
      desc: '',
      args: [],
    );
  }

  /// `Email address must contain .`
  String get emailDot {
    return Intl.message(
      'Email address must contain .',
      name: 'emailDot',
      desc: '',
      args: [],
    );
  }

  /// `Email address must not contain spaces`
  String get emailSpace {
    return Intl.message(
      'Email address must not contain spaces',
      name: 'emailSpace',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address, for example: user@example.com`
  String get validEmail {
    return Intl.message(
      'Enter a valid email address, for example: user@example.com',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get enterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordLength {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordLength',
      desc: '',
      args: [],
    );
  }

  /// `Display name already exists, please choose another one.`
  String get displayNameExists {
    return Intl.message(
      'Display name already exists, please choose another one.',
      name: 'displayNameExists',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `This is a unique name that will be displayed to other users`
  String get uniqueNameInfo {
    return Intl.message(
      'This is a unique name that will be displayed to other users',
      name: 'uniqueNameInfo',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: Email already in use.`
  String get emailInUse {
    return Intl.message(
      'An error occurred: Email already in use.',
      name: 'emailInUse',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: Weak password.`
  String get weakPassword {
    return Intl.message(
      'An error occurred: Weak password.',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: Invalid email.`
  String get invalidEmail {
    return Intl.message(
      'An error occurred: Invalid email.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in the fields correctly`
  String get fillFieldsCorrectly {
    return Intl.message(
      'Please fill in the fields correctly',
      name: 'fillFieldsCorrectly',
      desc: '',
      args: [],
    );
  }

  /// `Sorry!`
  String get sorry {
    return Intl.message(
      'Sorry!',
      name: 'sorry',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get congratulations {
    return Intl.message(
      'Congratulations!',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `You have been demoted to`
  String get youHaveBeenDemotedTo {
    return Intl.message(
      'You have been demoted to',
      name: 'youHaveBeenDemotedTo',
      desc: '',
      args: [],
    );
  }

  /// `You have been promoted to`
  String get youHaveBeenPromotedTo {
    return Intl.message(
      'You have been promoted to',
      name: 'youHaveBeenPromotedTo',
      desc: '',
      args: [],
    );
  }

  /// `Submitted on {date}`
  String submittedOn(Object date) {
    return Intl.message(
      'Submitted on $date',
      name: 'submittedOn',
      desc: '',
      args: [date],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `No reports submitted yet`
  String get noReportsSubmittedYet {
    return Intl.message(
      'No reports submitted yet',
      name: 'noReportsSubmittedYet',
      desc: '',
      args: [],
    );
  }

  /// `Joined on {formattedJoinDate}`
  String joinDate(Object formattedJoinDate) {
    return Intl.message(
      'Joined on $formattedJoinDate',
      name: 'joinDate',
      desc: '',
      args: [formattedJoinDate],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Survey Response`
  String get surveyResponse {
    return Intl.message(
      'Survey Response',
      name: 'surveyResponse',
      desc: '',
      args: [],
    );
  }

  /// `Coordinates`
  String get coordinates {
    return Intl.message(
      'Coordinates',
      name: 'coordinates',
      desc: '',
      args: [],
    );
  }

  /// `Points Credited`
  String get pointsCredited {
    return Intl.message(
      'Points Credited',
      name: 'pointsCredited',
      desc: '',
      args: [],
    );
  }

  /// `Submitted`
  String get submitted {
    return Intl.message(
      'Submitted',
      name: 'submitted',
      desc: '',
      args: [],
    );
  }

  /// `Survey ID`
  String get surveyId {
    return Intl.message(
      'Survey ID',
      name: 'surveyId',
      desc: '',
      args: [],
    );
  }

  /// `User ID`
  String get userId {
    return Intl.message(
      'User ID',
      name: 'userId',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email to confirm account deletion:`
  String get enterEmailToDeleteAccount {
    return Intl.message(
      'Please enter your email to confirm account deletion:',
      name: 'enterEmailToDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `I understand the consequences, and I want to delete my account`
  String get confirmDeleteAccount {
    return Intl.message(
      'I understand the consequences, and I want to delete my account',
      name: 'confirmDeleteAccount',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'he'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}