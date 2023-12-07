//
//  LineOverlay.swift
//  GoogleMapSample
//
//  Created by Anand  on 06/12/23.
//  Copyright © 2023 Md. Saber Hossain. All rights reserved.
//

import Foundation
import MapKit

public struct LineOverlayStyle {
    var strokeColor: UIColor
    var lineWidth: CGFloat
    var alpha: CGFloat

    public init(strokeColor: UIColor, lineWidth: CGFloat, alpha: CGFloat) {
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.alpha = alpha
    }
}

public protocol LineOverlaying {
    var coordinates: [CLLocationCoordinate2D] { get }
    var style: LineOverlayStyle { get }
    var boundsMapRect: MKMapRect { get set }

    func path(_ origin: CGPoint, _ destination: CGPoint) -> CGMutablePath
}

public class LineOverlay: MKPolyline, LineOverlaying {
    public private(set) var coordinates: [CLLocationCoordinate2D] = []
    public private(set) var style = LineOverlayStyle(strokeColor: .black,
                                                     lineWidth: 3,
                                                     alpha: 0.15)
    public var boundsMapRect: MKMapRect = .world
    override public var boundingMapRect: MKMapRect {
        return boundsMapRect
    }

    public convenience init(origin: CLLocationCoordinate2D,
                            destination: CLLocationCoordinate2D,
                            style: LineOverlayStyle? = nil) {
        self.init(coordinates: [origin, destination], count: 2)
        coordinates = [origin, destination]
        if let style = style {
            self.style = style
        }
    }

    public func path(_ origin: CGPoint, _ destination: CGPoint) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: origin)
        path.addLine(to: destination)
        return path
    }
}

public class ArcOverlay: LineOverlay {
    public var radiusMultiplier: CGFloat = 1.0

    override public func path(_ origin: CGPoint, _ destination: CGPoint) -> CGMutablePath {

        let path = CGMutablePath()
        path.move(to: origin)
        let utils = ControlPointUtilities()
        let controlPoint = utils.controlPoint(origin, destination, radiusMultiplier: radiusMultiplier)
        path.addQuadCurve(to: destination, control: controlPoint)
        return path
    }
    
    func getCenterPointForPath(_ origin: CGPoint, _ destination: CGPoint) -> CGPoint {
        let utils = ControlPointUtilities()
        let controlPoint = utils.controlPoint(origin, destination, radiusMultiplier: radiusMultiplier)
        return controlPoint
    }
    
    func angle(between starting: CGPoint, ending: CGPoint) -> CGFloat {
        let center = CGPoint(x: ending.x - starting.x, y: ending.y - starting.y)
        let radians = atan2(center.y, center.x)
        let degrees = radians * 180 / .pi
        return degrees > 0 ? degrees : 360 + degrees
    }
}
