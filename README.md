#  GifscribeIt

Create engaging posts with GIFs on our app! Share them with the community, and let others vote up or down on your posts. Join now and see what's trending!

Introducing - GifscribeIt! Create and share posts with captivating titles, detailed content, and eye-catching GIFs. Connect with a vibrant community where you can share your thoughts, ideas, and creativity. Engage with others through an interactive voting system that allows users to vote posts up or down, highlighting the most popular and engaging content. Whether you want to share a funny moment, an insightful idea, or just something interesting, our app is the perfect platform for your voice to be heard. Join now and start making your mark in the community!

## Demo

You can simply create a new account with just email and password.

## Main Tech Stack

- SwiftUI: Declarative UI implementation
- Swift Concurrency: Asynchronous network requests and data handling using async/await
- [Moya](https://github.com/Moya/Moya): Network abstraction layer
- [TCA (The Composable Architecture)](https://github.com/pointfreeco/swift-composable-architecture): Unidirectional state management, feature modularization, and dependency injection
- [Firebase](https://github.com/firebase): Realtime Database, Authentication, Storage, Remote Config

## 프로젝트 폴더 구조

```plaintext
GifscribeIt
│── App/                     # Top-level entry point, Navigation Routes
│── Domain/                  # Core domain logic
│   ├── Auth/                # Auth-related domain logic
│   ├── Giphy/               # Giphy API domain logic
│   └── Post/                # Post-related domain logic
│── Presentation/            # Presentation specific UI and business logic
│   ├── AddPost/
│   ├── Find/
│   ├── Home/
│   ├── Main/
│   ├── PostDetail/
│   ├── Setting/
│   ├── SignIn/
│   └── SignUp/
│── UI/                      # Shared UI components
└── Util/                    # Utility functions (e.g., date formatting)
```

## Screenshots



## Supported Platforms

![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![Xcode 16.2+](https://img.shields.io/badge/Xcode-16.2%2B-blue)

## License

MIT

## Support

If you have any questions or inquiries, feel free to contact me:

Developer: jaehwi95@gmail.com
