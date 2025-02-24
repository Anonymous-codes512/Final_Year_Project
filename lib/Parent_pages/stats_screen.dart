import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatefulWidget {
  final String gameName;
  final Color gameColor;

  const StatsScreen({
    super.key,
    required this.gameName,
    required this.gameColor,
  });

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int selectedIndex = 2; // Default to 'Year'
  final List<String> filters = ['Week', 'Month', 'Year'];

  // Generates some sample bar chart data.
  List<BarChartGroupData> _generateBars() {
    List<int> data = [400, 450, 500, 600, 900, 700];
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
              toY: data[index].toDouble(),
              color: widget.gameColor,
              width: 20,
              borderRadius: BorderRadius.circular(2)),
        ],
      );
    });
  }

  // Builds the full-width toggle bar with shadow.
  Widget _buildToggleBar() {
    return SizedBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double buttonWidth =
              (constraints.maxWidth / filters.length).floorToDouble();
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFEAE8E8),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ToggleButtons(
              constraints:
                  BoxConstraints.tightFor(width: buttonWidth - 5, height: 50),
              isSelected: List.generate(
                  filters.length, (index) => index == selectedIndex),
              onPressed: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor: Colors.teal,
              color: Colors.black,
              children: filters
                  .map(
                    (text) => Center(
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  // Builds a container that covers 50% of the screen height and holds a BarChart.
  Widget _buildGraphContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Color(0xFFEAE8E8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          backgroundColor: Color(0xFFEAE8E8),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  List<String> months = [
                    'DEC',
                    'JAN',
                    'FEB',
                    'MAR',
                    'APR',
                    'MAY'
                  ];
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(color: Colors.black),
                  );
                },
              ),
            ),
          ),
          barGroups: _generateBars(),
        ),
      ),
    );
  }

  // Stats row at the bottom.
  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatColumn('REDUCTION', '135', '30 December',
            const Color.fromARGB(255, 75, 30, 76)),
        _buildStatColumn('BALANCE', '500', '', Colors.yellow),
        _buildStatColumn('ADDITION', '907', '4 April', Colors.redAccent),
      ],
    );
  }

  Widget _buildStatColumn(
      String title, String value, String date, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (date.isNotEmpty)
          Text(
            date,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: widget.gameColor,
        title: Text(
          '${widget.gameName} Analytics',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          // Use a minimum height constraint instead of a fixed height.
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.gameColor.withOpacity(0.4),
                widget.gameColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Full-width toggle bar with shadow.
              _buildToggleBar(),
              const SizedBox(height: 20),
              // First graph container (50% of screen height).
              _buildGraphContainer(),
              const SizedBox(height: 20),
              // Second graph container (also 50% of screen height).
              _buildGraphContainer(),
              const SizedBox(height: 20),
              _buildStatsRow(),
            ],
          ),
        ),
      ),
    );
  }
}
