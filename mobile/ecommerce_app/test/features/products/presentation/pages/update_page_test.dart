import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:ecommerce_app/features/products/presentation/pages/update_page.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'add_page_test.dart';

class MockProductsBloc extends MockBloc<ProductsEvent, ProductsState>
    implements ProductsBloc {}

void main() {
  late ProductsBloc mockProductsBloc;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockProductsBloc = MockProductsBloc();
    mockNavigatorObserver = MockNavigatorObserver();
    // Provide a default initial state
    when(() => mockProductsBloc.state).thenReturn(InitialState());
    registerFallbackValue(MaterialPageRoute(builder: (_) => Container()));
  });

  Future<void> pumpWidget(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductsBloc>.value(
          value: mockProductsBloc,
          child: const UpdatePage(
            productId: '1',
            name: 'Test Product',
            price: 9.99,
            description: 'This is a test product',
            imageUrl: 'https://example.com/image.jpg',
          ),
        ),
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
  }

  group('UpdatePage', () {
    testWidgets('renders ProductForm in initial state', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockProductsBloc.state).thenReturn(InitialState());

      // Act
      await pumpWidget(tester);

      // Assert
      expect(find.text('Update Product'), findsOneWidget);
      expect(find.byType(ProductForm), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
    });

    testWidgets('shows a loading indicator when state is LoadingState', (
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

    testWidgets('shows error message when state is ErrorState', (
      WidgetTester tester,
    ) async {
      // Arrange
      whenListen(
        mockProductsBloc,
        Stream.fromIterable([
          InitialState(),
          const ErrorState('Failed to update'),
        ]),
      );

      // Act
      await pumpWidget(tester);
      await tester.pump();
      await tester.pump(); // Allow for any animations

      // Assert
      expect(find.text('Failed to update'), findsOneWidget);
    });
  });
}
