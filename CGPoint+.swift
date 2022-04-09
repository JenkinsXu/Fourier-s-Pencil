//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-08.
//

import CoreGraphics
import Accelerate

extension CGPoint {
    static func inComplexPlane(at complexNumber: DSPComplex) -> CGPoint {
        return CGPoint(x: CGFloat(complexNumber.real), y: CGFloat(complexNumber.imag))
    }
}

extension CGPoint: AccelerateMutableBuffer {
    
    public typealias Element = Double
    
    public var count: Int { 2 }
    
    public func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Double>) throws -> R) rethrows -> R {
        try body(withUnsafeBytes(of: self) { unsafeRawBufferPointer in
            unsafeRawBufferPointer.bindMemory(to: Double.self)
        })
    }
    
    public mutating func withUnsafeMutableBufferPointer<R>(_ body: (inout UnsafeMutableBufferPointer<Double>) throws -> R) rethrows -> R {
        var unsafeMutableBufferPointer =  withUnsafeMutableBytes(of: &self) {unsafeRawBufferPointer in
            unsafeRawBufferPointer.bindMemory(to: Double.self)
        }
        return try body(&unsafeMutableBufferPointer)
    }
    
}

extension Array where Element == CGPoint {
    static func + (left: [CGPoint], right: [CGPoint]) -> [CGPoint] {
        guard left.count == right.count else {
            fatalError("Unmatched input size.")
        }
        return (0..<left.count).map { index in
            var sum: CGPoint = .zero
            vDSP.add(left[index], right[index], result: &sum)
            return sum
        }
    }
}
