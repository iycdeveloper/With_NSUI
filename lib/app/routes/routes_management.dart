import 'package:iyc/app/core/app_export.dart';
// import 'package:iyc/app/modules/barcode_scanner/barcode_scanner_screen.dart';
import 'package:iyc/app/modules/campaign/campaign_screen.dart';
import 'package:iyc/app/modules/ch_campaign/ch_campaign_screen.dart';
import 'package:iyc/app/modules/contributions/contributions_screen.dart';
import 'package:iyc/app/modules/data_privacy/data_privacy_screen.dart';
// import 'package:iyc/app/modules/forms/jh_campaign/jh_campaign_screen.dart';
// import 'package:iyc/app/modules/forms/sada_haq_campaign/sada_haq_campaign_screen.dart';
// import 'package:iyc/app/modules/forms/samvidhan_ka_shipahi/sks_screen.dart';
import 'package:iyc/app/modules/membership/screens/membership_batch_screen.dart';
import 'package:iyc/app/modules/membership/screens/membership_landing_screen.dart';
import 'package:iyc/app/modules/membership/screens/membership_member_list_screen.dart';
import 'package:iyc/app/modules/ro_access/dashboard/dashboard_screen.dart';
import 'package:iyc/app/modules/ro_access/membership/membership_detailed_page.dart';
import 'package:iyc/app/modules/ro_access/nomination_detailed_page.dart';
import 'package:iyc/app/modules/rozgar_nyay_patra/rozgar_nyay_patra_screen.dart';
import 'package:iyc/app/modules/scrutiny/scrutiny_view.dart';
// import 'package:iyc/app/modules/shakti_club/screens/add_club_member_screen.dart';
// import 'package:iyc/app/modules/shakti_club/screens/create_club_screen.dart';
// import 'package:iyc/app/modules/shakti_club/screens/leaderboard_screen.dart';
// import 'package:iyc/app/modules/shakti_club/screens/view_club_details_screen.dart';
// import 'package:iyc/app/modules/shakti_club/screens/view_shakti_member_screen.dart';
import 'package:iyc/model/data_model/batch_member.dart';

/// A chunk of routes taken in the application.
abstract class RoutesManagement {
  /// Go to the login screen.
  static void goToBoardingScreen() {
    Get.offAllNamed<void>(AppRoutes.onboardingScreen);
  }

  /// Go to the login screen.
  static void goToLoginScreen() {
    Get.offAllNamed<void>(AppRoutes.loginScreen);
  }

  /// Go to the login otp screen.
  static void goToLoginOtpScreen() {
    Get.toNamed<void>(AppRoutes.otpScreen);
  }

  /// Go to the login otp screen.
  static void goToRegisterOtpScreen() {
    Get.toNamed<void>(AppRoutes.registerOtpScreen);
  }

  /// Go to the register screen.
  static void goToRegisterScreen(String mobile) {
    Get.toNamed<void>(AppRoutes.register, arguments: mobile);
  }

  /// Go to the register screen.
  static void goToHomeScreen() {
    Get.offAllNamed<void>(AppRoutes.home);
  }

  /// Go to the profile screen.
  static void goToProfileScreen({int tabIndex = 1}) {
    Get.toNamed<void>(AppRoutes.profile, arguments: tabIndex);
  }

  /// Go to the social screen.
  static void goToSocialScreen() {
    Get.toNamed<void>(AppRoutes.social);
  }

  /// Go to the menu screen.
  static void goToMenuScreen() {
    Get.toNamed<void>(AppRoutes.menu);
  }

  /// Go to the leader board screen.
  static void goToLeaderBoardScreen() {
    Get.toNamed<void>(AppRoutes.leaderBoard);
  }

  /// Go to the id card screen.
  static void goToIdCardScreen() {
    Get.toNamed<void>(AppRoutes.idCard);
  }

  /// Go to the id booth jodo screen.
  static void goToBoothJodoScreen(dynamic data) {
    Get.toNamed<void>(AppRoutes.boothJodo, arguments: data);
  }

  /// Go to the id booth jodo screen.
  static void goToVoterListViewFormScreen(dynamic data) {
    Get.toNamed<void>(AppRoutes.voteListViewFormScreen, arguments: data);
  }

