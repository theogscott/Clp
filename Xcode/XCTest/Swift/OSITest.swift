//
//  OSITest.swift
//  YourProjectTests
//

import XCTest
import libDataNetlib               // gives us LibDataNetlibResources.bundle

final class OSITest: XCTestCase {

    // ---------------------------------------------------------
    //  Path to the compiled CLI – fixed version (see above)
    // ---------------------------------------------------------
    private func osiUnitTestPath() -> String {
        let env = ProcessInfo.processInfo.environment
        if let productsDir = env["BUILT_PRODUCTS_DIR"] {
            #if os(Windows)
            let exeName = "osiUnitTest.exe"
            #else
            let exeName = "osiUnitTest"
            #endif
            return URL(fileURLWithPath: productsDir)
                .appendingPathComponent(exeName).path
        }

        var url = URL(fileURLWithPath: #file)   // this source file
        for _ in 0..<4 { url.deleteLastPathComponent() } // → .build/debug
        #if os(Windows)
        let exeName = "osiUnitTest.exe"
        #else
        let exeName = "osiUnitTest"
        #endif
        return url.appendingPathComponent(exeName).path
    }

    // ---------------------------------------------------------
    //  Copy resources from libDataNetlib.bundle to the folder that
    //  contains the CLI executable.
    // ---------------------------------------------------------
    // -----------------------------------------------------------------
    // Helper that copies the resources and prints debug info.
    // No XCTest activity → no main‑actor inference.
    // -----------------------------------------------------------------
    private func copyResourcesNextToExecutable() throws {
        let exeURL = URL(fileURLWithPath: osiUnitTestPath())
        let destFolder = exeURL.deletingLastPathComponent()

        guard let srcRoot = LibDataNetlibResources.bundle.resourceURL else {
            throw NSError(domain: "CopyRes", code: 1,
                          userInfo: [NSLocalizedDescriptionKey:
                                     "Could not locate DataNetlib_libDataNetlib.bundle"])
        }

        // ---- DEBUG INFO (plain prints – safe on every platform) ----
        print("📦 Bundle root (source) → \(srcRoot.path)")
        print("🗂️ Destination folder (next to osiUnitTest) → \(destFolder.path)")

        // -------------------------------------------------------------
        //  Copy everything from the bundle into the same folder as the CLI
        // -------------------------------------------------------------
        let fm = FileManager.default
        let enumerator = fm.enumerator(at: srcRoot,
                                       includingPropertiesForKeys: nil,
                                       options: [.skipsHiddenFiles],
                                       errorHandler: { url, err in
            print("⚠️  Skipping \(url): \(err)")
            return true          // keep walking even if one file fails
        })!

        for case let src as URL in enumerator {
            // Preserve sub‑folders (if any)
            let rel = src.path.replacingOccurrences(of: srcRoot.path, with: "")
            let dst = destFolder.appendingPathComponent(rel)

            try fm.createDirectory(at: dst.deletingLastPathComponent(),
                                   withIntermediateDirectories: true,
                                   attributes: nil)

            if fm.fileExists(atPath: dst.path) {
                try? fm.removeItem(at: dst)   // overwrite old copy
            }
            try fm.copyItem(at: src, to: dst)
            print("🔄  Copied \(src.lastPathComponent) → \(dst.path)")
        }

        // -------------------------------------------------------------
        //  List what finally sits next to the binary (optional)
        // -------------------------------------------------------------
        let finalContents = try fm.contentsOfDirectory(at: destFolder,
                                                       includingPropertiesForKeys: nil)
        print("\n📂  Files now present beside osiUnitTest:")
        for file in finalContents {
            print("   • \(file.lastPathComponent)")
        }
    }

  


    // ---------------------------------------------------------
    //  The actual test – async only because we hop onto the main actor
    //  for XCTContext (optional; you can keep it sync if you prefer).
    // ---------------------------------------------------------
    func testOSIUnit() async throws {
        try copyResourcesNextToExecutable()

        let exe = osiUnitTestPath()
        print("🚀 Full path of the CLI → \(exe)")

        XCTAssertTrue(FileManager.default.isExecutableFile(atPath: exe),
                      "osiUnitTest not found at \(exe)")

        var process = Process()
        process.executableURL = URL(fileURLWithPath: exe)
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError  = pipe

        try process.run()
        process.waitUntilExit()

        let outData = pipe.fileHandleForReading.readDataToEndOfFile()
        let output  = String(data: outData, encoding: .utf8) ?? ""

        XCTAssertEqual(
            process.terminationStatus, 0,
            "osiUnitTest failed (code \(process.terminationStatus)). Output:\(output)"
        )
    }
}
