import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/screens/ui/home/ob/create_event/create_event.dart';
import 'package:iyc/screens/ui/home/ob/event_details.dart';
import 'package:iyc/screens/ui/home/ob/verify_events.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/ob/create_event/create_event_vm.dart';
import 'package:iyc/view_model/ob/create_event/verify_event_vm.dart';
import 'package:iyc/view_model/ob/events_vm.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    context.read<EventsVM>().getEventsList(context);
    context.read<EventsVM>().checkObAccess(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventsVM>(
        builder: (_, model, __) => model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text("Programs"),
                  centerTitle: true,
                  actions: [
                    InkWell(
                        onTap: () async {
                          await toPage(
                          context,
                          ChangeNotifierProvider(
                              create: (context) => VerifyEventVM(),
                              child: VerifyEvent()));
                        },
                        child: Center(
                            child: Text('Verify  ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)))
                  ],
                ),
                floatingActionButton: !model.showObAccess
                    ? SizedBox()
                    : FloatingActionButton(
                        key: const Key('increment_floatingActionButton'),
                        onPressed: () async {
                          final result = await toPage(
                              context,
                              ChangeNotifierProvider(
                                  create: (context) => CreateEventVM(),
                                  child: CreateEvent()));
                          if (result != null && result)
                            context.read<EventsVM>().getEventsList(context);
                        },
                        tooltip: 'Increment',
                        child: const Icon(Icons.add),
                      ),
                body: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                        //height: 400,
                        child: Container(
                          // height: 150,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all()),
                          child: TableCalendar(
                            focusedDay: model.focusedDay,
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now().add(Duration(days: 365)),
                            selectedDayPredicate: (day) {
                              // Use `selectedDayPredicate` to determine which day is currently selected.
                              // If this returns true, then `day` will be marked as selected.

                              // Using `isSameDay` is recommended to disregard
                              // the time-part of compared DateTime objects.
                              return isSameDay(model.selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              if (!isSameDay(model.selectedDay, selectedDay)) {
                                context.read<EventsVM>().changeSelectedDay(
                                    context, selectedDay, focusedDay);
                                // Call `setState()` when updating the selected day
                              }
                            },
                            onPageChanged: (focusedDay) {
                              // No need to call `setState()` here
                              context
                                  .read<EventsVM>()
                                  .changeFocusedDay(context, focusedDay);
                            },
                            headerStyle: HeaderStyle(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                leftChevronIcon: Container(),
                                formatButtonVisible: false),
                            daysOfWeekStyle: DaysOfWeekStyle(
                                dowTextFormatter: (date, locale) =>
                                    DateFormat.E(locale).format(date)[0],
                                decoration:
                                    const BoxDecoration(color: Colors.white)),
                            calendarStyle: CalendarStyle(
                              todayTextStyle: const TextStyle(),
                              todayDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5)),
                              outsideDecoration:
                                  const BoxDecoration(color: Colors.white),
                              rowDecoration:
                                  const BoxDecoration(color: Colors.white),
                              defaultDecoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5)),
                              selectedDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5)),
                              weekendDecoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      model.eventList.isEmpty
                          ? Center(
                              child: Text(
                                  "No events found for ${DateFormat("dd-MM-yyyy").format(model.selectedDay!)}"),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    boxShadow: [BoxShadow()],
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: ListTile(
                                  title: Text(model.eventList[index].eventName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  subtitle: Text(
                                    model.eventList[index].eventDateTime,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                  onTap: () {
                                    toPage(
                                        context,
                                        EventDetails(
                                          event: model.eventList[index],
                                        ));
                                  },
                                ),
                              ),
                              itemCount: model.eventList.length,
                            )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
