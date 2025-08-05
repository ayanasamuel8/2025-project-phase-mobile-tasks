import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:ecommerce_app/features/products/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsBloc extends MockBloc<ProductsEvent, ProductsState>
    implements ProductsBloc {}

void main() {
  late ProductsBloc mockProductsBloc;

  setUp(() {
    mockProductsBloc = MockProductsBloc();
  });

  // A helper function to build the widget with the mock BLoC
  Future<void> pumpWidget(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductsBloc>.value(
          value: mockProductsBloc,
          child: const HomePage(),
        ),
      ),
    );
  }

  group('HomePage Tests', () {
    testWidgets(
      'renders correctly and shows available products text when state is LoadedAllProductsState',
      (WidgetTester tester) async {
        // Arrange: Set up the initial state of the BLoC before the widget is built.
        when(
          () => mockProductsBloc.state,
        ).thenReturn(const LoadedAllProductsState([]));

        // Act
        await pumpWidget(tester);
        await tester
            .pump(); // Pump a frame for the UI to build with the initial state.

        // Assert
        expect(find.text('Available Products'), findsOneWidget);
      },
    );

    testWidgets('shows a loading indicator when state is InitialState', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockProductsBloc.state).thenReturn(LoadingState());

      // Act
      await pumpWidget(tester);
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
