---
name: flutter-feature
description: Flutter feature scaffolding reference. Use when creating features, endpoints, cubits, or asking about architecture patterns.
inclusion: fileMatch
fileMatchPattern: "**/*.dart"
allowed-tools: Read Write Edit Bash(find *) Bash(grep *)
---
# Flutter Feature Architecture

## Architecture Flow
```
Screen → Cubit → Repository → Remote → API
```

## Feature Structure
```
lib/features/{feature}/
├── data/
│   ├── datasources/{feature}_remote.dart
│   ├── models/{model}_model.dart
│   └── repositories/{feature}_repo.dart
├── logic/cubit/
│   ├── {feature}_cubit.dart
│   └── {feature}_state.dart
└── ui/
    ├── screens/{feature}_screen.dart
    └── widgets/{widget}.dart
```

## Code Patterns

### Model
```dart
class ProductModel {
  final String? id;
  final String? name;
  
  ProductModel({this.id, this.name});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as String?,
    name: json['name'] as String?,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
```

### Remote (always use DioFactory + ApiErrorHandler)
```dart
class HomeRemote {
  final Dio _dio;
  HomeRemote() : _dio = DioFactory.getDio();

  Future<ProductsModel> getProducts() async {
    try {
      final response = await _dio.get(ApiEndPontis.baseUrl + ApiEndPontis.products);
      return ProductsModel.fromJson(response.data);
    } catch (e) {
      final exception = ApiErrorHandler.handle(e);
      throw Exception(exception.message);
    }
  }
}
```

### Repository (thin wrapper)
```dart
class HomeRepo {
  final HomeRemote _remote;
  HomeRepo(this._remote);

  Future<ProductsModel> getProducts() async {
    return await _remote.getProducts();
  }
}
```

### State (sealed classes)
```dart
sealed class HomeState {}
final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeSuccess extends HomeState {
  final ProductsModel data;
  HomeSuccess({required this.data});
}
final class HomeFailure extends HomeState {
  final String errMsg;
  HomeFailure({required this.errMsg});
}
```

### Cubit (try-catch pattern)
```dart
class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _repo;
  HomeCubit(this._repo) : super(HomeInitial());

  Future<void> loadProducts() async {
    emit(HomeLoading());
    try {
      final data = await _repo.getProducts();
      emit(HomeSuccess(data: data));
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(HomeFailure(errMsg: errorMessage));
    }
  }
}
```

### Screen (switch expression)
```dart
// ✅ Correct - BlocBuilder on smallest widget
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          const HomeHeader(), // no state needed
          _ProductsSection(),  // only this needs state
        ],
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => switch (state) {
        HomeInitial() => const SizedBox.shrink(),
        HomeLoading() => const HomeShimmer(),
        HomeSuccess(:final data) => ProductsList(data: data),
        HomeFailure(:final errMsg) => ErrorWidget(message: errMsg),
      },
    );
  }
}
```

### DI Registration
```dart
// core/di/dependency_injection.dart
getIt.registerLazySingleton<HomeRemote>(() => HomeRemote());
getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));
```

## Naming Conventions
| Type | Pattern | Example |
|------|---------|---------|
| Screen | `{name}_screen.dart` | `home_screen.dart` |
| Widget | `{name}_{purpose}.dart` | `product_card.dart` |
| Cubit | `{name}_cubit.dart` | `home_cubit.dart` |
| State | `{name}_state.dart` | `home_state.dart` |
| Model | `{name}_model.dart` | `product_model.dart` |
| Repository | `{name}_repo.dart` | `home_repo.dart` |
| Remote | `{name}_remote.dart` | `home_remote.dart` |

## Checklist
- [ ] Create folder structure: `data/`, `logic/`, `ui/`
- [ ] Models with fromJson/toJson
- [ ] Remote with DioFactory + ApiErrorHandler
- [ ] Repository as thin wrapper
- [ ] Sealed State classes
- [ ] Cubit with try-catch
- [ ] Screen with BlocBuilder + switch (shimmer for loading — never CircularProgressIndicator)
- [ ] DI: Lazy singleton (Remote/Repo), Factory (Cubit)
- [ ] Add route to `core/routing/`
- [ ] Add endpoint to `core/networking/api_end_pontis.dart`

## Key Rules
- Cubit depends on Repository (handle errors with try-catch)
- Remote uses `DioFactory.getDio()` and `ApiErrorHandler.handle(e)`
- States use sealed classes for exhaustive matching
- Clean errors: `.replaceAll('Exception: ', '')`
- Shared code → `core/shared/`
