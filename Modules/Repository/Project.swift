import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Repository",
    targets: [
        .target(
            name: "Repository",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.tilltue.Repository",
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .tca
            ]
        ),
        .target(
            name: "RepositoryTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.tilltue.RepositoryTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Repository"),
                .tca
            ]
        )
    ]
)

