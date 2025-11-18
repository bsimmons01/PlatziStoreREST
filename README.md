# PlatziStore (SwiftUI + REST API Sample App)
### *Educational Example of Swift + REST API Architecture*

PlatziStore is a full-featured demonstration app built with **SwiftUI**, **async/await networking**, and a clean, modular architecture.  
It integrates with the **Platzi FakeStore REST API** to load products, categories, images, and authentication flows — all while showcasing production-ready code organization and modern Swift patterns.

This project is designed as an educational reference for anyone learning:

- How to structure a SwiftUI app at scale  
- How to build a reusable networking layer  
- How to use async/await with URLSession  
- How to handle authentication, decoding, API errors  
- How to manage application state with observable stores  
- How to build clean, testable views & screens

---

## 🚀 Features

- **SwiftUI-powered UI** with navigation stacks, lists, forms, modals, alerts  
- **Async/await networking layer** with `URLSession` + custom error handling  
- **Modular, folder-organized architecture**  
- **Category & product browsing**  
- **Authentication flows** (Login + Registration)  
- **Secure token storage using iOS Keychain**  
- **Async image loading** with fallback placeholders  
- **Example of custom view components, extensions & utilities**  
- **Safe concurrency on the main actor where needed**

---

## 📱 Screenshots

<table border=0 cellpadding=15 cellspacing=15>
  <tr>
    <td><img width="226" height="492" alt="Platzi Login Screen" src="https://github.com/user-attachments/assets/bae3be69-e36c-4500-84a9-fa9f5e17f4d4" /></td>
    <td><img width="226" height="492" alt="Platzi Category Screen" src="https://github.com/user-attachments/assets/cd26222b-6cc2-4aa4-a219-7477effe5b9e" /></td>
    <td><img width="226" height="492" alt="Platzi Locations Screen" src="https://github.com/user-attachments/assets/0b07b292-9000-4cfb-80fe-1c4cc13d941f" /></td>
  </tr>
  <tr>
    <td><img width="226" height="492" alt="Platzi Product List Screen" src="https://github.com/user-attachments/assets/c63ad80b-e2d2-4db8-8ae2-ec353bc19465" /></td>
    <td><img width="226" height="492" alt="Platzi Detail Screen" src="https://github.com/user-attachments/assets/0d9c8391-b99f-4e66-bbdc-fad4b4210b59" /></td>
    <td><img width="226" height="492" alt="Platzi Profile Screen" src="https://github.com/user-attachments/assets/eab55c81-8e45-4a9e-bd47-6adb548007f0" /></td>
    
  </tr>
</table>

---

## 🏗 Project Structure

The project is organized for clarity, maintainability, and education:

```text
PlatziStore/
├── Controllers/        # AuthenticationController, ProductsController, etc.
├── Errors/             # AppError, APIError, decoding failures
├── Extensions/         # Helpers for String, URL, Color, View, etc.
├── Networking/         # HTTPClient, endpoints, URLRequest builders
├── Requests/           # Encodable API request models
├── Responses/          # Decodable API response models
├── Screens/            # SwiftUI screens (Login, Register, ProductList, Detail)
├── Stores/             # Observable app-wide state containers
├── Utils/              # Constants, helpers, formatters
├── Views/              # Reusable SwiftUI view components
└── PlatziApp.swift     # Main entry point
```
This layout mirrors what you'd expect in a production SwiftUI application using REST APIs.

---

## 🌐 API Used

This project integrates with the publicly available **Platzi FakeStore API**:

[https://fakeapi.platzi.com/](https://fakeapi.platzi.com/)

Used for:

- Authentication  
- Products  
- Categories  
- Images  

---

## 🧩 Tech Stack

- **Swift 5.9+**  
- **SwiftUI**  
- **Async/Await Concurrency**  
- **URLSession Networking**  
- **Codable for JSON parsing**  
- **AppStorage / UserDefaults / Keychain**  
- **MVVM-ish view + store separation**

---

## 🔧 How to Run

1. Clone the repo:

   ```bash
   git clone https://github.com/YOUR_USERNAME/PlatziStore.git
   ```

2. Open the project:
   ```bash
   open PlatziStore.xcodeproj
   ```

4. Build & Run in Xcode (iOS 17+ recommended)
   No API keys are required — everything uses the public Platzi endpoints.

---

## 📚 Learning Highlights

## This project demonstrates:

### ✔ Building a clean networking layer
- Centralized HTTP client  
- Reusable request builders  
- Typed responses  
- Automatic error translation  

### ✔ Clean architecture
- Stores handle state & business logic  
- Screens are light and declarative  
- Controllers encapsulate API calls  
- Reusable view components reduce duplication  

### ✔ SwiftUI best practices
- Environment injection  
- NavigationStack  
- Alerts, sheets, and loading states  
- Async image handling  
- Form validation  

### ✔ Real-world handling
- Authentication tokens  
- Duplicate validation on inputs  
- Placeholder images  
- URL extensions for random image utilities  


---

## 👨‍🏫 Built with lessons from:

**"The Complete Guide to Integrating JSON API with SwiftUI"** by **Mohammad Azam**

https://www.udemy.com/course/the-complete-guide-to-integrating-json-api-with-swiftui/

*Not affiliated with or endorsed by the instructor or Udemy*


---

## 🏛️ Credits

All code written by Brian Simmons, unless otherwise notated, and released under the [MIT License](https://opensource.org/license/mit). Attribution is required.

---

## 🧑🏻‍💻 Apps by Brian:

<table border=0>
  <tr>
    <td><img width="50" height="50" alt="Heard It All App Icon" src="https://github.com/user-attachments/assets/6f874d30-d194-40e8-9174-0fcd85ffd423" /></td>
    <td style="vertical-align:middle;"><strong><a href="https://apps.apple.com/app/id6746056385">Heard It All</a></strong> - Relive every Billboard Hot 100 #1</td>
  </tr>
</table>

<table border=0>
  <tr>
    <td><img width="50" height="50" alt="What Year Was It? App Icon" src="https://github.com/user-attachments/assets/1a08766c-5b9a-4530-a7bc-6d537509e7d5" />
</td>
    <td style="vertical-align:middle;"><strong><a href="https://apps.apple.com/app/id6745128395">What Year Was It?</a></strong> - Challenge your memory across history</td>
  </tr>
</table>

---

## 💬 About
Created by **Brian Simmons**  
**[centrasoft.com](https://centrasoft.com)**

---

## 🤝 Contributing
Pull requests are welcome. Please open an issue first to discuss major changes.