  /// Go to the id onboarding one screen.
  static void goToOnboardingOneScreen() {
    Get.toNamed<void>(AppRoutes.onboardingOne);
  }

  /// Go to the id onboarding one screen.
  static void goToOnboardingTwoScreen() {
    Get.toNamed<void>(AppRoutes.onboardingTwo);
  }

  /// Go to the id onboarding one screen.
  static void goToOnboardingThreeScreen() {
    Get.toNamed<void>(AppRoutes.onboardingThree);
  }

  /// Go to the id onboarding Four screen.
  static void goToOnboardingFourScreen() {
    Get.toNamed<void>(AppRoutes.onboardingFour);
  }

  /// Go to the id rewards screen.
  static void goToRewardsScreen() {
    Get.toNamed<void>(AppRoutes.rewards);
  }

  /// Go to the id rewards screen.
  static void goToRewardsDetailScreen() {
    Get.toNamed<void>(AppRoutes.rewardsDetail);
  }

  /// Go to the id program screen.
  static void goToProgramScreen({bool isMeetingView = false}) {
    Get.toNamed<void>(AppRoutes.program, arguments: isMeetingView);
  }

  /// Go to the id program details screen.
  static void goToProgramDetailsScreen() {
    Get.toNamed<void>(AppRoutes.programDetails);
  }

  /// Go to the id program details screen.
  static void goToNewProgramScreen({bool isMeetingView = false}) {
    Get.toNamed<void>(AppRoutes.newProgram, arguments: isMeetingView);
  }

  /// Go to the id statement screen.
  static void goToStatementScreen() {
    Get.toNamed<void>(AppRoutes.statement);
  }

  /// Go to the id my activity screen.
  static void goToMyActivityScreen() {
    Get.toNamed<void>(AppRoutes.myActivity);
  }

  /// Go to the id my activity screen.
  static void goToTaskDetailsScreen() {
    Get.toNamed<void>(AppRoutes.taskDetails);
  }

  /// Go to the id my activity screen.
  static void goToTaskCompletedScreenScreen() {
    Get.toNamed<void>(AppRoutes.completedTask);
  }

  /// Go to the id my activity screen.
  static void goToNewTaskScreenScreen() {
    Get.toNamed<void>(AppRoutes.newTask);
  }

  /// Go to the notification screen.
  static void goToNotificationScreen() {
    Get.toNamed<void>(AppRoutes.notification);
  }

  /// Go to the my team screen.
  static void goToMyTeamScreen() {
    Get.toNamed<void>(AppRoutes.myTeam);
  }

  /// Go to the my team screen.
  static void goToCheckInScreen() {
    Get.toNamed<void>(AppRoutes.checkIn);
  }

  /// Go to the my team screen.
  static void goToPointSystemScreen() {
    Get.toNamed<void>(AppRoutes.pointSystem);
  }

  /// Go to the view booth screen.
  static void goToViewBothScreen() {
    Get.toNamed<void>(AppRoutes.viewBooth);
  }

  /// Go to the External Training screen.
  static void goToExternalTrainingScreen() {
    Get.toNamed<void>(AppRoutes.externalTraining);
  }

  /// Go to the Add Role screen.
  static void goToAddRoleScreen(String title, String roleId) {
    Get.toNamed<void>(AppRoutes.addRole, arguments: [title, roleId]);
    Log.printILog('$title $roleId');
  }

  /// Go to the Booth Jodo Report screen.
  static void goToBoothJodoReportScreen() {
    Get.toNamed<void>(AppRoutes.boothJodoReport);
  }

  /// Go to the Campaign Report screen.
  static void goToCampaignReportScreen(String campaignId) {
    Get.toNamed<void>(AppRoutes.campaignReport, arguments: campaignId);
  }

  /// Go to the RO Access screen.
  static void goToROAccessScreen() {
    Get.toNamed<void>(AppRoutes.roAccess);
  }

  /// Go to the Complaints screen.
  static void goToComplaintsScreen() {
    Get.toNamed<void>(AppRoutes.complaints);
  }

  /// Go to the Complaints screen.
  static void goToShaktiClubScreen() {
    Get.toNamed<void>(AppRoutes.shaktiCub);
  }

  /// Go to the Complaints screen.
  static void goToCoordinatorScreen() {
    Get.toNamed<void>(AppRoutes.coordinator);
  }

