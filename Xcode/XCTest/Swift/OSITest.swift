//
//  OSITest.swift
//  YourProjectTests
//

import XCTest
import DataNetlib // gives us DataNetlibResources.bundle
import DataSample //gives us DataSampleResources
import DataMiplib3


final class OSITest: XCTestCase {

    // ---------------------------------------------------------
    //  Path to the compiled CLI – fixed version (see above)
    // ---------------------------------------------------------
    private func osiUnitTestPath() -> String {
        let testBundleURL = Bundle(for: type(of: self)).bundleURL
        let productsDir   = testBundleURL.deletingLastPathComponent()

        #if os(Windows)
        let exeName = "osiUnitTest.exe"
        #else
        let exeName = "osiUnitTest"
        #endif

        return productsDir.appendingPathComponent(exeName).path
    }

    // ---------------------------------------------------------
    //  Copy resources (plain prints – no XCTContext, works on every OS).
    // ---------------------------------------------------------
    private func copyResourcesNextToExecutable(dataResourceBundle : Bundle) throws {
        let exeURL = URL(fileURLWithPath: osiUnitTestPath())
        let destFolder = exeURL.deletingLastPathComponent()

        guard let srcRoot = dataResourceBundle.resourceURL else {
            throw NSError(domain: "Copy Data ResourceR", code: 1,
                          userInfo: [NSLocalizedDescriptionKey:
                                     "Could not locate data in bundle resource, Should be in Resources/Data/Netlib or Resources/Data/Sample"])
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
        try copyResourcesNextToExecutable(dataResourceBundle: DataNetlib.bundle)
        try copyResourcesNextToExecutable(dataResourceBundle: DataSample.bundle)
        try copyResourcesNextToExecutable(dataResourceBundle: DataMiplib3.bundle)
                                    6
                                                        
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
