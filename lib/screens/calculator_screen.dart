import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../widgets/calc_button.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  static const Color darkGray = Color(0xFF333333);
  static const Color lightGray = Color(0xFFA5A5A5);
  static const Color orange = Color(0xFFFF9F0A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calc = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    final bool showC = calc.display != '0';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double gap = 12;
            const double sidePadding = 16;
            final double calculatorWidth = math.min(
              constraints.maxWidth,
              500,
            );

            return Center(
              child: SizedBox(
                width: calculatorWidth,
                child: LayoutBuilder(
                  builder: (context, calculatorConstraints) {
                    final double widthButtonSize =
                        (calculatorConstraints.maxWidth - sidePadding * 2 - gap * 3) /
                            4;
                    final double heightButtonSize =
                        (calculatorConstraints.maxHeight - 16 - gap * 4) / 5;
                    final double buttonSize = math.max(
                      0,
                      math.min(widthButtonSize, heightButtonSize),
                    );

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        sidePadding,
                        0,
                        sidePadding,
                        16,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomRight,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  calc.display,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 88,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CalcButton(
                                  text: showC ? 'C' : 'AC',
                                  height: buttonSize,
                                  color: lightGray,
                                  textColor: Colors.black,
                                  onTap: () {
                                    if (showC) {
                                      notifier.clear();
                                    } else {
                                      notifier.allClear();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: gap),
                              Expanded(
                                child: CalcButton(
                                  text: '+/-',
                                  height: buttonSize,
                                  color: lightGray,
                                  textColor: Colors.black,
                                  onTap: () => notifier.toggleSign(),
                                ),
                              ),
                              const SizedBox(width: gap),
                              Expanded(
                                child: CalcButton(
                                  text: '%',
                                  height: buttonSize,
                                  color: lightGray,
                                  textColor: Colors.black,
                                  onTap: () => notifier.percent(),
                                ),
                              ),
                              const SizedBox(width: gap),
                              Expanded(
                                child: operationButton('÷', calc, notifier, buttonSize),
                              ),
                            ],
                          ),
                          const SizedBox(height: gap),
                          Row(
                            children: [
                              Expanded(child: digitButton('7', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(child: digitButton('8', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(child: digitButton('9', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(
                                child: operationButton('×', calc, notifier, buttonSize),
                              ),
                            ],
                          ),
                          const SizedBox(height: gap),
                          Row(
                            children: [
                              Expanded(child: digitButton('4', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(child: digitButton('5', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(child: digitButton('6', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(
                                child: operationButton('-', calc, notifier, buttonSize),
                              ),
                            ],
                          ),
                          const SizedBox(height: gap),
                          Row(
                            children: [
                              Expanded(child: digitButton('1', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(child: digitButton('2', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(child: digitButton('3', notifier, buttonSize)),
                              const SizedBox(width: gap),
                              Expanded(
                                child: operationButton('+', calc, notifier, buttonSize),
                              ),
                            ],
                          ),
                          const SizedBox(height: gap),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CalcButton(
                                  text: '0',
                                  height: buttonSize,
                                  color: darkGray,
                                  textColor: Colors.white,
                                  wide: true,
                                  onTap: () => notifier.inputDigit('0'),
                                ),
                              ),
                              const SizedBox(width: gap),
                              Expanded(
                                child: CalcButton(
                                  text: ',',
                                  height: buttonSize,
                                  color: darkGray,
                                  textColor: Colors.white,
                                  onTap: () => notifier.inputDot(),
                                ),
                              ),
                              const SizedBox(width: gap),
                              Expanded(
                                child: CalcButton(
                                  text: '=',
                                  height: buttonSize,
                                  color: orange,
                                  textColor: Colors.white,
                                  onTap: () => notifier.calculateResult(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget digitButton(String digit, CalculatorNotifier notifier, double size) {
    return CalcButton(
      text: digit,
      height: size,
      color: darkGray,
      textColor: Colors.white,
      onTap: () => notifier.inputDigit(digit),
    );
  }

  Widget operationButton(
    String op,
    CalculatorState calc,
    CalculatorNotifier notifier,
    double size,
  ) {
    final bool active = calc.operation == op && calc.waitingSecond;

    return CalcButton(
      text: op,
      height: size,
      color: active ? Colors.white : orange,
      textColor: active ? orange : Colors.white,
      onTap: () => notifier.inputOperation(op),
    );
  }
}
