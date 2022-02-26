import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class DatePickerOpportunity extends StatefulWidget {
  final Function(DateTime?) onDateSelected;
  final DateTime? initialDate;
  final bool errorFlag;
  final bool isExprireDate;
  DatePickerOpportunity({required this.onDateSelected, this.initialDate, required this.errorFlag, this.isExprireDate = false});

  @override
  _DatePickerOpportunityState createState() => _DatePickerOpportunityState();
}

class _DatePickerOpportunityState extends State<DatePickerOpportunity> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
         showDatePicker(
                    context: context,
                    initialDate: widget.initialDate??DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(DateTime.now().year + 2),
                    cancelText: 'CLEAR')
                .then((date) {
                    widget.onDateSelected(date);
              });
            
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
        //height: 50,
        width: widget.isExprireDate ? 152 :135,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (widget.initialDate == null && widget.errorFlag)
                  ? todoListActiveTab
                  : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: widget.initialDate != null || widget.errorFlag
                              ? widget.errorFlag
                                  ? todoListActiveTab
                                  : defaultDark
                              : defaultDark.withOpacity(0.5),
                  size: 19,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.initialDate != null
                              ? widget.isExprireDate ? 'Expiration date' : 'Event Date': '',
                    style: roboto700.copyWith(
                        fontSize: widget.initialDate != null ? 10 : 0,
                        color:  defaultDark.withOpacity(0.5)),
                  ),
                  Text(
                          widget.initialDate == null
                              ? widget.isExprireDate ? 'Expiration date' : 'Event Date'
                              : '${( widget.initialDate!.month)} / ${ widget.initialDate?.day} / ${ widget.initialDate?.year}',
                          style: roboto700.copyWith(
                              fontSize: 14,
                              color:  widget.initialDate != null || widget.errorFlag
                              ? widget.errorFlag
                                  ? todoListActiveTab
                                  : defaultDark
                              : defaultDark.withOpacity(0.5)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}