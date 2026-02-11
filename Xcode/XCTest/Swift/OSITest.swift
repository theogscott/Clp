import XCTest

final class OSITest: XCTestCase {
    /// Returns the absolute path of the compiled `osiUnitTest` executable.
    private func osiUnitTestPath() -> String {
        let env = ProcessInfo.processInfo.environment
        guard let buildDir = env["TARGET_BUILD_DIR"] else { return "" }
        return URL(fileURLWithPath: buildDir)
            .appendingPathComponent("osiUnitTest")
            .path
    }

    func testOSIUnit() throws {
        let exe = osiUnitTestPath()
        XCTAssertTrue(FileManager.default.isExecutableFile(atPath: exe), "osiUnitTest not found at \(exe)")
        let process = Process()
        process.executableURL = URL(fileURLWithPath: exe)
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        XCTAssertEqual(process.terminationStatus, 0,
                       "osiUnitTest failed (code \(process.terminationStatus)). Output:\n\(output)")
    }
}

