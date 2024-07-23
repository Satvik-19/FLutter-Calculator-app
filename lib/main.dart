import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool isDarkMode = false;
  String _output = '';
  String _input = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _output = '';
        _input = '';
      } else if (buttonText == '=') {
        try {
          _output = _evaluateExpression(_input);
          _input = _output;
        } catch (e) {
          _output = 'Error';
        }
      } else if (buttonText == '⌫') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          _output = _input;
        }
      } else {
        _input += buttonText;
        _output = _input;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      if (result == result.roundToDouble()) {
        return result.round().toString();
      } else {
        return result.toStringAsFixed(2);
      }
    } catch (e) {
      return 'Error';
    }
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _input,
                        style: TextStyle(fontSize: 24, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _output,
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              CalculatorButtonGrid(onButtonPressed: _onButtonPressed, toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorButtonGrid extends StatelessWidget {
  final Function(String) onButtonPressed;
  final Function() toggleTheme;
  final bool isDarkMode;

  CalculatorButtonGrid({required this.onButtonPressed, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalculatorButton(text: '', icon: isDarkMode ? Icons.light_mode : Icons.dark_mode, onPressed: toggleTheme, isSpecial: true),
              CalculatorButton(text: '%', onPressed: () => onButtonPressed('%'), isSpecial: true),
              CalculatorButton(text: '÷', onPressed: () => onButtonPressed('÷'), isSpecial: true),
              CalculatorButton(text: '', icon: Icons.backspace_outlined, onPressed: () => onButtonPressed('⌫'), isSpecial: true),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalculatorButton(text: '7', onPressed: () => onButtonPressed('7')),
              CalculatorButton(text: '8', onPressed: () => onButtonPressed('8')),
              CalculatorButton(text: '9', onPressed: () => onButtonPressed('9')),
              CalculatorButton(text: '×', onPressed: () => onButtonPressed('×'), isSpecial: true),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalculatorButton(text: '4', onPressed: () => onButtonPressed('4')),
              CalculatorButton(text: '5', onPressed: () => onButtonPressed('5')),
              CalculatorButton(text: '6', onPressed: () => onButtonPressed('6')),
              CalculatorButton(text: '-', onPressed: () => onButtonPressed('-'), isSpecial: true),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalculatorButton(text: '1', onPressed: () => onButtonPressed('1')),
              CalculatorButton(text: '2', onPressed: () => onButtonPressed('2')),
              CalculatorButton(text: '3', onPressed: () => onButtonPressed('3')),
              CalculatorButton(text: '+', onPressed: () => onButtonPressed('+'), isSpecial: true),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CalculatorButton(text: 'AC', onPressed: () => onButtonPressed('AC'), isAC: true),
              CalculatorButton(text: '0', onPressed: () => onButtonPressed('0')),
              CalculatorButton(text: '.', onPressed: () => onButtonPressed('.')),
              CalculatorButton(text: '=', isEqual: true, onPressed: () => onButtonPressed('=')),
            ],
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isEqual;
  final bool isSpecial;
  final bool isAC;
  final IconData? icon;

  CalculatorButton({
    required this.text,
    required this.onPressed,
    this.isEqual = false,
    this.isSpecial = false,
    this.isAC = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;

    Color getButtonColor() {
      if (isEqual) return Colors.pink;
      if (isAC) return isLightMode ? Colors.pink.withOpacity(0.2) : Colors.orange.withOpacity(0.2);
      if (isSpecial) return isLightMode ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.4);
      return isLightMode ? Colors.white : Colors.grey[800]!;
    }

    Color getTextColor() {
      if (isEqual) return Colors.white;
      if (isAC) return isLightMode ? Colors.pink : Colors.orange;
      if (isSpecial) return isLightMode ? Colors.black : Colors.white;
      return isLightMode ? Colors.black : Colors.white;
    }

    return Container(
      width: 70,
      height: 70,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: isEqual ? BorderRadius.circular(35) : BorderRadius.circular(35),
          child: Ink(
            decoration: BoxDecoration(
              color: getButtonColor(),
              borderRadius: isEqual ? BorderRadius.circular(35) : BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: getButtonColor().withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, color: getTextColor(), size: 24)
                  : Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: getTextColor(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}