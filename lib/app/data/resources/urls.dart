class Urls {
  static const _productionUrlIYC =
      "https://api.iyc.in/ycea/ycea-api/service/nsui/api/v1.0/";

  static const _baseUrl = _productionUrlIYC;
  static const baseUrl = _baseUrl;

  static const scan = _baseUrl + "auth/scan.php";
  static const register = _baseUrl + "auth/register.php";
  static const login = _baseUrl + "auth/login.php";
  static const verifyLoginOtp = _baseUrl + "auth/validate.php";
  static const getUserDetails = _baseUrl + "auth/getUserDetailsNew.php";
  static const editProfile = _baseUrl + "auth/editProfile.php";
  static const logout = _baseUrl + "auth/logout.php";
  static const getRewards = _baseUrl + "auth/getRewards.php";
  static const userActivity = _baseUrl + "iyc_social/userActivity.php";

  static const getCSNOTP = _baseUrl + "aggregator/getCSNOTP.php";
  static const validateCSNOTP = _baseUrl + "aggregator/validateCSNOTP.php";

  static const getAggrId = _baseUrl + "aggregator/getAggrID.php";
  static const getINCUserDetails = _baseUrl + "aggregator/getINCMember.php";

  /// chalo panchayat
  ///chaloPanchayat/viewData.php
  static const addChaloPanchayat =
      _baseUrl + "chaloPanchayat/addChaloPanchayat.php";
  static const youthJodo = _baseUrl + "chaloPanchayat/addYouthJodoData.php";
  static const viewChaloPanchayat =
      _baseUrl + "chaloPanchayat/getChaloPanchayat.php";
  static const viewYouthJodo = _baseUrl + "chaloPanchayat/getYouthJodoData.php";
  static const addPehlaVote = _baseUrl + "chaloPanchayat/pehlaVote.php";

  //BPYC
  static const viewBPYC = _baseUrl + "chaloPanchayat/viewPanchayat.php";
  static const addBPYC = _baseUrl + "chaloPanchayat/addPanchayat.php";
  static const viewMemberBPYC =
      _baseUrl + "chaloPanchayat/viewPanchayatMember.php";
  static const addMemberBPYC =
      _baseUrl + "chaloPanchayat/addPanchayatMember.php";

  ///Election Contest
  static const addElectionContest = _baseUrl + "auth/addElectionContested.php";
  static const viewElectionContest =
      _baseUrl + "auth/viewElectionContested.php";

  /// Leader Board
  static const getLeaderBoard = _baseUrl + "auth/getLeaderBoard.php";
  static const getPointStatement = _baseUrl + "auth/getPointStatement.php";

  /// Shakti Club
  static const addCoordinator = _baseUrl + "shaktiClub/addCoordinator.php";
  static const viewCoordinator = _baseUrl + "shaktiClub/viewCoordinator.php";
  static const createClub = _baseUrl + "shaktiClub/createClub.php";
  static const viewClub = _baseUrl + "shaktiClub/viewClub.php";
  static const addClubMember = _baseUrl + "shaktiClub/addClubMember.php";
  static const addShaktiMember = _baseUrl + 'shaktiClub/addMember.php';
  static const viewClubMember = _baseUrl + "shaktiClub/viewClubMember.php";
  static const clubLeaderBoard = _baseUrl + "shaktiClub/leaderboard.php";
  static const viewShaktiMember = _baseUrl + 'shaktiClub/viewMember.php';
  static const checkClubMember = _baseUrl + 'shaktiClub/checkClubMember.php';

  /// YOUNG INDIA KE BOL
  /// End points
  static const addYIKBData = _baseUrl + "yikb/addYIKBData.php";
  static const addYIKBPayment = _baseUrl + "yikb/initiateYIKBPayment.php";
  static const addYIKBCheckPaymentStatus =
      _baseUrl + "yikb/checkYIKBPayment.php";

  ///scrutiny
  static const checkScrutinyStatus =
      _baseUrl + "scrutiny/getScrutinyStatus.php";
  static const scrutinyValidate = _baseUrl + "scrutiny/validate.php";
  static const downloadBatch = _baseUrl + "scrutiny/downloadBatch.php";
  static const downloadAM = _baseUrl + "scrutiny/downloadAM.php";
  static const syncBatch = _baseUrl + "scrutiny/syncBatch.php";

  /// ................aggr .urls...................
  static const aggrRegister = _baseUrl + "aggregator/AggrRegister.php";
  static const verifyAggrOtp = _baseUrl + "aggregator/AggrValidate.php";
  static const agrCreateBatch = _baseUrl + "aggregator/AggrCreateBatch.php";
  static const agrEpicCheck = _baseUrl + "aggregator/epicCheck.php";

  static const agrDownloadBatches =
      _baseUrl + "aggregator/AggrDownloadBatches.php";
  static const agrDownloadMembers =
      _baseUrl + "aggregator/AggrDownloadMembers.php";
  static const DOBRange = _baseUrl + "aggregator/DOBRange.php";
  static const syncMembership = _baseUrl + "aggregator/sync.php";
  static const checkAMMobile = _baseUrl + "aggregator/checkAMMobile.php";
  static const verifyAMMobile = _baseUrl + "aggregator/verifyAMMobile.php";
  static const checkS3Upload = _baseUrl + "aggregator/checkS3Upload.php";

  ///Nomination url...............................
  static const nominationMemberLogin =
      _baseUrl + "selfnomination_1/memberLogin.php";
  static const nominationValidate =
      _baseUrl + "selfnomination_1/memberValidate.php";
  static const nominationAmount =
      _baseUrl + "selfnomination_1/nominationAmount.php";
  static const syncNomination = _baseUrl + "selfnomination_1/addNomination.php";
  static const paymentNomination =
      _baseUrl + "selfnomination_1/addNominationPayment.php";

  static const getNominationStatus =
      _baseUrl + "selfnomination_1/getNominationStatus.php";
  static const getNominationPaymentCheck =
      _baseUrl + "selfnomination_1/checkNominationPayment.php";
  static const addNominationPayment =
      _baseUrl + "selfnomination_1/addNominationPayment.php";
  static const updateCsn = _baseUrl + "selfnomination_1/updateCSN.php";

  //TODO://
  // static const syncBatch = _baseUrl + "";

  ///............... reports url .............................

  static const loginReports = _baseUrl + "report/login.php";
  static const loginReportsValidate = _baseUrl + "report/validate.php";
  static const getReport = _baseUrl + "getReport.php";
  static const getReportList = _baseUrl + "report/getReportList.php";

  ///facebook tokens
  static const baseFacebookUrl = "https://graph.facebook.com/";

  // static const fbToken1 = baseFacebookUrl +"110868101473668/feed?fields=full_picture,id,story,created_time,message,attachments&access_token=";
  static const fbToken2 = baseFacebookUrl +
      "104549968677621/feed?fields=full_picture,id,story,created_time,message,attachments&access_token=";
  static const fbToken3 = baseFacebookUrl +
      "539735649507472/feed?fields=full_picture,id,story,created_time,message,attachments&access_token=";
  static const fbToken4 = baseFacebookUrl +
      "273625502788625/feed?fields=full_picture,id,story,created_time,message,attachments&access_token=";
  static const fbToken5 = baseFacebookUrl +
      "101038505785314/feed?fields=full_picture,id,story,created_time,message,attachments&access_token=";

  ///complaints
  static const getComplaintsLevel = _baseUrl + "complaint/getComittee.php";
  static const getComplaintsCandidatesNomination =
      _baseUrl + "complaint/getNomination.php";
  static const addComplaint = _baseUrl + "complaint/addComplaint.php";
  static const getComplaintsPaymentStatus =
      _baseUrl + "complaint/checkPayment.php";
  static const getMemberDetails = _baseUrl + "complaint/getMemberDetails.php";

  /// ro
  static const roDetails = _baseUrl + "ro/getRODetails.php";
  static const roSearchMember = _baseUrl + "ro/searchMember.php";
  static const roStats = _baseUrl + "ro/roStats.php";
  static const roPaymentStatus = _baseUrl + "ro/checkPaymentStatus.php";
  static const roGetNomination = _baseUrl + "ro/getNomination.php";
  static const roGetAM = _baseUrl + "ro/getAM.php";
  static const roUpdateNominationStatus =
      _baseUrl + "ro/updateNominationStatus.php";
  static const roUpdateMemberStatus = _baseUrl + "ro/updateROAMStatus.php";
  static const roEditNomination = _baseUrl + "ro/updateNominationData.php";

  /// yuva booth
  static const getYuvaUser = _baseUrl + "yuvaBooth/getYuvaUser.php";
  static const getYuvaUserNew = _baseUrl + "yuvaBooth/getYuvaUserNew.php";
  static const getAllYuvaUsers =
      _baseUrl + "yuvaBooth/getYuvaUserListByUser.php";
  static const getAllBoothJodos =
      _baseUrl + "yuvaBooth/getBoothJodoUserList.php";
  static const addYuvaUser = _baseUrl + "yuvaBooth/addYuvaUser.php";
  static const addAssignment = _baseUrl + "yuvaBooth/addAssignment.php";
  static const addYuvaUserNew = _baseUrl + "yuvaBooth/addYuvaUserNew.php";
  static const addYuvaDataMeeting = _baseUrl + "yuvaBooth/addYuvaData.php";
  static const addBoothData = _baseUrl + "yuvaBooth/addBoothUserDataNew.php";
  static const checkBoothJodoExist =
      _baseUrl + "yuvaBooth/checkBoothJodoMobile.php";
  static const checkInYuvaBooth = _baseUrl + "yuvaBooth/checkIn.php";
  static const getCheckInData = _baseUrl + "yuvaBooth/getCheckinData.php";
  static const boothJodoLeaderBoard =
      _baseUrl + "yuvaBooth/boothJodoLeaderBoard.php";
  static const boothJodoReports = _baseUrl + "yuvaBooth/getReport.php";

  /// common get otp - validate --- booth jodo
  static const initiateOutboundCall =
      _baseUrl + "auth/inititateOutboundCall.php";
  static const verifyOutboundCall = _baseUrl + "auth/verifyOutboundCall.php";
  static const getOtpCommon = _baseUrl + "auth/getOTP.php";
  static const validateOtpCommon = _baseUrl + "auth/validateOTP.php";
  static const getOtpBPYC = _baseUrl + "otpData.php";

  /// legal cell

  static const checkLegalCell = _baseUrl + "legalCell/checkAccess.php";
  static const getOtpLegalCell = _baseUrl + "legalCell/getOTP.php";
  static const verifyLegalCellMobile = _baseUrl + "legalCell/verifyOTP.php";
  static const getMembersLegalCell = _baseUrl + "legalCell/getMember.php";
  static const addMemberLegalCell = _baseUrl + "legalCell/addMember.php";

  /// unit management / ob access
  static const checkOBAccess = _baseUrl + "unitManagement/checkOBAccess.php";
  static const getStateOBUsers =
      _baseUrl + "unitManagement/getStateOBUsers.php";
  static const getVerifyEvent =
      _baseUrl + "unitManagement/getVerifierEvents.php";
  static const verifyEvent = _baseUrl + "unitManagement/verifyEvent.php";
  static const externalTraining =
      _baseUrl + "unitManagement/externalTraining.php";
  static const getDistrictOBUsers =
      _baseUrl + "unitManagement/getDistrictOBUsers.php";
  static const getAssemblyOBUsers =
      _baseUrl + "unitManagement/getAssemblyOBUsers.php";
  static const getDailyEvent = _baseUrl + "unitManagement/getDailyEvent.php";
  static const createEvent = _baseUrl + "unitManagement/createEvent.php";
  static const setRSVPEvent = _baseUrl + "unitManagement/rsvp.php";
  static const checkInEvent = _baseUrl + "unitManagement/eventCheckin.php";
  static const electionReport =
      _baseUrl + "unitManagement/report/getReportList.php";
  static const electionUnitReport =
      _baseUrl + "unitManagement/report/unitReport.php";

  /// task management
  static const getAuthPoints = _baseUrl + "auth/getStar.php";

  static const getTaskList = _baseUrl + "taskManagement/getTaskList.php";
  static const completeTask = _baseUrl + "taskManagement/completeTask.php";
  static const getUserPoints = _baseUrl + "taskManagement/getUserPoints.php";
  static const createTask = _baseUrl + "taskManagement/addTask.php";
  static const taskRating = _baseUrl + "taskManagement/rating.php";
  static const taskStar = _baseUrl + "taskManagement/getStar.php";
  static const taskDetails = _baseUrl + "taskManagement/getTaskDetails.php";
  static const taskProgress =
      _baseUrl + "taskManagement/getDailyTaskStatus.php";

  /// Door 2 Door campaign

  static const getCampaignList = _baseUrl + "d2d/getCampaignList.php";
  static const addCampaignData = _baseUrl + "d2d/addD2dDataNew.php";
  static const viewCampaignData = _baseUrl + "d2d/getD2DData.php";
  static const viewCampaignLeaderBoard = _baseUrl + "d2d/d2dLeaderBoard.php";
  static const getAssemblyCampaign = _baseUrl + "d2d/checkAssembly.php";
  static const campaignReports = _baseUrl + "d2d/getReport.php";

  /// Banner

  static const checkBannerAccess = _baseUrl + "banner/isBannerEnabled.php";
  static const getBanners = _baseUrl + "banner/getBanner.php";
  static const saveBannerInput = _baseUrl + "banner/saveBannerInput.php";

  /// votersList

  static const getVotersList = _baseUrl + "VoterList/voterSearch.php";
  static const getFamilyVotersList = _baseUrl + "VoterList/getVoterFamily.php";

  //Membership
  static const getNominationBallotdataList =
      _baseUrl + "aggregator/getNominations.php";

//Org_new_program
  static const orgViewProgram = _baseUrl + "chaloPanchayat/viewProgram.php";
  static const orgNewProCheckOBAccess =
      _baseUrl + "chaloPanchayat/checkOBAccess.php";
  static const orgAddProgramRedFlag =
      _baseUrl + "chaloPanchayat/addProgramFlag.php";
  static const orgProgVerificationByNOB =
      _baseUrl + "chaloPanchayat/addNOBProgramReview.php";
  static const orgViewProgramFlag =
      _baseUrl + "chaloPanchayat/viewProgramFlag.php";

//
  static const addProgramlink = _baseUrl + "chaloPanchayat/addProgramLink.php";
  static const addProgramAttendee =
      _baseUrl + "chaloPanchayat/addProgramAttendee.php";
//
  static const getStateLisNSUI = _baseUrl + "auth/getState.php";
  static const getDistrictLisNSUI = _baseUrl + "auth/getDistrict.php";
  static const getUniversityLisNSUI = _baseUrl + "auth/getUniversity.php";
  static const getCollegeLisNSUI = _baseUrl + "auth/getCollege.php";
}
