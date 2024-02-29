//
//  ContentView.swift
//  MapGestures
//
//  Created by Gianluca Orpello on 23/02/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    //typealias MapLocation = CLLocationCoordinate2D
    
    let coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @State
    private var tappedCoordinates: [CLLocationCoordinate2D] = []
    
    @State private var selectedItem: MKMapItem?
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var userTrakingMode = MapUserTrackingMode.follow
    
    var body: some View {
        
        GeometryReader { proxy in
            Map(coordinateRegion: $region,
                interactionModes: [.all],
                showsUserLocation: false,
                userTrackingMode: $userTrakingMode,
                annotationItems: tappedCoordinates) { location in
                
                //MapPin(coordinate: location)
                MapMarker(coordinate: location)
                
            }
                .onTapGesture { location in
                    print(location)
                    //                let mapLocation = convertTap(at: location,
                    //                                             for: proxy.size)
                    
                    let coo = convertCoordinates(from: location,
                                                 region: region,
                                                 geo: proxy)
                    print(coo)
                    tappedCoordinates.append(coo)
                }
        }
        .frame(width: 300, height: 300)
    }
    
    func convertCoordinates(from point: CGPoint,
                            region: MKCoordinateRegion,
                            geo: GeometryProxy)
    -> CLLocationCoordinate2D {
        
        
        let mkMapView = MKMapView(frame:
                                    CGRect(x: 0,
                                           y: 0,
                                           width: geo.size.width,
                                           height: geo.size.height)
        )
        
        mkMapView.region = region
        
        let frame = geo.frame(in: .global)
        
        let endCoordinates = mkMapView.convert(point, toCoordinateFrom: mkMapView)
        
        return endCoordinates
    }
    
}

#Preview {
    ContentView()
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}
