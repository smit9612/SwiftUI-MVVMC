///

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    private let coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    func makeUIView(context _: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ view: MKMapView, context _: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        view.addAnnotation(annotation)

        view.setRegion(region, animated: true)
    }
}
