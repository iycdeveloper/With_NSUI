import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/membership/banner/question.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/screens/widgets/button/iyc_icon_button.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/view_model/membership/banner/bannerpage_vm.dart';
import 'package:provider/provider.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  @override
  void initState() {
    context.read<BannerPageVM>().getBannerList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Consumer<BannerPageVM>(builder: (_, model, __) {
            if (model.loadingPage) return NetworkLoading();
            return Column(
              children: [
                Image.network(
                  model.questionList.first.imageLink,
                  height: height * 0.55,
                  fit: BoxFit.contain,
                ),
                ...List.generate(
                    2,
                    (index) => QuestionCard(
                          question: model.questionList[index],
                          currentValue:
                              model.selectedAnswerList["question_${index + 1}"],
                          onChanged: (answer) {
                            context.read<BannerPageVM>().onChangeAnswer(
                                  model.questionList[index],
                                  index + 1,
                                  answer,
                                );
                          },
                          onChangedCB: (isChecked, item) => context
                              .read<BannerPageVM>()
                              .onChangeAnswer(model.questionList[index],
                                  index + 1, isChecked,
                                  cbName: item),
                        )),
                SizedBox(
                    width: 200,
                    child: IycIconButton(
                        title: "Submit",
                        onTap: () {
                          if (context
                              .read<BannerPageVM>()
                              .validateForm(context)) {
                            context.read<BannerPageVM>().submit(context);
                          }
                        }))
              ],
            );
          }),
        ));
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard(
      {Key? key,
      required this.question,
      required this.currentValue,
      required this.onChanged,
      this.onChangedCB})
      : super(key: key);

  final Question question;
  final dynamic currentValue;
  final Function(dynamic v) onChanged;
  final Function(dynamic isChecked, dynamic name)? onChangedCB;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        if (question.questionType == "DD")
          DropDownPicker(
            currentValue: currentValue,
            listValues:
                question.answers.map((e) => DropdownItem(e, e)).toList(),
            onChanged: onChanged,
            labelText: question.question,
            hintText: 'Pick one answer',
          ),
        if (question.questionType == "CB")
          Container(
            margin: EdgeInsets.only(left: 20, top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              question.question,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        if (question.questionType == "CB")
          ListBody(
            children: question.answers
                .map((e) => CheckboxListTile(
                      value: currentValue.contains(e),
                      onChanged: (val) => onChangedCB!(val, e),
                      title: Text(e),
                      controlAffinity: ListTileControlAffinity.leading,
                    ))
                .toList(),
          )
      ]),
    );
  }
}
