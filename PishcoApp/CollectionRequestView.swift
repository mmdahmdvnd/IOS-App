import SwiftUI

struct CollectionRequestView: View {
    @ObservedObject var viewModel: CollectionRequestViewModel
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.requests) { request in
                    Text(request.title)
                }
                .navigationBarTitle("درخواست جمع‌آوری")
                .navigationBarItems(trailing:
                    Button(action: {
                        viewModel.isShowingNewRequestPage.toggle()
                    }) {
                        Text("ثبت درخواست جمع‌آوری")
                    }
                )
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.isShowingNewRequestPage.toggle()
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
            .sheet(isPresented: $viewModel.isShowingNewRequestPage) {
                NewRequestPage(requests: $viewModel.requests, isShowingNewRequestPage: $viewModel.isShowingNewRequestPage)
            }
        }
    }
}

struct CollectionRequestView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionRequestView(viewModel: CollectionRequestViewModel())
    }
}
