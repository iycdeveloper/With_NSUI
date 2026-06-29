import 'package:iyc/app/core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  Future<String> getSessionId() async {
    SharedPreferences pref =  await SharedPreferences.getInstance();
    return pref.get("session_id")?.toString() ?? "";
  }

  //6Z6DC/A7OeNy/ccu7SfAg0tMZzyWJGU/Z/yXX7Lw5r9zXjscBO4xBDs9Up0IIwAi
  //H6HN0dRJCSgvsbphM39qNQ==
  Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("on user id");
    return pref.get("user_id")?.toString() ?? "";
  }

  Future setSessionId(String sessionId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("session_id", sessionId);
  }

  Future setUserId(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("user_id", userId);
  }

  setRoleId(String roleId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("role_id", roleId);
  }

  Future<String> getRoleId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("on role id");
    return pref.get("role_id")?.toString() ?? "";
  }

  Future setTwitterAppId(String appId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("app_id", appId);
  }

  getTwitterAppId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("app_id")?.toString() ?? "";
  }

  Future setTwitterApiKey(String apiKey) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("api_key", apiKey);
  }

  getTwitterApiKey() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("api_key")?.toString() ?? "";
  }

  Future setTwitterApiKeySecret(String apiKeySecret) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("api_key_secret", apiKeySecret);
  }

  getTwitterApiKeySecret() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("api_key_secret")?.toString() ?? "";
  }

  Future setBearerToken(String BearerToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("bearer_token", BearerToken);
  }

  getBearerToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("bearer_token")?.toString() ?? "";
  }

  ///-----
  setSTCode(String stCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("st_code", stCode);
  }

  setWorkStateCode(String stCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("work_state_code", stCode);
  }

  Future<String> getSTCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("st_code")?.toString() ?? "";
  }

  Future<String> getWorkStateCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("work_state_code")?.toString() ?? "";
  }

  setDisCode(String disCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("dis_code", disCode);
  }

  Future<String> getDisCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("dis_code")?.toString() ?? "";
  }

  setAssemblyCode(String disCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("assembly_code", disCode);
  }

  Future<String> getAssemblyCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("assembly_code")?.toString() ?? "";
  }

  setUserProfileName(String fullName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("user_full_name", fullName);
  }

  Future<String> getUserProfileName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("user_full_name")?.toString() ?? "";
  }

  setAggrIDForMembership(String agrCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("MEMBERSHIP_AGGR_ID", agrCode);
  }

  Future<String> getAgrIDMembership() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("MEMBERSHIP_AGGR_ID")?.toString() ?? "";
  }

  setBatchID(String batchID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("BATCH_NO", batchID);
  }

  Future<String> getBatchID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("BATCH_NO")?.toString() ?? "";
  }

  setScrutinyAgrID(String agrCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("SCRUTINY_AGGR_ID", agrCode);
  }

  Future<String> getScrutinyAgrID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("SCRUTINY_AGGR_ID")?.toString() ?? "";
  }

  Future setDobStartRange(String dateData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("dob_start_range", dateData);
  }

  getDobStartRange() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("dob_start_range")?.toString() ?? "";
  }

  Future setDobEndRange(String dateData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("dob_end_range", dateData);
  }

  getDobEndRange() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("dob_end_range")?.toString() ?? "";
  }

  setNominationAgrID(String agrCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("NOMINATION_AGGR_ID", agrCode);
  }

  Future<String> getNominationAgrID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("NOMINATION_AGGR_ID")?.toString() ?? "";
  }

  setInitMemberStatus(String code) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("is_membership_initial_time", code);
  }

  Future<String> getInitMemberStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("is_membership_initial_time")?.toString() ?? "";
  }

  setInitNominationStatus(String code) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("init_nomination_status", code);
  }

  Future<String> getInitNominationStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("init_nomination_status")?.toString() ?? "";
  }

  setMobile(String mobile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("user_mobile_number", mobile);
  }

  Future<String> getMobile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("user_mobile_number")?.toString() ?? "";
  }

  Future<String> getPaymentMerchantId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("payment_merchant_id")?.toString() ?? "";
  }

  Future<String> getPaymentAccessCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("payment_access_token")?.toString() ?? "";
  }

  Future setSelectedParliamentVoterSearch(String parliament) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("voter_search_parliament", parliament);
  }

  Future<String> getSelectedParliamentVoterSearch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("voter_search_parliament")?.toString() ?? "";
  }

  Future setSelectedParliamentEnglishVoterSearch(String parliament) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("voter_search_parliament_name_english", parliament);
  }

  Future<String> getSelectedParliamentEnglishVoterSearch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("voter_search_parliament_name_english")?.toString() ?? "";
  }

  Future setSelectedParliamentLocalLangVoterSearch(String parliament) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("voter_search_parliament_name_local", parliament);
  }

  Future<String> getSelectedParliamentLocalLangVoterSearch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("voter_search_parliament_name_local")?.toString() ?? "";
  }

  Future setSelectedAssemblyVoterSearch(String assembly) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("voter_search_assembly", assembly);
  }

  Future<String> getSelectedAssemblyVoterSearch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("voter_search_assembly")?.toString() ?? "";
  }

  Future setSelectedAssemblyEnglishVoterSearch(String assembly) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("voter_search_assembly_name_english", assembly);
  }

  Future<String> getSelectedAssemblyEnglishVoterSearch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("voter_search_assembly_name_english")?.toString() ?? "";
  }

  Future setSelectedAssemblyLocalLangVoterSearch(String assembly) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("voter_search_assembly_name_local", assembly);
  }

  Future<String> getSelectedAssemblyLocalLangVoterSearch() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("voter_search_assembly_name_local")?.toString() ?? "";
  }

  Future<Future<bool>> setCgCampaignSelectedLang(String lang) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("cg_campaign_default_lang", lang);
  }

  Future<String> getCgCampaignSelectedLang() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("cg_campaign_default_lang")?.toString() ?? "";
  }

  Future<Future<bool>> setTlCampaignSelectedLang(String lang) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("tl_campaign_default_lang", lang);
  }

  Future<String> getTlCampaignSelectedLang() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get("tl_campaign_default_lang")?.toString() ?? "";
  }
}
