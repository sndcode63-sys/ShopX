# Shop_x

A Flutter shopping app built for the developer assignment. I went with Tasks 1 and 2 — API integration and the cart system.

---

## Running the project

```bash
flutter pub get
flutter run
```

Tested on Android. Flutter 3.x, Dart 3.x.

---

## What I built

### Task 1 — Product Listing

Fetches products from `https://fakestoreapi.com/products` and displays them in a scrollable list.

I didn't just wrap `http.get` directly — I wrote a small `ApiClient` class that handles timeouts, retries, and logging. The idea was that if this were a real app, you'd want one place to control all outgoing requests rather than scattering `try/catch` blocks everywhere.

The retry logic backs off exponentially — first retry waits 2s, second waits 4s. Network errors and 5xx responses both trigger a retry. Other errors (4xx, parse failures) fail immediately since retrying won't help.

For loading states I used shimmer skeleton cards instead of a spinner — feels more like a real app. Errors show a retry button. Empty results get their own state too.

### Task 2 — Cart

Cart state lives in `CartController`. Adding the same product twice increments quantity rather than duplicating the entry. Bringing quantity to zero removes the item automatically.

The cart icon in the header shows a live badge with item count. The detail screen's bottom bar updates immediately when you tap "Add to Cart" — quantity controls appear in place of the button, and the price updates as you change quantity.

Swipe left on any cart item to remove it. There's also a "Clear all" option with a confirmation dialog so you don't accidentally wipe your cart.

Delivery is free above $50, otherwise ₹415 (~$4.99). Prices are shown in ₹ converted at 83x.

---

## Project structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/widgets/
│       ├── common_widgets/
│       └── product_card.dart
├── data/
│   ├── models/
│   ├── providers/        ← ApiClient lives here
│   └── repositories/
├── presentation/
│   ├── controllers/
│   └── screens/
├── app_bindings.dart
├── app_routes.dart
└── main.dart
```

Controllers are injected via `AppBindings` with `fenix: true` so they recreate themselves if disposed. Navigation uses named routes defined in `AppRoutes`.

---

## A few extra things I added

**360° view on product detail** — the product image rotates automatically. You can drag horizontally to spin it yourself, or tap to pause. Added a subtle shadow underneath that scales with the rotation angle for a bit of depth.

**Share button** — opens the native share sheet with product name, price, rating and category pulled dynamically.

**Common AppBar** — I noticed the home screen and cart screen were both building their own app bar with slightly different code. Pulled it into a single `ShopXAppBar` widget with named constructors (`.home()`, `.titled()`, `.detail()`) so there's one place to change if the design needs updating.

**Search + filter** — search and category filter both work together. Typing "jacket" while "men's clothing" is selected only shows jackets in that category.

---

## Dependencies

- `get` — state management, routing, DI
- `http` — networking (wrapped in custom client)
- `cached_network_image` — image caching
- `shimmer` — skeleton loading
- `google_fonts` — Space Grotesk + DM Sans
- `share_plus` — native share sheet