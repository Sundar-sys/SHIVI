# Shivi 💜

**Shivi** is a friendly bilingual (Hindi/English — Hinglish) voice-companion app built with Flutter. It's designed to reduce anxiety, help users practice communication, and entertain — through AI voice conversation, relaxing music, and playful voice-based games.

> ⚠️ **Status:** Active development / reference architecture. Core modules are implemented; see [Roadmap](#roadmap) for what's left before a production release.

---

![Uploading ChatGPT Image Jul 24, 2026, 07_19_23 PM.png…]()



## ✨ Features

- **AI Voice Chat** — Talk to Shivi in Hindi or English. Speech-to-text captures what you say, an LLM (via Hugging Face) generates a warm, context-aware reply, and text-to-speech speaks it back with automatic language detection.
- **Relaxation Music** — Categorized tracks (Calming Beats, Ambient Sounds, Focus Music, Nature Sounds) with full playback controls and background/lock-screen audio support.
- **Fun & Banter Zone** — Voice-based mini-games: Truth or Tongue Twister, Bilingual Trivia, and Rapid-Fire Mood Boosters, powered by a "Quiz Master" AI persona.
- **Text fallback** — Toggle to typed input any time you don't want to use voice.
- **Calming pastel UI** — Soft purples, warm blues, and creams designed to feel soothing rather than clinical.

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State management | Riverpod (`flutter_riverpod`) |
| AI model | Qwen2.5-7B-Instruct via Hugging Face Inference API |
| Speech-to-text | `speech_to_text` |
| Text-to-speech | `flutter_tts` |
| Audio playback | `just_audio` + `just_audio_background` |
| Networking | `dio` |
| Backend proxy | Node.js + Express |

---

## 📁 Repository Structure

```
.
├── shivi/                    # Flutter app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/
│   │   │   ├── constants/    # colors, API constants
│   │   │   └── theme/        # app-wide ThemeData
│   │   ├── data/
│   │   │   ├── models/       # ChatMessage, Track
│   │   │   └── services/     # HF service, STT, TTS, audio player
│   │   ├── providers/        # Riverpod state notifiers
│   │   ├── screens/
│   │   │   ├── voice_chat/
│   │   │   ├── music/
│   │   │   ├── fun_zone/
│   │   │   └── home/
│   │   └── widgets/
│   ├── assets/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── shivi-proxy/              # Node.js backend that hides the HF API key
│   ├── src/
│   │   ├── server.js
│   │   ├── routes/chat.js
│   │   ├── middleware/
│   │   └── config/
│   └── package.json
│
├── LICENSE
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.3.0
- A Hugging Face account + API token ([huggingface.co/settings/tokens](https://huggingface.co/settings/tokens))
- Node.js ≥ 18 (for the backend proxy)

### 1. Clone and install

```bash
git clone https://github.com/<your-username>/shivi.git
cd shivi/shivi
flutter pub get
```

### 2. Set up the backend proxy (recommended)

The Flutter app should **not** call Hugging Face directly in production — that exposes your API key inside the compiled app. Instead, run the included proxy:

```bash
cd shivi-proxy
npm install
cp .env.example .env   # then fill in HF_API_TOKEN and SHIVI_APP_SECRET
npm start
```

Deploy it to Render, Railway, Fly.io, or Cloud Run for a public URL.

### 3. Configure the Flutter app

Create a `.env` file inside `shivi/`:

```
SHIVI_APP_SECRET=same_secret_as_your_proxy
```

Update `shivi/lib/core/constants/api_constants.dart` with your deployed proxy URL:

```dart
static const String proxyBaseUrl = 'https://your-shivi-proxy.onrender.com';
```

### 4. Run the app

```bash
cd shivi
flutter run
```

---

## 🔑 Permissions

Shivi requires microphone access for voice chat and background audio for the music player. These are pre-configured in:

- `shivi/android/app/src/main/AndroidManifest.xml`
- `shivi/ios/Runner/Info.plist`

The app also shows a friendly in-app primer before triggering the native OS permission dialog.

---

## 🗺 Roadmap

- [ ] Local persistence (Hive) for chat history across restarts
- [ ] Onboarding flow — language preference, first-time voice calibration
- [ ] Graceful fallback when a device lacks a Hindi TTS voice
- [ ] CI/CD (GitHub Actions) for build + test
- [ ] Per-user auth on the backend proxy (replacing the shared app secret)

---

## 🤝 Contributing

Contributions are welcome. Please open an issue to discuss significant changes before submitting a PR.

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes
4. Push and open a PR

---

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

## ⚠️ Disclaimer

Shivi is a companion and entertainment app, not a substitute for professional mental health support. If you or someone you know is in crisis, please contact a licensed mental health professional or local emergency services.
