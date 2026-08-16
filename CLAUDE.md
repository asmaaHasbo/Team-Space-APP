name: flutter-instructions
description: Core Flutter project conventions, architecture rules, and coding standards.
inclusion: always
## Session Start
- Scan `lib/features/`, `lib/shared/`, `lib/core/` (max 40s)
- App is running — DO NOT run `flutter run` — hot reload is active
- Confirm: ✅ Loaded project preferences. App is running with hot reload.

## Explain Before Execute (MANDATORY)
Before ANY task:
1.  **Understood** — the problem
2.  **Plan** — exact steps
3.  **Why** — technical reason

Then **wait for "go"** — never skip, never assume.

## One Step At A Time (MANDATORY)
Show the full plan up front, then **execute one step only**.
- Run `flutter analyze` ONCE after the final step only (~2.5 min/run) — never between steps; the IDE flags errors live
- Explain the step in 2–3 lines max, label it «الخطوة X من Y»
- Ask **"فاهمة ولا لأ؟"** and **wait** — never chain steps
- Exception: only when asked "اعمله كله مرة واحدة", run the whole plan

## Task Label
Prefix every task: 🐛 Bug | ✨ Feature | 🔄 Refactor | ❓ Question | 🎨 Style

## Reply Format (RTL)
- Start every line/bullet/heading with an Arabic word — mixed Arabic/English must render right-to-left
- English terms stay inline mid-sentence, never at line start (e.g. «الـ navigationBarTheme جاهز» not "navigationBarTheme جاهز")

## Architecture
- Layers: `presentation → domain → data` — never skip or mix
- UI = zero business logic | Domain = zero Flutter imports
- Package imports only — no relative imports (`../../`)
- Smallest change that fixes the root cause — never symptoms

## Widgets
- Screen file = scaffold + layout only (~50 lines)
- Each logical section = its own file under `widgets/`
- No private `_build` functions — widget class name = file name
- No controllers/animations/focus nodes inside `build()` — always `dispose()`
- `const` constructors everywhere possible

feature/ui/
├── screens/feature_screen.dart
└── widgets/
    ├── feature_header.dart
    └── feature_item_card.dart

## Naming
| Type | Pattern |
|------|---------|
| Screen | `name_screen.dart` |
| Widget | `name_purpose.dart` |
| Cubit/State | `name_cubit.dart` / `name_state.dart` |
| Model/Repo/Remote | `name_model.dart` / `name_repo.dart` / `name_remote.dart` |

## State (Cubit/Bloc only)
- Builder=UI changes | Listener=side effects | Consumer=both
- No navigation inside `BlocBuilder`
- No `context.read<Cubit>()` inside `builder`
- Always handle: Loading | Success | Failure | Empty
- Use BlocBuilder/BlocSelector on the smallest widget that needs state — NEVER at the top of the tree
- BlocSelector preferred over BlocBuilder when only one field from state is needed

## API
- Always `DioFactory.getDio()` — never new Dio
- Always `ApiErrorHandler.handle(e)` in remote datasources
- Flow: `Remote throws → Repo passes → Cubit catches → emit(Failure)`
- Use `setupSnackBarForSuccessState()` / `setupSnackbarForFailureState()`
- Clean errors: `.replaceAll('Exception: ', '')`

## DI (get_it only)
- Cubits → `registerFactory` | Repos + Remotes → `registerLazySingleton`
- Register in `core/di/` only

## UI Rules
- Images: `CachedNetworkImage` + `ImageShimmer` — never `Image.network`
- Loading: `redacted` package — real widget + one sample model, wrapped `.redactedHelper(context: context, isLoading: true)`
- Sample model lives in the loading widget file only — never nullable fields or placeholder text on the real widget
- `ImageShimmer` for image loading — never redacted on images
- Check `core/` before creating shared code — common components → `presentation/shared/`

## Pitfalls
- Phone → E.164 only: `^\+?[1-9]\d{1,14}$`
- Navigation → `AppRoutes` class only — no string routes
- Numbers → raw in data layer, format at presentation only
- `setState` in `initState` → use `WidgetsBinding.instance.addPostFrameCallback`
- No `!` null assertion — use `?.` / `??`

## Security
- No hardcoded secrets/tokens — use env vars or secure storage
- No logging of sensitive data (tokens, passwords, PII)
- Validate all external/API input before use
- Flag security risks proactively before implementing

## Packages
- No new packages without justification
- Must be: latest stable + well-maintained + production-grade
- Check `core/` first — don't duplicate existing solutions

## Done When
- `flutter analyze` → zero errors
- All affected files updated
- Root cause fixed — no similar issues left