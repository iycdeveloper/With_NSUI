import 'package:flutter/cupertino.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/repository/task_management_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';

class TaskCreateVM extends ChangeNotifier {
  TextEditingController descController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController pointController = TextEditingController();
  TextEditingController d2dController = TextEditingController();
  TextEditingController bjController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode descFocus = FocusNode();
  final FocusNode urlFocus = FocusNode();
  final FocusNode pointFocus = FocusNode();
  final FocusNode d2dFocus = FocusNode();
  final FocusNode bjFocus = FocusNode();

  GlobalKey _dropdownButtonKey = GlobalKey();
  get dropdownButtonKey => _dropdownButtonKey;

  States? selectedState;
  bool isEditMode = false;
  List<States>? stateList;
  UserDetail? userDetail;
  String? selectedCategory;
  String? selectedType;
  String? selectedPriority;
  String? selectedStartDate;
  String? selectedEndDate;
  String? selectedPoint;
  String? showStartDate;
  String? showEndDate;
  String? selectedUrl;
  String d2d = '0';
  String bj = '0';

  List<DropdownItem> points = [];

  List<DropdownItem> category = [
    DropdownItem("GROUND", "GROUND"),
    DropdownItem("SOCIAL", "SOCIAL"),
    DropdownItem("GENERAL", "GENERAL")
  ];

  List<DropdownItem> priority = [
    DropdownItem("NORMAL", "NORMAL"),
    DropdownItem("URGENT", "URGENT"),
  ];

  List<DropdownItem> type = [
    // DropdownItem("TEXT", "TEXT"),
    DropdownItem("CAMERA", "CAMERA"),
    DropdownItem("PHOTO", "PHOTO"),
    DropdownItem("AUDIO", "AUDIO"),
    DropdownItem("VIDEO", "VIDEO"),
    DropdownItem("UPLOAD", "UPLOAD"),
    DropdownItem("DATE", "DATE"),
    DropdownItem("D2D", "D2D"),
    DropdownItem("BJ", "BJ"),
  ];

  getStatesList() async {
    stateList = await DbServices.db.getAllStates(true);
    if (isEditMode) {
      selectedState = stateList!
          .firstWhere((element) => element.stateCode == userDetail!.stateCode);
      print(selectedState!.stateCode);
      // getDistrictList();
    }
    notifyListeners();
  }

  populatePoints() async {
    for(int i = 1;i<51;i++){
      points.add(DropdownItem("$i", "$i"));
    }
  }

  changeSelectedState(States state) {
    selectedState = state;
    notifyListeners();
  }

  changeCategory(String val) {
    selectedCategory = val;
    notifyListeners();
  }

  changeStartDate(DateTime timeData) {
    selectedStartDate = "${timeData.year}-0${timeData.month}-${timeData.day}";
    showStartDate = "${timeData.day}-0${timeData.month}-${timeData.year}";
    notifyListeners();
  }

  changeEndDate(DateTime timeData) {
    selectedEndDate = "${timeData.year}-0${timeData.month}-${timeData.day}";
    showEndDate = "${timeData.day}-0${timeData.month}-${timeData.year}";
    notifyListeners();
  }

  changeType(String val) {
    selectedType = val;
    notifyListeners();
  }

  changePriority(String val) {
    selectedPriority = val;
    notifyListeners();
  }

  changePoint(String val) {
    selectedPoint = val;
    notifyListeners();
  }

  changeUrl(String val) {
    selectedUrl = val;
    notifyListeners();
  }

  refresh() {
    selectedState = null;
    notifyListeners();
  }

  bool validateForm(BuildContext context){
    bool pageValidation = true;
    final formValidated = formKey.currentState?.validate();
    if(d2dController.text.isNotEmpty){
      d2d = d2dController.text;
    }
    if(bjController.text.isNotEmpty){
      bj = bjController.text;
    }
    if(urlController.text.isNotEmpty){
      selectedUrl = urlController.text;
    }

    if(urlController.text.isEmpty){
      selectedUrl = '';
    }
    if(selectedState == null){
      showCustomSnackBar("Select Home State", context);
      pageValidation = false;
    }
    if(selectedType == null){
      showCustomSnackBar("Select task Type", context);
      pageValidation = false;
    }
    if(selectedCategory == null){
      showCustomSnackBar("Select Task Category", context);
      pageValidation = false;
    }
    if(selectedPriority == null){
      showCustomSnackBar("Select task priority", context);
      pageValidation = false;
    }
    if(selectedStartDate == null){
      showCustomSnackBar("Select Task Start Date", context);
      pageValidation = false;
    }
    if(selectedEndDate == null){
      showCustomSnackBar("Select Task End Date", context);
      pageValidation = false;
    }
    return pageValidation && formValidated!;
  }

  createTask(BuildContext context) async {
    // ApiResponse apiResponse =
    // await TaskManagementRepo()
    //     .createTask(selectedType!,
    //     descController.text,
    //     pointController.text,
    //     selectedStartDate!,
    //     selectedEndDate!,
    //     selectedState!.stateCode,
    //     selectedPriority!,
    //   d2d,
    //   bj,
    //   selectedUrl!,
    //   selectedCategory!
    // );
    // showCustomSnackBar("Task Created", context);
    // Navigator.pop(context);
    // .then((value){
    //
    // });
  }
}
