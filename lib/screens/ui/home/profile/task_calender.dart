import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:iyc/view_model/profile/inbox/task_calender_vm.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskCalender extends StatefulWidget {
  const TaskCalender({Key? key}) : super(key: key);

  @override
  State<TaskCalender> createState() => _TaskCalenderState();
}

class _TaskCalenderState extends State<TaskCalender> {
  @override
  void initState() {
    context.read<TaskCalenderVM>().getPageDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        centerTitle: true,
      ),
      body: Consumer<TaskCalenderVM>(
        builder: (_, model, __) => model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '   Rating: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      RatingBarIndicator(
                        rating: double.parse(model.starOfCurrentMonth),
                        itemCount: 7,
                        itemSize: 30.0,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all()),
                      child: TableCalendar(
                        onDaySelected: (date, _) {
                          model.onClickDate(
                              DateFormat('yyyy-MM-dd').format(date));
                        },
                        calendarBuilders: CalendarBuilders(
                          todayBuilder: (context, date, events) {
                            var d = DateFormat('yyyy-MM-dd').format(date);
                            if (model.ratings.keys.contains(d)) {
                              return Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: model.stringColorMap[model.ratings[d]],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }
                          },
                          defaultBuilder: (context, date, events) {
                            var d = DateFormat('yyyy-MM-dd').format(date);
                            // print(model.ratings.keys.contains(d));
                            if (model.ratings.keys.contains(d)) {
                              // print(d);
                              return Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: model.stringColorMap[model.ratings[d]],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        focusedDay: model.focusedDay,
                        firstDay: DateTime(DateTime.now().year, 1, 1),
                        lastDay: DateTime.now().add(Duration(days: 365)),
                        onPageChanged: (date) {
                          model.getCurrentMonthYear(
                              '${date.year}', '${date.month}');
                          print(date);
                          context
                              .read<TaskCalenderVM>()
                              .changeFocusedDay(context, date);
                        },
                        headerStyle: HeaderStyle(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            leftChevronIcon: Icon(Icons.arrow_back_ios_new),
                            rightChevronIcon: Icon(Icons.arrow_forward_ios),
                            titleCentered: true,
                            formatButtonVisible: false),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            dowTextFormatter: (date, locale) =>
                                DateFormat.E(locale).format(date)[0],
                            decoration:
                                const BoxDecoration(color: Colors.white)),
                        calendarStyle: CalendarStyle(
                          outsideDecoration:
                              const BoxDecoration(color: Colors.white),
                          rowDecoration:
                              const BoxDecoration(color: Colors.white),
                          defaultDecoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5)),
                          // selectedDecoration: BoxDecoration(
                          //     color: Colors.blue,
                          //     borderRadius: BorderRadius.circular(5)),
                          weekendDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.black, thickness: 1,),
                  SizedBox(
                    height: 20,
                  ),
                  model.selectedDateDetails == null
                      ? SizedBox()
                      : Row(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('  ${model.selectedDateDetails!['date']!.split('-')[2]}-${model.selectedDateDetails!['date']!.split('-')[1]}-${model.selectedDateDetails!['date']!.split('-')[0]}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
                                Text(
                                    '   Total Task: ${model.selectedDateDetails!['total_tasks']}', style: TextStyle(fontSize: 20),),
                                Text(
                                    '   Completed Task: ${model.selectedDateDetails!['completed_tasks']}', style: TextStyle(fontSize: 20, color: model.stringColorMap[model.selectedDateDetails!['date']]),),
                                Text(
                                  '   Percentage: ${((double.parse(model.selectedDateDetails!['completed_tasks']!)/double.parse(model.selectedDateDetails!['total_tasks']!))*100).toStringAsPrecision(2)}%',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                        ],
                      )
                ],
              ),
      ),
    );
  }
}
