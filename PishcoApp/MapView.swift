

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var region: MKCoordinateRegion

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("نقشه جمع‌آوری روغن سوخته خوراکی")
    }
}
