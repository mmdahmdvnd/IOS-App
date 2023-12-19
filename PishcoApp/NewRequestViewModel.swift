
import Foundation
import Combine

class NewRequestViewModel: ObservableObject {
    @Published var name = ""
    @Published var phoneNumber = ""
    @Published var address = ""
    @Published var selectedWasteType = 0
    @Published var notes = ""    
    private var addressServer = "https://android-material.ir/"
    private var endpoint = "test/login_.php"
    @Published var requests: [Request]
    @Published var isShowingNewRequestPage: Bool
    var wasteTypes = ["روغن خوراکی", "دیگر زباله‌ها"]

    init(collectionViewModel: CollectionRequestViewModel, isShowingNewRequestPage: Bool) {
            self.isShowingNewRequestPage = isShowingNewRequestPage
            self.requests = collectionViewModel.requests
        }

    func sendRequestToServer() {
        let parameters: [String: Any] = [
            "name": name,
            "phoneNumber": phoneNumber,
            "address": address,
            "wasteType": wasteTypes[selectedWasteType],
            "notes": notes
        ]
        guard let url = URL(string: addressServer + endpoint) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                return
            }
            do {
                let responseJSON = try JSONDecoder().decode(ResponseModel.self, from: data)
                print("Response from server: \(responseJSON)")
                self.requests.append(Request(title: "درخواست جدید"))
                DispatchQueue.main.async {
                    self.isShowingNewRequestPage = false
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }.resume()
    }
    
    struct ResponseModel: Decodable {
            let status: Bool
            let message: String
            // اگر اطلاعات بیشتری نیاز دارید، آنها را نیز به عنوان پراپرتی‌ها اینجا اضافه کنید
        }
}
