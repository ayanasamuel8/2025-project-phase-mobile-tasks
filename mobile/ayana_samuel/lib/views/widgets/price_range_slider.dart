import 'package:flutter/material.dart';

class PriceRangeSlider extends StatelessWidget {
  const PriceRangeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PriceRangeScreen());
  }
}

class PriceRangeScreen extends StatefulWidget {
  @override
  _PriceRangeScreenState createState() => _PriceRangeScreenState();
}

class _PriceRangeScreenState extends State<PriceRangeScreen> {
  RangeValues _selectedRange = RangeValues(100, 1000);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          rangeThumbShape: RoundRangeSliderThumbShape(
            enabledThumbRadius: 4, // Smaller thumb size
            elevation: 0,
          ),
          thumbColor: Colors.white, // Set thumb color here
        ),
        child: RangeSlider(
          values: _selectedRange,
          min: 0.0,
          max: 5000,
          divisions: 100,
          onChanged: (RangeValues values) {
            setState(() {
              _selectedRange = values;
            });
          },
        ),
      ),
    );
  }
}
