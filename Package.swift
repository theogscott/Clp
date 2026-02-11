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
            name: "libClp",
            type: .static, // static because of sandboxing.
            targets: ["libClp"]
        ),
        .library(
            name: "libOsiClp",
            type: .static,
            targets: ["libOsiClp"]
        ),
        .executable (
            name: "osiUnitTest",
            targets: ["osiUnitTest"]
        )
    ],
    
    // MARK: - Dependencies
    // -----------------------------------------------------------------
    // 3. Depependent on CoinUtils
    // -----------------------------------------------------------------
    dependencies: [
        .package(
            url: "https://github.com/theogscott/CoinUtils",
            branch: "SPM"           // for a rolling dev branch
        ),
        .package(
            url: "https://github.com/theogscott/Osi",
            branch: "SPM"           // for a rolling dev branch
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
            name: "libClp",  // internal name – can be anything
            dependencies: [.product(name: "libCoinUtils", package: "CoinUtils")],         // Depends on CoinUtils
            path: "src",
            
            // We list all files, ands thosse headers thty must part of the library, are commented  out.
            exclude: [ "OsiClp",
                       "Attic",
                       "Missing",
                       "CbcOrClpParam.hpp",// will be included in the build
                       //"AbcCommon.hpp", // will not be part of the build.
//                      "AbcDualRowDantzig.hpp",
//                      "AbcDualRowPivot.hpp",
//                      "AbcDualRowSteepest.hpp",
//                      "AbcMatrix.hpp",
//                      "AbcNonLinearCost.hpp",
//                      "AbcPrimalColumnDantzig.hpp",
//                      "AbcPrimalColumnPivot.hpp",
//                      "AbcPrimalColumnSteepest.hpp",
//                      "AbcSimplex.hpp",
//                      "AbcSimplexDual.hpp",
//                      "AbcSimplexFactorization.hpp",
//                      "AbcSimplexPrimal.hpp",
//                      "AbcWarmStart.hpp",
                      //"Clp_C_Interface.h
                      "ClpCholeskyBase.hpp",
                      "ClpCholeskyDense.hpp",
                      //"ClpCholeskyMumps.hpp",
                      //"ClpCholeskyPardiso.hpp",
                      //"ClpCholeskyTaucs.hpp",
                      //"ClpCholeskyUfl.hpp",
                      //"ClpCholeskyWssmp.hpp",
                      //"ClpCholeskyWssmpKKT.hpp",
                      //"ClpConfig.h”,
                      "ClpConstraint.hpp",
                      "ClpConstraintLinear.hpp",
                      "ClpConstraintQuadratic.hpp",
                      "ClpDualRowDantzig.hpp",
                      "ClpDualRowPivot.hpp",
                      "ClpDualRowSteepest.hpp",
                      "ClpDummyMatrix.hpp",
                      "ClpDynamicExampleMatrix.hpp",
                      "ClpDynamicMatrix.hpp",
                      "ClpEventHandler.hpp",
                      "ClpFactorization.hpp",
                      "ClpGubDynamicMatrix.hpp",
                      "ClpGubMatrix.hpp",
                      "ClpHelperFunctions.hpp",
                      "ClpInterior.hpp",
                      "ClpLinearObjective.hpp",
                      "ClpLsqr.hpp",
                      "ClpMatrixBase.hpp",
                      "ClpMessage.hpp",
                      "ClpModel.hpp",
                      "ClpModelParameters.hpp",
                      "ClpNetworkBasis.hpp",
                      "ClpNetworkMatrix.hpp",
                      "ClpNode.hpp",
                      "ClpNonLinearCost.hpp",
                      "ClpObjective.hpp",
                      "ClpPackedMatrix.hpp",
                      "ClpParam.hpp",
                      "ClpParameters.hpp",
                      "ClpParamUtils.hpp",
                      "ClpPdco.hpp",
                      "ClpPdcoBase.hpp",
                      "ClpPEDualRowDantzig.hpp",
                      "ClpPEDualRowSteepest.hpp",
                      "ClpPEPrimalColumnDantzig.hpp",
                      "ClpPEPrimalColumnSteepest.hpp",
                      "ClpPESimplex.hpp",
                      "ClpPlusMinusOneMatrix.hpp",
                      "ClpPredictorCorrector.hpp",
                      "ClpPresolve.hpp",
                      "ClpPrimalColumnDantzig.hpp",
                      "ClpPrimalColumnPivot.hpp",
                      "ClpPrimalColumnSteepest.hpp",
                      "ClpPrimalQuadraticDantzig.hpp",
                      "ClpQuadraticObjective.hpp",
                      "ClpSimplex.hpp",
                      "ClpSimplexDual.hpp",
                      "ClpSimplexNonlinear.hpp",
                      "ClpSimplexOther.hpp",
                      "ClpSimplexPrimal.hpp",
                      "ClpSolve.hpp",
                      "ClpSolver.hpp",
//                      "CoinAbcBaseFactorization.hpp",
//                      "CoinAbcCommon.hpp",
//                      "CoinAbcCommonFactorization.hpp",
//                      "CoinAbcDenseFactorization.hpp",
//                      "CoinAbcFactorization.hpp",
//                      "CoinAbcHelperFunctions.hpp",
//                      "CoinTypes.hpp",
//                      "config_clp_default.h”,
//                      "config_clp.h.in”,
//                      "config.h.in”,
//                      "configall_system_aaplxcode.h”,
//                      "configall_system_msc.h”,
//                      "configall_system.h”,
                      "Idiot.hpp"
//                      "MyEventHandler.hpp",
//                      "MyMessageHandler.hpp"
                    ],
            sources: ["CbcOrClpParam.cpp",
                      //"ClpMain.cpp",
                      "ClpParam.cpp",
                      "ClpParameters.cpp",
                      "ClpParamUtils.cpp",
                      "ClpSolver.cpp",
                      "Clp_C_Interface.cpp",
                      "ClpCholeskyBase.cpp",
                      "ClpCholeskyDense.cpp",
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
                      "Idiot.cpp",
                      "IdiSolve.cpp",
                      "ClpPESimplex.cpp",
                      "ClpPEPrimalColumnDantzig.cpp",
                      "ClpPEPrimalColumnSteepest.cpp",
                      "ClpPEDualRowDantzig.cpp",
                      "ClpPEDualRowSteepest.cpp"
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
                //.define("CLP_BUILD", to: "1"),
                .define("CLPLIB_BUILD", to: "1"),
                .define("_LIB", to: "1"),
                .headerSearchPath(".")
            ]
        ),
        .target(
            name: "libOsiClp",  // internal name – can be anything
            dependencies: ["libClp",
                           .product(name: "libCoinUtils", package: "CoinUtils"),
                           .product(name: "libOsi", package: "Osi")
                          ],
            path: "src/OsiClp",    // The folder containing the C++ source files

            // ---- Public headers --------------------------------------------------------------
            // Anything under `publicHeadersPath` becomes visible to *other* packages.
            // It also tells SPM where to look for the headers when it builds a Clang module.
            publicHeadersPath: ".",          // Anything inside src that ends with .h/.hpp becomes a public Clang module
            
            // ---- C++‑specific settings --------------------------------------------------------
            cxxSettings: [
                // Use the C++20 (or C++23) dialect – change if you need a different version.
                //.cxxStandard("c++20"), // use user default, aka Xcode version
                
                .define("OSICLPLIB_BUILD", to: "1"),
                .define("_LIB", to: "1"),
                .define("COIN_XCODE", to: "1"),
                
                // Tell the compiler where to find your headers from path sources
                .headerSearchPath(".")
            ]
        ),
        .executableTarget( // The executable that *runs* tests (like a CLI test harness)
            name: "osiUnitTest",
            dependencies: ["libClp", "libOsiClp",
                .product(name: "libCoinUtils", package: "CoinUtils"),
                .product(name: "libOsi", package: "Osi"),
                .product(name: "libOsiCommonTest", package: "Osi")
            ],
            path: "test",
            cxxSettings:  [
                .define("COIN_XCODE", to: "1")
            ]
        ),
        .testTarget( // add *XCTest* tests that import the executable's code (not always needed)
            name: "XCosiUnitTest",
            dependencies: ["osiUnitTest"],
            path: "Xcode/XCTest"
            )
        
    ]
)

