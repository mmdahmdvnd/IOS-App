
import Foundation
import MapKit

class CollectionRequestViewModel: ObservableObject {
    @Published var isShowingNewRequestPage = false
    @Published var requests: [Request] = [
        Request(title: "درخواست 1"),
        Request(title: "درخواست 2"),
        Request(title: "درخواست 3")
    ]
}
