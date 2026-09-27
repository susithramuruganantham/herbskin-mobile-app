# HERBSKIN HEAVEN — Flutter Mobile Application (Android & iOS)

A cross-platform Flutter mobile app for the **HERBSKIN HEAVEN** botanical skincare storefront, connected to the Node.js/Express backend & AI Manufacturing engine.

---

## 🌟 Key Features

1. **🌿 Botanical Catalog & Search**:
   - Live product browsing across Shampoos, Soaps, Face Washes, Hair Oils, Face Powders, and Creams.
   - Dynamic real-time search and category filtering.
   - Stock status indicators and discount badges.

2. **🛍️ Shopping Bag & Dynamic Checkout**:
   - Instant cart calculations (Free shipping above ₹500, else ₹40).
   - Checkout with Cash on Delivery (COD) or UPI payment options.
   - Automatically triggers the backend **AI Production Planner** to scale recipes and schedule compounding batches.

3. **🤖 Conversational AI Assistant**:
   - Powered by Gemini & the botanical formulation database.
   - Skin & hair routine diagnosis (e.g. *"I have dry scalp and dandruff"*).
   - 1-tap "Add to Cart" generation for recommended regimens.

4. **📍 Live 8-Step Order Tracking Stepper**:
   - `ORDER PLACED` ➔ `ORDER CONFIRMED` ➔ `AI PLANNED BATCH` ➔ `IN COMPOUNDING` ➔ `QUALITY CHECK (pH)` ➔ `ECO PACKAGING` ➔ `SHIPPED` ➔ `DELIVERED`.
   - Real-time updates searchable by Order ID (`HSH-XXXXX`) or Customer Phone.

5. **⭐ Customer Reviews Dispatched to Founder**:
   - Star rating & reviews directly forwarded to `rpandimeenacsc@gmail.com`.

6. **🔐 Customer JWT Authentication**:
   - Sign in and register with secure token storage.
   - Guest browsing and checkout also supported.

---

## 🚀 How to Run the App

### Prerequisites
1. [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version 3.0.0 or higher).
2. Android Studio (for Android Emulator/device) or Xcode (for iOS Simulator on macOS).
3. The HERBSKIN HEAVEN backend server running on `http://localhost:5000`.

### Step 1: Start the Backend
In the root directory `dual_ecommerce_system`:
```powershell
npm start
```
Verify that the server is active on `http://localhost:5000`.

### Step 2: Configure API Endpoint (If using Physical Device)
Open `lib/constants/api_constants.dart`:
- **Android Emulator**: Uses `http://10.0.2.2:5000` automatically.
- **iOS Simulator / Desktop / Web**: Uses `http://localhost:5000` automatically.
- **Physical Phone**: Change `baseUrl` to your computer's local Wi-Fi IP address (e.g., `http://192.168.1.10:5000`).

### Step 3: Run the Flutter App
Navigate into the mobile app directory:
```powershell
cd herbskin_mobile_app
flutter pub get
flutter run
```

---

## 📁 Architecture Overview

```
lib/
├── main.dart                      # App entry point with MultiProvider & Material3 theme
├── constants/
│   ├── colors.dart                # Brand green palette & design tokens
│   └── api_constants.dart         # Dynamic base URL and API endpoints
├── models/
│   ├── product.dart               # Product entity with pricing, ingredients, batch data
│   ├── cart_item.dart             # Cart item representation
│   ├── order.dart                 # Order tracking model with 8-step status timeline
│   ├── user.dart                  # User authentication model
│   └── chat_message.dart          # AI chat message & suggested actions
├── services/
│   ├── api_service.dart           # HTTP API client for catalog, orders & reviews
│   ├── auth_service.dart          # JWT token & user session management
│   ├── cart_service.dart          # State management for shopping bag
│   └── chatbot_service.dart       # Gemini AI conversational client
├── widgets/
│   ├── product_card.dart          # Interactive product card with badges
│   ├── category_chip.dart         # Rounded category filter pill
│   ├── order_stepper.dart         # Visual 8-step live order tracking stepper
│   ├── chat_bubble.dart           # AI message bubbles with quick cart buttons
│   ├── custom_button.dart         # Themed buttons with loading states
│   └── custom_text_field.dart     # Form inputs with validation styling
└── screens/
    ├── main_navigation_screen.dart # Bottom navigation shell
    ├── home_screen.dart           # Catalog, hero promo & search
    ├── product_detail_screen.dart # Detailed formulation specs, ingredients & buy button
    ├── cart_screen.dart           # Shopping bag drawer & price summary
    ├── checkout_screen.dart       # Shipping address & order confirmation
    ├── order_tracking_screen.dart # Live order tracking with progress stepper
    ├── ai_assistant_screen.dart   # Interactive botanical AI consultant
    ├── feedback_screen.dart       # Customer rating form dispatched to founder
    ├── auth_screen.dart           # Customer login & registration
    └── profile_screen.dart        # Account settings & manufacturing hub info
```