  /// Go to the Complaints screen.
  static void goToAddCoordinatorScreen() {
    Get.toNamed<void>(AppRoutes.addCoordinator);
  }

  /// Go to the [CreateClubScreen] screen.
  static void goToCreateClubScreen() {
    Get.toNamed<void>(AppRoutes.createClub);
  }

  /// Go to the [ClubDetails] screen.
  static void goToViewClubScreen() {
    Get.toNamed<void>(AppRoutes.viewClub);
  }

  /// Go to the [ViewClubDetailsScreen] screen.
  static void goToViewClubDetailsScreen(dynamic clubDetails) {
    Get.toNamed<void>(AppRoutes.viewClubDetails, arguments: clubDetails);
  }

  /// Go to the [ContributionsScreen] screen.
  static void goToContributionsScreen() {
    Get.toNamed<void>(AppRoutes.contributions);
  }

  /// Go to the [ScrutinyScreen] screen.
  static void goToScrutinyScreen() {
    Get.toNamed<void>(AppRoutes.scrutiny);
  }

  /// Go to the [AddClubMemberScreen] screen.
  static void goToAddClubMemberScreen() {
    Get.toNamed<void>(AppRoutes.addClubMember);
  }

  /// Go to the [ClubLeaderboardScreen] screen.
  static void goToClubLeaderboardScreen() {
    Get.toNamed<void>(AppRoutes.clubLeaderBoard);
  }

  /// Go to the [ClubMemberDetail] screen.
  static void goToClubMemberDetailScreen(
      dynamic memberDetail, bool isMemberDetail) {
    Get.toNamed<void>(AppRoutes.clubMemberDetail,
        arguments: [memberDetail, isMemberDetail]);
  }

  /// Go to the [RozgarNyayPatraScreen] screen.
  static void goToRozgarNyayPatraScreen(String title) {
    Get.toNamed<void>(AppRoutes.rozgarNyayPatra, arguments: title);
  }

  /// Go to the [RozgarNyayPatraScreen] screen.
  static void goToAddIndividualMemberScreen() {
    Get.toNamed<void>(AppRoutes.addIndividualMember);
  }

  /// Go to the [ViewShaktiMemberScreen] screen.
  static void goToViewShaktiMemberScreen() {
    Get.toNamed<void>(AppRoutes.viewShaktiMember);
  }

  /// Go to the [UpdateScreen] screen.
  static void goToUpdateScreen() {
    Get.toNamed<void>(AppRoutes.update);
  }

  /// Go to the [RoomScreen] screen.
  static void goToChatScreen() {
    Get.toNamed<void>(AppRoutes.chat);
  }

  /// Go to the [OneToOneChatScreen] screen.
  // static void goToOneToOneChatScreenScreen(
  //     types.Room room, types.User otherUser,
  //     {bool isNewChat = false, type}) {
  //   Get.toNamed<void>(AppRoutes.oneToOneChat, arguments: [room, isNewChat, otherUser]);
  // }

  /// Go to the [UsersPage] screen.
  static void goToSearchUsersScreen() {
    Get.toNamed<void>(AppRoutes.searchUsers);
  }

  /// Go to the [CreateGroupChatScreen] screen.
  static void goToCreateGroupChatScreen() {
    Get.toNamed<void>(AppRoutes.createGroupChat, arguments: [false]);
  }

  /// Go to the [CreateGroupChatScreen] screen.
  // static void goToUpdateGroupChatScreen(types.Room room) {
  //   Get.toNamed<void>(AppRoutes.createGroupChat, arguments: [true, room]);
  // }

  /// Go to the [BarcodeScannerScreen] screen.
  static void goToBarcodeScannerScreen(String barcode) {
    Get.toNamed<void>(AppRoutes.barcodeScreen, arguments: barcode);
  }

  /// Go to the [SelectCampaign] screen.
  static void goToSelectCampaignScreen() {
    Get.toNamed<void>(AppRoutes.selectCampaign);
  }

  /// Go to the [NyayGuaranteeScreen] screen.
  static void goToNyayGuaranteeScreen(String title) {
    Get.toNamed<void>(AppRoutes.nyayCampaign, arguments: title);
  }

