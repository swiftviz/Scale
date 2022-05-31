//
//  main.swift - scale-benchmark
//

import Benchmark

// BENCHMARK=1 swift build -c release && .build/release/scale-benchmark --iterations 1000 --time-unit ms

// Dump data into files using additional CLI arguments:
// --format csv > out
// --format json > out

// CSV results:
// name,time,std,iterations
// add string.no capacity,0.029583,13.01280188086373,1000.0
// add string.reserved capacity,0.023542,9.177574092911641,1000.0

// JSON results:
// {
//  "benchmarks": [
//    {
//      "name": "add string.no capacity",
//      "time": 0.038417,
//      "std": 18.551188319727753,
//      "iterations": 1000.0
//    },
//    {
//      "name": "add string.reserved capacity",
//      "time": 0.02575,
//      "std": 9.736185458645437,
//      "iterations": 1000.0
//    }
//  ]
// }

public let addStringBenchmarks = BenchmarkSuite(name: "add string", settings: Iterations(10000)) {
    suite in
    suite.benchmark("no capacity") {
        var x1: String = ""
        for _ in 1 ... 1000 {
            x1 += "hi"
        }
    }

    suite.benchmark("reserved capacity", settings: Iterations(10001)) {
        var x2: String = ""
        x2.reserveCapacity(2000)
        for _ in 1 ... 1000 {
            x2 += "hi"
        }
    }
}

public let suites = [
    addStringBenchmarks,
]

Benchmark.main(suites)
