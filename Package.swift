// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Clp",
    
    // MARK: - Platforms supported
    // -----------------------------------------------------------------
    //  1. Platforms Versions – macOS, iOS, etc.
    // -----------------------------------------------------------------
    platforms: [
        .iOS(.v15),   // iOS 15+ (or later)
        .macOS(.v13)   // macOS 13+ (Ventura) – adjust if you need an older version
    ],
    
    // MARK: - Products (what the package vends to clients)
    // -----------------------------------------------------------------
    //  2. Products – expose a library that downstream code can import.
    // -----------------------------------------------------------------
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Clp",
            type: .static, // static because of sandboxing.
            targets: ["Clp"]
        ),
    ],
    
    // MARK: - Dependencies
    // -----------------------------------------------------------------
    // 3. Depependent on CoinUtils
    // -----------------------------------------------------------------
    dependencies: [
        .package(
            //path: //"../CoinUtilsXCExperimental", // relative path to BasicMath directory
            
            // 1️⃣ The HTTPS URL of the repo that hosts BasicMath
            url: "https://github.com/theogscott/CoinUtils/tree/SPM",
            
            // 2️⃣ The version rule – legacy
            //   .exact("7e609e2a6df8ffc0e89c9dbdd38c582eada3386a")         // exactly this tag/commit
            //   .upToNextMajor(from: "1.0.0")
            //   .upToNextMinor(from: "1.2.0")
            //.branch("SPM"),           // for a rolling dev branch
            //.revision("7e609e2a6df8ffc0e89c9dbdd38c582eada3386a")      // a specific commit SHA
            from: "1.0.0"
        )
    ],
    
    // MARK: – Targets (the actual code and test suite)
    // --------------------------------------------------------------------
    // 4. Targets – split into a C++ library and a C and/or Swift wrapper
    //
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    // --------------------------------------------------------------------
    targets: [
        // ------------------------------------------------------------
        // 4a C++ target (only .cpp/.hpp files)
        // ------------------------------------------------------------
        .target(
            name: "Clp",  // internal name – can be anything
            dependencies: ["CoinUtils"],         // No external modules
            path: "src",
            sources: ["CbcOrClpParam.cpp",
                      "Clp_ampl.cpp",
                      "Clp_C_Interface.cpp",
                      "ClpCholeskyBase.cpp",
                      "ClpCholeskyDense.cpp",
                      "ClpCholeskyPardiso.cpp",
                      "ClpCholeskyTaucs.cpp",
                      "ClpConstraint.cpp",
                      "ClpConstraintLinear.cpp",
                      "ClpConstraintQuadratic.cpp",
                      "ClpDualRowDantzig.cpp",
                      "ClpDualRowPivot.cpp",
                      "ClpDualRowSteepest.cpp",
                      "ClpDummyMatrix.cpp",
                      "ClpDynamicExampleMatrix.cpp",
                      "ClpDynamicMatrix.cpp",
                      "ClpEventHandler.cpp",
                      "ClpFactorization.cpp",
                      "ClpGubDynamicMatrix.cpp",
                      "ClpGubMatrix.cpp",
                      "ClpHelperFunctions.cpp",
                      "ClpInterior.cpp",
                      "ClpLinearObjective.cpp",
                      "ClpLsqr.cpp",
                      "ClpMatrixBase.cpp",
                      "ClpMessage.cpp",
                      "ClpModel.cpp",
                      "ClpNetworkBasis.cpp",
                      "ClpNetworkMatrix.cpp",
                      "ClpNode.cpp",
                      "ClpNonLinearCost.cpp",
                      "ClpObjective.cpp",
                      "ClpPackedMatrix.cpp",
                      "ClpPdco.cpp",
                      "ClpPdcoBase.cpp",
                      "ClpPEDualRowDantzig.cpp",
                      "ClpPEDualRowSteepest.cpp",
                      "ClpPEPrimalColumnDantzig.cpp",
                      "ClpPEPrimalColumnSteepest.cpp",
                      "ClpPESimplex.cpp",
                      "ClpPlusMinusOneMatrix.cpp",
                      "ClpPredictorCorrector.cpp",
                      "ClpPresolve.cpp",
                      "ClpPrimalColumnDantzig.cpp",
                      "ClpPrimalColumnPivot.cpp",
                      "ClpPrimalColumnSteepest.cpp",
                      "ClpQuadraticObjective.cpp",
                      "ClpSimplex.cpp",
                      "ClpSimplexDual.cpp",
                      "ClpSimplexNonlinear.cpp",
                      "ClpSimplexOther.cpp",
                      "ClpSimplexPrimal.cpp",
                      "ClpSolve.cpp",
                      "ClpSolver.cpp",
                      //Dummy.cpp
                      "Idiot.cpp",
                      "IdiSolve.cpp",
                      "MyEventHandler.cpp",
                      "MyMessageHandler.cpp",
                      //"unitTest.cpp"
            ],
            
            // ---- Public headers --------------------------------------------------------------
            // Anything under `publicHeadersPath` becomes visible to *other* packages.
            // It also tells SPM where to look for the headers when it builds a Clang module.
            publicHeadersPath: ".",          // Anything inside src that ends with .h/.hpp becomes a public Clang module
            
            // ---- C++‑specific settings --------------------------------------------------------
            cxxSettings: [
                // Use the C++20 (or C++23) dialect – change if you need a different version.
                //.cxxStandard("c++20"), // keep whatever the user has chosen to installed
                
                //.define("CLPLIB_BUILD", to: "1"), // not sure ?
                .define("CLP_BUILD", to: "1"),
                .headerSearchPath(".")
            ]
        )
    ]
)
