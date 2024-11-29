import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Music",
    packages: [
        .tca
    ],
    targets: [
        .target(
            name: "Music",
            destinations: .iOS,
            product: .app,
            bundleId: "com.tilltue.Music",
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "1.0",
                    "CFBundleVersion": "1",
                    "NSAppleMusicUsageDescription": "이 앱으로 Apple Music을 통해 당신의 음악을 다시 즐겨보세요!"
                ]
            ),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .tca
            ]
        ),
        .target(
            name: "MusicTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.tilltue.MusicTests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Music")
            ]
        ),
    ]
)
