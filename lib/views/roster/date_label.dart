import 'package:agonistica/core/utils/my_date_utils.dart';
import 'package:flutter/material.dart';

class DateLabel extends StatefulWidget {

  final DateTime birthDay;
  final bool isEditEnabled;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function(DateTime)? onDateChange;

  DateLabel({
    required this.birthDay,
    required this.isEditEnabled,
    this.fontColor,
    this.fontSize,
    this.fontWeight,
    this.onDateChange,
  });

  @override
  State<StatefulWidget> createState() => _DateLabelState();

}

class _DateLabelState extends State<DateLabel> {

  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.birthDay;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.isEditEnabled) {
          DateTime curDate = DateTime.now();
          await showDatePicker(
              context: context,
              initialDate: widget.birthDay,
              firstDate: DateTime.utc(
                  curDate.year - 50),
              lastDate: DateTime.utc(
                  curDate.year + 1),
              initialDatePickerMode: DatePickerMode
                  .day,
              helpText: "Seleziona la data di nascita"
          ).then((date) {
            if (date != null)
              setState(() {
                dateTime = date;
              });
          });
        }
      },
      child: Text(
        "${dateTime.day} ${MyDateUtils
            .monthToString(
            dateTime.month).substring(
            0, 3)} ${dateTime.year}",
        textAlign: TextAlign.end,
        style: TextStyle(
          color: widget.fontColor,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),
      ),
    );
  }

}