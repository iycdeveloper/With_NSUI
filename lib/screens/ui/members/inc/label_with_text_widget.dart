import 'package:flutter/material.dart';

class LabelWithTextWidget extends StatelessWidget {
  final String label;
  final String text;
  const LabelWithTextWidget(
      {Key? key, required String label, required String text})
      : this.label = label,
        this.text = text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Container(
            child: InputDecorator(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.primaries[5].shade700),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
              ),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}
