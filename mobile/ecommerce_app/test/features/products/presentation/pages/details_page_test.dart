import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:ecommerce_app/features/products/presentation/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

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
          child: const DetailsPage(productId: '1'),
        ),
      ),
    );
  }

  group('Details Page Tests', () {
    testWidgets(
      'renders correctly and shows product details when state is LoadedProductDetailsState',
      (WidgetTester tester) async {
        // Arrange: Set up the initial state of the BLoC before the widget is built.
        await mockNetworkImagesFor(() async {
          when(() => mockProductsBloc.state).thenReturn(
            const LoadedSingleProductState(
              Product(
                id: '1',
                name: 'Test Product',
                description: 'This is a test product',
                price: 9.99,
                imageUrl:
                    'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D',
              ),
            ),
          );

          // Act
          await pumpWidget(tester);
          await tester
              .pump(); // Pump a frame for the UI to build with the initial state.

          // Assert
          expect(find.text('Test Product'), findsOneWidget);
          expect(find.text('\$9.99'), findsOneWidget);
          expect(find.text('This is a test product'), findsOneWidget);
          // verify the image is displayed
          expect(find.byType(Image), findsOneWidget);
          //verify there is two buttons for update and delete
          expect(find.text('Update'), findsOneWidget);
          expect(find.text('Delete'), findsOneWidget);
        });
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
