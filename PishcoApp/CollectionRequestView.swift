import SwiftUI

struct CollectionRequestView: View {
    @State private var requests: [String] = ["درخواست 1", "درخواست 2", "درخواست 3"] // لیست درخواست‌ها
    @State private var isShowingNewRequestPage = false // برای نشان دادن و پنهان کردن صفحه جدید

    var body: some View {
        NavigationView {
            VStack {
                List(requests, id: \.self) { request in
                    Text(request)
                }
                .navigationBarTitle("درخواست جمع‌آوری")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.isShowingNewRequestPage.toggle()
                    }) {
                        Text("ثبت درخواست جمع‌آوری")
                    }
                )
                
                // اضافه کردن فلاتین اکشن باتن
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.isShowingNewRequestPage.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $isShowingNewRequestPage) {
                NewRequestPage(requests: $requests, isShowingNewRequestPage: $isShowingNewRequestPage)
            }
        }
    }
}

struct CollectionRequestView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionRequestView()
    }
}
