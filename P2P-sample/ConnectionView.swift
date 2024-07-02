import SwiftUI
import MultipeerConnectivity

struct ConnectionView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var multipeerSession = MultipeerSession()

    var body: some View {
        VStack {
            Text("P2P Communication")
            Button(action: {
                self.sendData()
            }) {
                Text("Send Data")
            }

            Text("非アクティブ: \(appState.inactiveCount)")
                .foregroundColor(.red)
                .padding()
        }
        .onChange(of: appState.isActive) {
            if !appState.isActive {
                showAlert()
            }
        }
    }

    func sendData() {
        let data = "Hello, World!".data(using: .utf8)!
        try? multipeerSession.session.send(data, toPeers: multipeerSession.session.connectedPeers, with: .reliable)
    }

    func showAlert() {
        // アラートを表示する処理をここに追加します
        print("App moved to background.")
    }
}

class AppState: ObservableObject {
    @Published var isActive: Bool = true
    @Published var inactiveCount: Int = 0

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func handleAppBecameActive() {
        DispatchQueue.main.async {
            self.isActive = true
        }
    }

    @objc func handleAppResignActive() {
        DispatchQueue.main.async {
            self.isActive = false
            self.inactiveCount += 1
        }
    }
}

#Preview {
    ConnectionView().environmentObject(AppState())
}
