import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:ecommerce_app/features/products/presentation/pages/add_page.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsBloc extends MockBloc<ProductsEvent, ProductsState>
    implements ProductsBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

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

  // A helper function to build the widget with the mock BLoC
  Future<void> pumpWidget(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductsBloc>.value(
          value: mockProductsBloc,
          child: const AddPage(),
        ),
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
  }

  group('AddPage', () {
    testWidgets('renders ProductForm in initial state', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockProductsBloc.state).thenReturn(InitialState());

      // Act
      await pumpWidget(tester);

      // Assert
      expect(find.text('Add Product'), findsOneWidget);
      expect(find.byType(ProductForm), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('shows a loading indicator when state is LoadingState', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockProductsBloc.state).thenReturn(LoadingState());

      // Act
      await pumpWidget(tester);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Check that the back button is disabled
      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });

    testWidgets(
      'shows SnackBar and pops page when state changes to CreatedProductState',
      (WidgetTester tester) async {
        // Arrange
        whenListen(
          mockProductsBloc,
          Stream.fromIterable([InitialState(), const CreatedProductState()]),
        );
        // To verify Navigator.pop is called
        verifyNever(() => mockNavigatorObserver.didPop(any(), any()));

        // Act
        await pumpWidget(tester);
        await tester.pump(); // First frame
        await tester.pump(); // Frame for state change and SnackBar animation

        // Assert
        expect(find.text('Product added successfully!'), findsOneWidget);
        verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
      },
    );

    testWidgets('shows error SnackBar when state is ErrorState', (
      WidgetTester tester,
    ) async {
      // Arrange
      whenListen(
        mockProductsBloc,
        Stream.fromIterable([
          InitialState(),
          const ErrorState('Failed to add'),
        ]),
      );

      // Act
      await pumpWidget(tester);
      await tester.pump(); // First frame
      await tester.pump(); // Frame for state change and SnackBar animation

      // Assert
      expect(find.text('Failed to add'), findsOneWidget);
    });

    testWidgets('adds CreateProductEvent when form is submitted', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockProductsBloc.state).thenReturn(InitialState());
      await pumpWidget(tester);

      // Act
      // Find the ProductForm's onSubmit callback and invoke it
      final productForm = tester.widget<ProductForm>(find.byType(ProductForm));
      productForm.onSubmit('Test Name', 'Test Desc', 99.99, 'path/to/image');
      await tester.pump();

      // Assert
      verify(
        () => mockProductsBloc.add(
          const CreateProductEvent(
            name: 'Test Name',
            description: 'Test Desc',
            price: 99.99,
            imageUrl: 'path/to/image',
          ),
        ),
      ).called(1);
    });
  });
}
