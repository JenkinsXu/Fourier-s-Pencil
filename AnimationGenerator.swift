//
//  File.swift
//  Fourier's Pencil
//
//  Created by Yongqi Xu on 2022-04-08.
//

import Foundation
import Accelerate
import PencilKit

struct AnimationGenerator {
    
    private let xCoordinates: [Float]
    private let yCoordinates: [Float]
    static let numberOfFrames = 512
    
    struct NumericError: Error {}
    struct Epicycle {
        let timedLocations: [CGPoint]
        func location(atTime time: Int) -> CGPoint {
            return timedLocations[time]
        }
    }
    
    init(path: PKStrokePath) {
        let numberOfSamples = AnimationGenerator.numberOfFrames
        let stepSize = Double(path.count) / Double(numberOfSamples)
        let locations = stride(from: 0.0, to: Double(path.count), by: stepSize).map {
            path.interpolatedLocation(at: CGFloat($0))
        }
        self.xCoordinates = locations.map { Float($0.x) }
        self.yCoordinates = locations.map { Float($0.y) }
    }
    
    private func discreteFourierTransform(real: [Float], imaginary: [Float]) throws -> (real: [Float], imaginary: [Float]) {
        guard
            log2(Double(real.count)).truncatingRemainder(dividingBy: 1) == 0 &&
            log2(Double(imaginary.count)).truncatingRemainder(dividingBy: 1) == 0 &&
            real.count == imaginary.count
        else {
            throw NumericError()
        }
        
        let count = real.count
        let forwardDFT = try vDSP.DiscreteFourierTransform(count: count,
                                                           direction: .forward,
                                                           transformType: .complexComplex,
                                                           ofType: Float.self)
        return forwardDFT.transform(real: real, imaginary: imaginary)
    }
    
    func epicycles() throws -> [Epicycle] {
        let (dftReal, dftImaginary) = try discreteFourierTransform(real: xCoordinates, imaginary: yCoordinates)
        let complexValuesCount = dftReal.count
        let indices = Array(0..<complexValuesCount).map { Float($0) }
        let factors = (0..<complexValuesCount).map { time -> [CGPoint] in
            let scalar = 2 * Float.pi * Float(time)
            let elementwiseProduct = vDSP.multiply(scalar, indices)
            
            let exponent = vDSP.divide(elementwiseProduct, Float(complexValuesCount))
            let exponentReal = vForce.cos(exponent)
            let exponentImaginary = vForce.sin(exponent)
            
            var centerReal = vDSP.divide(
                vDSP.subtract(
                    vDSP.multiply(dftReal[time], exponentReal),
                    vDSP.multiply(dftImaginary[time], exponentImaginary)),
                Float(complexValuesCount)
            )
            var centerImaginary = vDSP.divide(
                vDSP.add(
                    vDSP.multiply(dftReal[time], exponentImaginary),
                    vDSP.multiply(dftImaginary[time], exponentReal)),
                Float(complexValuesCount)
            )
            
            var factorInterleaved = [DSPComplex](repeating: DSPComplex(),
                                                 count: complexValuesCount)
            centerReal.withUnsafeMutableBufferPointer { centerRealPointer in
                centerImaginary.withUnsafeMutableBufferPointer { centerImaginaryPointer in
                    var splitComplex = DSPSplitComplex(realp: centerRealPointer.baseAddress!,
                                                       imagp: centerImaginaryPointer.baseAddress!)
                    vDSP_ztoc(&splitComplex, 1,
                              &factorInterleaved, 2,
                              vDSP_Length(complexValuesCount))
                }
            }
            
            return factorInterleaved.map { CGPoint.inComplexPlane(at: $0) }
        }
        
        var result = [Epicycle]()
        result.append(Epicycle(timedLocations: [CGPoint](repeating: .zero, count: complexValuesCount)))
        
        for factor in factors {
            guard let last = result.last else { continue }
            result.append(Epicycle(timedLocations: last.timedLocations + factor))
        }
        
        return result
    }
}

extension Array where Element == AnimationGenerator.Epicycle {
    func toKeyframes() -> [[CGPoint]]? {
        guard !self.isEmpty else { return nil }
        let count = self.first!.timedLocations.count
        return (0..<count).map { time in
            self.map { epicycle in
                epicycle.location(atTime: time)
            }
        }
    }
}
