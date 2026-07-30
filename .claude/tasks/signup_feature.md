Now build the WORKER role sign up. It is DIFFERENT from the company roles:

## Flow
- The "Workers" card on AccountTypeScreen navigates DIRECTLY to the Worker form.
  There is NO sub-type selection screen for Worker.

## Form — SINGLE STEP (not multi-step)
- Worker has ONE step only. No step indicator, no Next-then-Step2.
- A single scrollable form + a Submit button at the bottom.

## Single-step vs the multi-step base
- BaseSignupCubit was built for multi-step roles. Do NOT force Worker into it if that
  adds dead/unused step logic. Choose the cleaner option and tell me which:
  (a) a thin WorkerCubit that reuses BaseSignupCubit but runs as a single step, or
  (b) a lightweight standalone WorkerCubit emitting the SHARED SignupState.
- Either way: reuse the SHARED SignupState, the shared field widgets, the existing
  email/phone/password widgets, validators.dart, and BaseSignupParams. Do NOT duplicate.

## Fields (single step) — from the Worker info design
Full Name, Full Name in English, Email, Phone (+218), Nationality (dropdown),
Gender (dropdown), Blood Type (dropdown), Birth Date (date picker), Birth Place,
Craft or field of work, Password, Confirm Password.

## Params
- WorkerParams extends BaseSignupParams, adds ONLY the extra worker fields
  (fullNameEn, gender, bloodType, birthDate, birthPlace, craft) and overrides
  toJson() with super.toJson()..addAll({...}).

## API not ready
- Add `signupWorker` placeholder to ApiEndPontis with `// TODO confirm`.
- SignupRemote.signupWorker() follows the existing MDRepo pattern
  (executeProcedure, jsonDecode(res.data as String), status check, ApiErrorHandler).
- SignupRepo stays thin (logs + fromJson). Reuse SignupResponseModel.

## Validation (validators.dart, returning l10n keys)
Name: 4 words min. Email: valid. Phone: Libyan +218. Password: 8+ with upper/lower/number.
Confirm Password: must match. Required for all required fields. Birth Date required.

## File placement (keep organized — nothing scattered)
feature/auth/signup/
  data/params/worker_params.dart
  data/remote/  → add signupWorker() to existing signup_remote.dart (don't make a new file)
  data/repo/    → add to existing signup_repo.dart
  logic/cubit/signup/worker_cubit.dart   (+ reuse shared signup_state.dart)
  ui/screens/forms/worker_screen.dart    (thin scaffold, single step)
  ui/widgets/forms/worker_form_section.dart
- Reuse existing shared widgets (dropdowns, date picker) — add a gender dropdown only
  if one doesn't already exist. Don't recreate the date picker if it's already there.

## Localization (ar / en / fr, in sync, under "signup" namespace)
Add only NEW keys (worker-specific: gender, bloodType, birthDate, birthPlace, craft,
fullNameEn) to ar.json, en.json, fr.json. Reuse existing shared keys.

## Wiring
- Add `workerSignupScreen` route to Routes/AppRouter.
- Wire the Workers card on AccountTypeScreen to it.
- Register Remote/Repo (lazySingleton, already there) + WorkerCubit (factory) in GetIt,
  grouped with the rest of signup.

EXPLAIN your plan first (files + order + your choice for single-step cubit), and wait
for my approval before writing code.