
# **Flutter Clean Architecture with Riverpod – Project Structure & Naming**

```
lib/
├── core/
│   ├── constants/
│   │    └── k_sizes.dart
│   ├── errors/
│   │    └── app_error.dart
│   ├── utils/
│   │    └── logger.dart
│   └── di/
│        └── core_providers.dart
│
└── feature_name/
    ├── domain/
    │   ├── entities/
    │   │    └── feature_model.dart
    │   ├── value_objects/
    │   │    └── feature_id.dart
    │   ├── errors/
    │   │    └── feature_error.dart
    │   ├── repositories/
    │   │    └── i_feature_repository.dart
    │   └── use_cases/                   # Optional for medium/large apps
    │        └── get_feature_use_case.dart
    │
    ├── data/
    │   ├── dtos/
    │   │    └── feature_dto.dart
    │   ├── sources/
    │   │    ├── remote/
    │   │    │    └── feature_remote_service.dart
    │   │    └── local/
    │   │         └── feature_local_service.dart
    │   ├── repositories/
    │   │    └── feature_repository_impl.dart
    │   └── constants/
    │        └── feature_api_keys.dart
    │
    ├── application/
    │   ├── state/
    │   │    ├── feature_state.dart
    │   │    └── feature_notifier.dart
    │   └── providers/
    │        └── feature_providers.dart
    │
    └── presentation/
        ├── pages/
        │    └── feature_page.dart
        ├── widgets/
        │    └── feature_widget.dart
        └── controllers/                 # Optional: UI-only state
             └── feature_ui_provider.dart
```

---

# **Layer Responsibilities**

### **1. Domain Layer**

* **What:** Pure business rules
* **Content:**

  * Entities (immutable Freezed models)
  * Value objects for IDs or validated fields
  * Repositories (interfaces only)
  * Sealed error types
  * Optional use cases for single-responsibility operations
* **Key Rule:** **No Flutter, Riverpod, or HTTP imports** → Pure Dart

---

### **2. Data Layer**

* **What:** Infrastructure implementation of domain contracts
* **Content:**

  * DTOs with `fromJson`, `toJson`, `toDomain()`
  * Remote and Local data sources (API, DB, cache)
  * Repository implementations (map DTO ↔ Domain)
  * API keys and endpoint constants
* **Key Rule:** **Never return DTOs to other layers**, always map to domain

---

### **3. Application Layer**

* **What:** State management and feature orchestration
* **Content:**

  * **State classes** (Freezed + DataState or AsyncValue)
  * **Notifiers** (StateNotifier or AsyncNotifier)
  * **Riverpod providers** for DI and access in UI
* **Key Rule:**

  * Inject repositories via providers
  * No raw API or DB logic here
  * State is immutable and testable

---

### **4. Presentation Layer**

* **What:** Widgets and UI logic only
* **Content:**

  * Pages (full screens)
  * Widgets (reusable UI components)
  * Optional **UI-only providers** (filters, animation state)
* **Key Rule:**

  * Consume state via `ref.watch(provider)`
  * Trigger actions via `ref.read(provider.notifier)`
  * No business logic

---

# **Riverpod State Flow**

```
[ UI (Page/Widget) ]
        |
   ref.watch()
        ↓
[ Application Layer ]
   FeatureNotifier
        |
   Calls repository via provider
        ↓
[ Data Layer ]
   RepositoryImpl → Service → DTO
        ↓
[ Domain Layer ]
   Returns Result<Entity, Error> to notifier
        ↓
[ Application Layer ]
   State updated (loading → success/error)
        ↓
[ UI updates automatically ]
```

---

# **Naming & File Conventions**

### **Files**

* Entities → `_model.dart`
* Value Objects → `_vo.dart` (optional)
* Errors → `_error.dart`
* DTOs → `_dto.dart`
* Repositories → `_repository.dart` / `_repository_impl.dart`
* Services → `_remote_service.dart` / `_local_service.dart`
* Notifiers → `_notifier.dart`
* State → `_state.dart`
* Pages → `_page.dart`
* Widgets → `_widget.dart`

### **Classes**

* State → `FeatureState`
* Notifier → `FeatureNotifier`
* Repository Interface → `IFeatureRepository`
* Repository Impl → `FeatureRepositoryImpl`
* Page → `FeaturePage`
* Widget → `FeatureWidget`

---

# **Best Practices**

1. **Separation of Concerns**

   * Domain is pure and reusable
   * Data handles mapping and errors
   * Application manages state & orchestration
   * Presentation is pure UI

2. **Error Handling**

   * Use **Result\<T, E>** in domain and data
   * Convert infrastructure errors → domain errors

3. **Testability**

   * Override providers in tests
   * Test state transitions and error paths
   * Keep UI testable with keys

4. **Consistency**

   * Use **KSizes** for all spacing
   * Use **Freezed** for all states and models
   * Follow directory symmetry between `lib/` and `test/`

