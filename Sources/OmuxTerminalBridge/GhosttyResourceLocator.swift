import Foundation

enum GhosttyResourceLocator {
    static let environmentKey = "GHOSTTY_RESOURCES_DIR"

    static func configureEnvironmentIfNeeded(
        environment: [String: String] = ProcessInfo.processInfo.environment,
        executableURL: URL = Bundle.main.executableURL ?? URL(fileURLWithPath: CommandLine.arguments.first ?? ""),
        fileManager: FileManager = .default
    ) {
        guard environment[environmentKey]?.isEmpty != false,
              let resourcesURL = resourcesDirectoryURL(
                  executableURL: executableURL,
                  fileManager: fileManager
              )
        else {
            return
        }

        setenv(environmentKey, resourcesURL.path, 0)
    }

    static func resourcesDirectoryURL(
        executableURL: URL,
        fileManager: FileManager = .default
    ) -> URL? {
        for candidate in candidateResourceURLs(executableURL: executableURL) where isGhosttyResourceDirectory(candidate, fileManager: fileManager) {
            return candidate
        }
        return nil
    }

    private static func candidateResourceURLs(executableURL: URL) -> [URL] {
        var candidates: [URL] = []
        let standardizedExecutableURL = executableURL.standardizedFileURL

        if let bundleResourcesURL = Bundle.main.resourceURL {
            candidates.append(bundleResourcesURL.appendingPathComponent("ghostty", isDirectory: true))
        }

        if let contentsRange = standardizedExecutableURL.path.range(of: ".app/Contents/MacOS/") {
            let bundlePath = String(standardizedExecutableURL.path[..<contentsRange.lowerBound]) + ".app"
            candidates.append(
                URL(fileURLWithPath: bundlePath, isDirectory: true)
                    .appendingPathComponent("Contents/Resources/ghostty", isDirectory: true)
            )
        }

        var current = standardizedExecutableURL.deletingLastPathComponent()
        for _ in 0..<8 {
            candidates.append(current.appendingPathComponent("Vendor/ghostty/zig-out/share/ghostty", isDirectory: true))
            current.deleteLastPathComponent()
        }

        return Array(
            Dictionary(grouping: candidates.map(\.standardizedFileURL), by: \.path)
                .compactMap { $0.value.first }
        )
    }

    private static func isGhosttyResourceDirectory(_ url: URL, fileManager: FileManager) -> Bool {
        let zshIntegration = url
            .appendingPathComponent("shell-integration/zsh/ghostty-integration", isDirectory: false)
            .path
        return fileManager.fileExists(atPath: zshIntegration)
    }
}
