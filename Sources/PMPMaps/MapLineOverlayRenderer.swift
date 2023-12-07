//
//  MapLineOverlayRenderer.swift
//  GoogleMapSample
//
//  Created by Anand  on 06/12/23.
//  Copyright © 2023 Md. Saber Hossain. All rights reserved.
//

import Foundation
import MapKit

public class MapLineOverlayRenderer: MKOverlayPathRenderer {
    private let lineOverlay: LineOverlay

    public init(_ lineOverlay: LineOverlay) {
        self.lineOverlay = lineOverlay
        super.init(overlay: lineOverlay)
        lineWidth = lineOverlay.style.lineWidth
        strokeColor = lineOverlay.style.strokeColor
        alpha = lineOverlay.style.alpha
        invalidatePath()
    }

    override public func createPath() {
        guard let originCoordinate = lineOverlay.coordinates.first,
            let destinationCoordinate = lineOverlay.coordinates.last else { return }
        let origin = point(for: MKMapPoint(originCoordinate))
        let destination = point(for: MKMapPoint(destinationCoordinate))
        path = lineOverlay.path(origin, destination)
        lineOverlay.boundsMapRect = mapRect(for: path.boundingBox)
    }
}
