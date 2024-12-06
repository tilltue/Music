import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "MediaControl",
    targets: [
        .target(
            name: "MediaControl",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.tilltue.MediaControl",
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .tca,
                .module(name: "Repository")
            ]
        ),
        .target(
            name: "RepositoryTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.tilltue.MediaControlTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .tca,
                .module(name: "Repository"),
                .target(name: "MediaControl")
            ]
        )
    ]
)