  /// Go to the [ChCampaignScreen] screen.
  static void goToChCampaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.chCampaignForm, arguments: title);
  }

  /// Go to the [CampaignScreen] screen.
  static void goToCampaignScreen(String campaignId) {
    Get.toNamed<void>(AppRoutes.campaign, arguments: campaignId);
  }

  /// Go to the [HrCampaignScreen] screen.
  static void goToHrCampaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.hrCampaignForm, arguments: title);
  }

  /// Go to the [HmCampaignScreen] screen.
  static void goToHmCampaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.hmCampaignForm, arguments: title);
  }

  /// Go to the [ChaloPanchayat] screen.
  static void goToChaloPanchayat() {
    Get.toNamed<void>(AppRoutes.chaloPanchayat);
  }

  /// Go to the [ChaloPanchayatHistory] screen.
  static void goToChaloPanchayatHistory() {
    Get.toNamed<void>(AppRoutes.chaloPanchayatHistory);
  }

  /// Go to the [ChaloPanchayatDataView] screen.
  static void goToChaloPanchayatDataView() {
    Get.toNamed<void>(AppRoutes.chaloPanchayatDataView);
  }

  /// Go to the [PehlaVoteScreen] screen.
  static void goToPehlaVoteScreen() {
    Get.toNamed<void>(AppRoutes.pehlaVote);
  }

  /// Go to the [JhCampaignScreen] screen.
  static void goToJhCampaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.jhCampaign, arguments: title);
  }

  /// Go to the [CongressFlagiEHCamaignScreen] screen.
  static void goToCongressFlagiEHCamaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.newCampaign, arguments: title);
  }

  /// Go to the [OutreachCamaignScreen] screen.
  static void goToOutreachCamaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.outreachCampaign, arguments: title);
  }

  /// Go to the [MaiBahinMaanCamaignScreen] screen.
  static void goToMaiBahinMaanCamaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.maibhainMaanCampaign, arguments: title);
  }

  /// Go to the [ChaloPanchayatJKScreen] screen.
  static void goToChaloPanchayatJKScreen() {
    Get.toNamed<void>(AppRoutes.chaloPanchayatJK);
  }

  /// Go to the [LivelynessScreen] screen.
  static void goToLivelynessScreen() {
    Get.toNamed<void>(AppRoutes.livelynessScreen);
  }

  /// Go to the [DataPrivacyPolicy] screen.
  static void goToDataPrivacyPolicy() {
    Get.toNamed<void>(AppRoutes.privacyPolicy);
  }

  /// Go to the [DataPrivacyPolicy] screen.
  static void goToUddanCampaign(String title) {
    Get.toNamed<void>(AppRoutes.uddanCampaign, arguments: title);
  }

  /// Go to the [SadaHaqCampaignScreen] screen.
  static void goToSadaHaqCampaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.sadaHaq, arguments: title);
  }

  /// Go to the [NominationDetailScreen] screen.
  static void goToNominationDetailScreen(dynamic nominationDetail) {
    Get.toNamed<void>(AppRoutes.nominationDetail, arguments: nominationDetail);
  }

  /// Go to the [NominationEditScreen] screen.
  static void goToRoNominationEditScreen(dynamic nominationDetail) {
    Get.toNamed<void>(AppRoutes.roNominationEditscreen,
        arguments: nominationDetail);
  }

  /// Go to the [MembershipRoAccess] screen.
  static void goToMembershipRoAccess() {
    Get.toNamed<void>(AppRoutes.membershipRoAccess);
  }

  /// Go to the [MembershipDetailScreen] screen.
  static void goToMembershipDetailScreen(dynamic membershipDetailed) {
    Get.toNamed<void>(AppRoutes.membershipDetailed,
        arguments: membershipDetailed);
  }

  /// Go to the [FilterBottomSheet] screen.
  static void goToFilterBottomSheet() {
    Get.toNamed<void>(AppRoutes.memberShipROFilter);
  }

  /// Go to the [DashBoardScreen] screen.
  static void goToMembershipDashBoardScreen() {
    Get.toNamed<void>(AppRoutes.memberShipRODashboard);
  }

  /// Go to the [WadeCampaignScreen] screen.
  static void goToWadeCampaignScreen(String title) {
    Get.toNamed<void>(AppRoutes.wadeCampaign, arguments: title);
  }

  /// Go to the [WadeCampaignScreen] screen.
  static void goToNetworkImageViewer(String title, String url) {
    Get.toNamed<void>(AppRoutes.imageViewer, arguments: [title, url]);
  }

  /// Go to the [MembershipLandingPage] screen.
  static void goToMembershipLandingPage() {
    Get.toNamed<void>(AppRoutes.membershipLanding);
  }

  /// Go to the [MembershipBatchScreen] screen.
  static void goToMembershipBatchScreen() {
    Get.toNamed<void>(AppRoutes.membershipBatch);
  }

  /// Go to the [MembershipMemberListScreen] screen.
  static void goToMembershipMemberListScreen(String batchId) {
    Get.toNamed<void>(AppRoutes.membershipMemberList, arguments: batchId);
  }

  /// Go to the [MembershipMemberCreateScreen] screen.
  static void goToMembershipMemberCreateScreen(BatchMember member,
      {bool isUpdate = false,
      bool isLegalCell = false,
      bool isUpdateToDB = false}) {
    Get.toNamed<void>(
      AppRoutes.membershipMemberCreate,
      arguments: [isUpdate, isLegalCell, member, isUpdateToDB],
    );
  }

  /// Go to the [ElectionReportScreen] screen.
  static void goToElectionReportScreen() {
    Get.toNamed<void>(AppRoutes.electionReport);
  }

  /// Go to the [ViewReportScreen] screen.
  static void goToViewElectionReportScreen(Map<String, dynamic> data) {
    Get.toNamed<void>(
      AppRoutes.viewElectionReport,
      arguments: data,
    );
  }

  /// Go to the [SKSScreen] screen.
  static void goToSKSScreen(String title) {
    Get.toNamed<void>(AppRoutes.sksCampaign, arguments: title);
  }

  /// Go to the [YIKBScreen] screen.
  static void goToYIKBScreen() {
    Get.toNamed<void>(AppRoutes.yikbForm);
  }

  /// Go to the [AddElectionDetail] screen.
  static void goToAddElectionDetail() {
    Get.toNamed<void>(AppRoutes.addElectionDetail);
  }

  /// Go to the [YouthJodoScreen] screen.
  static void goToYouthJodo(String youthJodoType) {
    Get.toNamed<void>(AppRoutes.youthJodo, arguments: youthJodoType);
  }

  /// Go to the [YouthJodoFormScreen] screen.
  static void goToYouthJodoForm() {
    Get.toNamed<void>(AppRoutes.youthJodoForm);
  }

  /// Go to the [YouthJodoViewFormScreen] screen.
  static void goToYouthJodoViewForm(dynamic viewdetails) {
    Get.toNamed<void>(AppRoutes.youthJodoviewForm, arguments: viewdetails);
  }

  /// Go to the [YouthJodoFormScreen] screen.
  static void goToAssignment() {
    Get.toNamed<void>(AppRoutes.assignment);
  }

  //
  /// Go to the [OrganisationalMeetingHistory] screen.
  static void goToOrganisationMeetingHistory({bool isMeetingView = false}) {
    Get.toNamed<void>(AppRoutes.organisationalMeetingHistory,
        arguments: isMeetingView);
  }

  /// Go to the [OrganisationalMeetingForm] screen.
  static void goToOrganisationMeetingForm({bool isMeetingView = false}) {
    Get.toNamed<void>(AppRoutes.organisationalMeetingForm,
        arguments: isMeetingView);
  }

  /// Go to the [OrganisationalMeetingViewForm] screen.
  static void goToOrganisationMeetingViewForm() {
    Get.toNamed<void>(
      AppRoutes.organisationalMeetingViewForm,
    );
  }

  /// Go to the [MediaSMForm] screen.
  static void goToMediaSmForm() {
    Get.toNamed<void>(
      AppRoutes.mediaSMForms,
    );
  }

  /// Go to the [NewShaktiProgramForm] screen.
  static void goToNewShaktiPRogramForm() {
    Get.toNamed<void>(
      AppRoutes.newShaktiProgramForm,
    );
  }

  /// Go to the [NewShaktiProgramHistory] screen.
  static void goToNewShaktiProgramHistory() {
    Get.toNamed<void>(
      AppRoutes.newShaktiProgramHistory,
    );
  }

  /// Go to the [NewShaktiProgramViewForm] screen.
  static void goToNewShaktiProgramViewForm() {
    Get.toNamed<void>(
      AppRoutes.newShaktiProgramViewForm,
    );
  }

  /// Go to the [BPYcScreen] screen.
  static void goToBPYcScreen() {
    Get.toNamed<void>(
      AppRoutes.bpycmainscreen,
    );
  }

  /// Go to the [BPYcAddScreen] screen.
  static void goToAddBPYcScreen() {
    Get.toNamed<void>(
      AppRoutes.bpycAddScreen,
    );
  }

  /// Go to the [BPYcAddMemberScreen] screen.
  static void goToAddMemberBPYcScreen() {
    Get.toNamed<void>(
      AppRoutes.bpycAddMemberScreen,
    );
  }

  /// Go to the [BPYcHistoryMemberScreen] screen.
  static void goToHistoryMemberBPYcScreen(dynamic data) {
    Get.toNamed<void>(AppRoutes.bpycHistoryMemberScreen, arguments: data);
  }

  /// Go to the [BPYcViewMemberScreen] screen.
  static void goToViewMemberBPYcScreen() {
    Get.toNamed<void>(
      AppRoutes.bpycViewMemberScreen,
    );
  }

  /// Go to the [OrgNewProgramScreen] screen.
  static void goToOrgNewProgramScreen() {
    Get.toNamed<void>(
      AppRoutes.organisationNewProgram,
    );
  }

  /// Go to the [OrgNewProgramDetailsScreen] screen.
  static void goToOrgNewProgramDetailsScreen(dynamic data) {
    Get.toNamed<void>(AppRoutes.organisationNewProgramDetails, arguments: data);
  }

  /// Go to the [katnakaD2dCampaignScreen] screen.
  static void goToKarnatakaD2dCapignScreen(String campaignId) {
    Get.toNamed<void>(AppRoutes.karnatakaD2dCampaign, arguments: campaignId);
  }

  /// Go to the [AttendanceScreen] screen.
  static void goToAttendanceScreen(dynamic data) {
    Get.toNamed<void>(AppRoutes.attendanceform, arguments: data);
  }

  // NSUI

  /// Go to the [SplashscreenNSUI] screen.
  static void goToSplashscreenNSUI() {
    Get.toNamed<void>(
      AppRoutes.splashscreeNSUI,
    );
  }

  /// Go to the [LoginscreenNSUI] screen.
  static void goToLoginscreenNSUI() {
    Get.offAllNamed<void>(AppRoutes.loginscreeNSUI);
  }

  /// Go to the login otp screen.
  static void goToLoginOtpScreenNSUI() {
    Get.toNamed<void>(AppRoutes.otpScreenNSUI);
  }

  /// Go to the login otp screen.
  static void goToRegisterScreenNSUI(String mobile) {
    Get.toNamed<void>(AppRoutes.registerScreenNSUI,arguments: mobile);
  }

  /// Go to the home screen.
  static void goToHomeScreenNSUI() {
    Get.offAllNamed<void>(AppRoutes.homeScreenNSUI);
  }

  /// Go to the social screen.
  static void goToSocialScreenNSUI() {
    Get.toNamed<void>(AppRoutes.socialScreenNSUI);
  }

  /// Go to the profile screen.
  static void goToProfileScreenNSUI() {
    Get.toNamed<void>(AppRoutes.profileScreenNSUI);
  }

  /// Go to the edit profile screen.
  static void goToEditProfileScreenNSUI() {
    Get.toNamed<void>(AppRoutes.editProfileScreenNSUI);
  }

  /// Go to the login otp screen.
  static void goToRegisterOtpScreenNSUI() {
    Get.toNamed<void>(AppRoutes.registerOtpScreenNSUI);
  }

  /// Go to the [MembershipMemberCreateScreen] screen.
  static void goToMembershipMemberViewScreen(BatchMember member,
      {bool isUpdate = false,
      bool isLegalCell = false,
      bool isUpdateToDB = false}) {
    Get.toNamed<void>(
      AppRoutes.membershipMemberView,
      arguments: [isUpdate, isLegalCell, member, isUpdateToDB],
    );
  }
}
