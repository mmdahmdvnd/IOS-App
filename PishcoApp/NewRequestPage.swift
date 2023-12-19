import SwiftUI

struct NewRequestPage: View {
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var address = ""
    @State private var selectedWasteType = 0
    @State private var notes = ""
    private var addressServer = "https://android-material.ir/"
    private var endpoint = "test/login_.php"
    @Binding var requests: [Request] // لیست درخواست‌ها
    @Binding var isShowingNewRequestPage: Bool // برای بستن صفحه جدید
    var wasteTypes = ["روغن خوراکی", "دیگر زباله‌ها"]
    
    init(requests: Binding<[Request]>, isShowingNewRequestPage: Binding<Bool>) {
           self._requests = requests
           self._isShowingNewRequestPage = isShowingNewRequestPage
       }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("اطلاعات کاربر")) {
                    TextField("نام و نام خانوادگی", text: $name)
                    TextField("شماره تلفن", text: $phoneNumber)
                }

                Section(header: Text("آدرس و موقعیت")) {
                    TextField("آدرس", text: $address)
                }

                Section(header: Text("نوع زباله")) {
                    Picker("نوع زباله", selection: $selectedWasteType) {
                        ForEach(0..<wasteTypes.count) {
                            Text(self.wasteTypes[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("توضیحات اضافی")) {
                    TextEditor(text: $notes)
                }

                Button(action: {
                    self.sendRequestToServer { result in
                        switch result {
                        case .success(let response):
                            print("پاسخ از سرور: \(response)")
                            self.requests.append(Request(title: "درخواست جدید"))
                            
                            DispatchQueue.main.async {
                                self.isShowingNewRequestPage = false
                            }
                        case .failure(let error):
                            print("خطا در ارتباط با سرور: \(error)")
                            print("Error: \(error)")
                        }
                    }
                }) {
                    Text("ثبت درخواست جمع‌آوری")
                }
            }
            .navigationBarTitle("درخواست جمع‌آوری")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isShowingNewRequestPage = false
                }) {
                    Text("بازگشت")
                }
            )
        }
    }

    struct ResponseModel: Decodable {
           let status: String
           let message: String
           // اگر اطلاعات بیشتری نیاز دارید، آنها را نیز به عنوان پراپرتی‌ها اینجا اضافه کنید
       }
              
       func sendRequestToServer(completion: @escaping (Result<ResponseModel, Error>) -> Void) {
           let parameters: [String: Any] = [
               "name": name,
               "phoneNumber": phoneNumber,
               "address": address,
               "wasteType": wasteTypes[selectedWasteType],
               "notes": notes
           ]
           guard let url = URL(string: addressServer + endpoint) else {
               completion(.failure(NSError(domain: "خطا", code: 400, userInfo: nil)))
               return
           }
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
           } catch {
               completion(.failure(error))
               return
           }
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               guard let data = data else {
                   completion(.failure(NSError(domain: "خطا", code: 400, userInfo: nil)))
                   return
               }
               do {
                   let responseJSON = try JSONDecoder().decode(ResponseModel.self, from: data)
                   completion(.success(responseJSON))
               } catch {
                   completion(.failure(error))
               }
           }.resume()
       }
}
