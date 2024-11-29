import ProjectDescription

public extension TargetDependency {
    static let tca: TargetDependency = .package(product: "ComposableArchitecture")
}

public extension Package {
    static let tca: Package = .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.4")
}

public extension TargetDependency {
    static func module(name: String) -> TargetDependency {
        return .project(target: name, path: .relativeToRoot("Modules/" + name))
    }
}
