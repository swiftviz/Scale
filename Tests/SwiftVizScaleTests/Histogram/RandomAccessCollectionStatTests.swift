//
//  RandomAccessCollectionStatTests.swift
//  

import XCTest
import SwiftVizScale

final class RandomAccessCollectionStatTests: XCTestCase {
    
    let listIntOutliers:[Int] = [3,6,2,2,65,7,5,2,21,5,7,8]
    let listDoubleOutliers:[Double] = [3,6,2,2,65,7,5,2,21,5,7,8]
    
    let listIntClose:[Int] = [3,6,2,2,7,5,2,5,7,8,4,2,5,4,3,6]
    let listDoubleClose:[Double] = [3,6,2,2,7,5,2,5,7,8,4,2,5,4,3,6]
    
    func testIntSums() throws {
        XCTAssertEqual(listIntOutliers.sum, 133)
    }
    
    func testDoubleSums() throws {
        XCTAssertEqual(listDoubleOutliers.sum, 133)
    }
    
    func testIntSumSquared() throws {
        XCTAssertEqual(listIntOutliers.sumSquared, 4935)
    }
    
    func testDoubleSumSquared() throws {
        XCTAssertEqual(listDoubleOutliers.sumSquared, 4935)
    }

    func testEmptyIntAverage() throws {
        let x:[Int]=[]
        XCTAssertEqual(x.avg, 0)
    }
    
    func testEmptyDoubleAverage() throws {
        let x:[Double]=[]
        XCTAssertEqual(x.avg, 0)
    }
    
    func testIntAverage() throws {
        XCTAssertEqual(listIntOutliers.avg, 11.083, accuracy: 0.001)
        XCTAssertEqual(listIntClose.avg, 4.4375, accuracy: 0.001)
    }
    
    func testDoubleAverage() throws {
        XCTAssertEqual(listDoubleOutliers.avg, 11.083, accuracy: 0.001)
        XCTAssertEqual(listDoubleClose.avg, 4.4375, accuracy: 0.001)
    }

    func testEmptyIntStdDev() throws {
        let x:[Int]=[]
        XCTAssertNil(x.stdDev)
    }
    
    func testEmptyDoubleStdDev() throws {
        let x:[Double]=[]
        XCTAssertNil(x.stdDev)
    }
    
    func testIntStdDev() throws {
        XCTAssertNotNil(listIntOutliers.stdDev)
        XCTAssertEqual(listIntOutliers.stdDev!, 17.7377, accuracy: 0.001)
        XCTAssertEqual(listIntClose.stdDev!, 1.9989, accuracy: 0.001)
    }
    
    func testDoubleStdDev() throws {
        XCTAssertNotNil(listDoubleOutliers.stdDev)
        XCTAssertEqual(listDoubleOutliers.stdDev!, 17.7377, accuracy: 0.001)
        XCTAssertEqual(listDoubleClose.stdDev!, 1.9989, accuracy: 0.001)
    }

    func testCollectionPairs() throws {
        let x = [1,2,3,6,10]
        let paired = Array(x.pairs())
        XCTAssertEqual(paired.count, 4)
        XCTAssertEqual(paired[0].0, 1)
        XCTAssertEqual(paired[0].1, 2)

        XCTAssertEqual(paired[1].0, 2)
        XCTAssertEqual(paired[1].1, 3)

        XCTAssertEqual(paired[2].0, 3)
        XCTAssertEqual(paired[2].1, 6)

        XCTAssertEqual(paired[3].0, 6)
        XCTAssertEqual(paired[3].1, 10)
    }
}
