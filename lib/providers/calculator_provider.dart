import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorState {
  final String display;
  final double? firstNumber;
  final String? operation;
  final bool waitingSecond;

  const CalculatorState({
    this.display = '0',
    this.firstNumber,
    this.operation,
    this.waitingSecond = false,
  });

  CalculatorState copyWith({
    String? display,
    double? firstNumber,
    String? operation,
    bool? waitingSecond,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      firstNumber: firstNumber ?? this.firstNumber,
      operation: operation ?? this.operation,
      waitingSecond: waitingSecond ?? this.waitingSecond,
    );
  }
}

class CalculatorNotifier extends Notifier<CalculatorState> {
  @override
  CalculatorState build() {
    return const CalculatorState();
  }

  void inputDigit(String digit) {
    if (state.display == 'Ошибка') {
      state = CalculatorState(display: digit);
      return;
    }

    if (state.waitingSecond) {
      state = state.copyWith(display: digit, waitingSecond: false);
      return;
    }

    if (state.display == '0') {
      state = state.copyWith(display: digit);
      return;
    }

    if (state.display.replaceAll('-', '').replaceAll('.', '').length >= 9) {
      return;
    }

    state = state.copyWith(display: state.display + digit);
  }

  void inputDot() {
    if (state.display == 'Ошибка') {
      state = const CalculatorState(display: '0.');
      return;
    }

    if (state.waitingSecond) {
      state = state.copyWith(display: '0.', waitingSecond: false);
      return;
    }

    if (state.display.contains('.')) {
      return;
    }

    state = state.copyWith(display: '${state.display}.');
  }

  void inputOperation(String op) {
    if (state.display == 'Ошибка') {
      return;
    }

    double current = double.parse(state.display);

    if (state.firstNumber != null &&
        state.operation != null &&
        !state.waitingSecond) {
      double? result = _calculate(state.firstNumber!, current, state.operation!);

      if (result == null) {
        state = const CalculatorState(display: 'Ошибка');
        return;
      }

      state = CalculatorState(
        display: _format(result),
        firstNumber: result,
        operation: op,
        waitingSecond: true,
      );
      return;
    }

    state = CalculatorState(
      display: state.display,
      firstNumber: current,
      operation: op,
      waitingSecond: true,
    );
  }

  void calculateResult() {
    if (state.firstNumber == null ||
        state.operation == null ||
        state.display == 'Ошибка') {
      return;
    }

    final double current;
    try {
      current = double.parse(state.display);
    } catch (_) {
      state = const CalculatorState(display: 'Ошибка');
      return;
    }

    final double? result = _calculate(
      state.firstNumber!,
      current,
      state.operation!,
    );

    if (result == null) {
      state = const CalculatorState(display: 'Ошибка');
      return;
    }

    state = CalculatorState(display: _format(result));
  }

  void clear() {
    state = CalculatorState(
      display: '0',
      firstNumber: state.firstNumber,
      operation: state.operation,
    );
  }

  void allClear() {
    state = const CalculatorState();
  }

  void toggleSign() {
    if (state.display == 'Ошибка' || state.display == '0') {
      return;
    }

    if (state.display.startsWith('-')) {
      state = state.copyWith(display: state.display.substring(1));
    } else {
      state = state.copyWith(display: '-${state.display}');
    }
  }

  void percent() {
    if (state.display == 'Ошибка') {
      return;
    }

    double current = double.parse(state.display);
    state = state.copyWith(display: _format(current / 100));
  }

  double? _calculate(double a, double b, String op) {
    if (op == '+') {
      return a + b;
    }
    if (op == '-') {
      return a - b;
    }
    if (op == '×') {
      return a * b;
    }
    if (op == '÷') {
      if (b == 0) {
        return null;
      }
      return a / b;
    }
    return null;
  }

  String _format(double value) {
    if (value == value.truncateToDouble() && value.abs() < 1000000000) {
      return value.toInt().toString();
    }

    String text = value.toStringAsFixed(8);

    if (text.contains('.')) {
      while (text.endsWith('0')) {
        text = text.substring(0, text.length - 1);
      }
      if (text.endsWith('.')) {
        text = text.substring(0, text.length - 1);
      }
    }

    if (text.length > 10) {
      return value.toStringAsExponential(3);
    }

    return text;
  }
}

final calculatorProvider =
    NotifierProvider<CalculatorNotifier, CalculatorState>(() {
  return CalculatorNotifier();
});
