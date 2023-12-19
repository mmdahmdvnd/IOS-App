import SwiftUI

struct ContentView: View {
    
    @StateObject private var mapViewModel = MapViewModel()
    @StateObject private var collectionViewModel = CollectionRequestViewModel()
//     @EnvironmentObject var mapViewModel: MapViewModel
//     @EnvironmentObject var collectionViewModel: CollectionRequestViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
              VStack {
                 MapView(region: $mapViewModel.region)
                       .frame(height: 300)
                       .edgesIgnoringSafeArea(.top)
                // سطر اول: اسکرول افقی از 5 تصویر
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0..<5, id: \.self) { index in
                            Rectangle()
                                .fill(Color(red: 61/255, green: 198/255, blue: 150/255))
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                
                // سطر دوم: تصویر با ابعاد نصف صفحه و NavigationLink
                NavigationLink(destination: CollectionRequestView(viewModel: collectionViewModel)) {
                    Image(systemName: "1.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 20, height: geometry.size.height / 2)
                        .cornerRadius(10)
                }
                
                Spacer().frame(height: 50) // فاصله بین سطر دوم و سوم
                
                // سطر سوم: تصویر با ابعاد یک چهارم صفحه
                Image(systemName: "2.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 20, height: geometry.size.height / 2)
                    .cornerRadius(10)
                
                Spacer().frame(height: 40) // فاصله بین سطر سوم و چهارم
                
                // سطر چهارم: شبکه از 9 تصویر (3 تصویر در هر سطر)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(0..<9, id: \.self) { index in
                        Image(systemName: "\(index).square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: (geometry.size.width - 40) / 3, height: (geometry.size.width - 40) / 3)
                            .cornerRadius(10)
                    }
                }
                .padding()
                }
            }
            .background(Color.gray.opacity(0.1)) // زمینه صفحه
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
