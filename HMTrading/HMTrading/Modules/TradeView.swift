//
//  TradeView.swift
//  HMTrading
//
//  Created by Kirill Kubarskiy on 17.05.23.
//

import SwiftUI
import WebKit

struct TradeView: View {
  @State private var balance: Double = 1000.0
  @State private var isShowingBanner = false
  @State private var bannerMessage = ""
  @State private var timeInSeconds = 1
  @State private var amount = 1000
  @State private var webView: WKWebView?

  @State private var selectedPair: CurrencyPair?

  @State private var isShowPairView = false
  var body: some View {
    ZStack {
      Color(hex: "#1E2131").ignoresSafeArea()
      VStack(spacing: 0) {
        Text("Trade")
          .font(.system(size: 22))
          .foregroundColor(.white)
          .padding()

        Rectangle()
          .fill(Color(hex: "#333749"))
          .frame(height: 54)
          .cornerRadius(12)
          .padding(.horizontal, 30)
          .overlay(
            VStack(spacing: 7) {
              Text("Balance")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#C8C8C8"))
                .padding(.top, 5)
              Text("\(balance)")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#FFFFFF"))
                .padding(.bottom, 8)
            }
          )

        TradingViewWidget(webView: $webView, selectedPair: selectedPair)
          .background(Color(hex: "#121629"))
          .padding(.vertical)

        Rectangle()
          .fill(Color(hex: "#333749"))
          .frame(height: 54)
          .cornerRadius(12)
          .padding(.horizontal, 30)
          .overlay(

            Text(selectedPair?.rawValue ?? "GBP/USD")
              .font(.system(size: 16))
              .foregroundColor(Color(hex: "#FFFFFF"))


          ).onTapGesture {
            // Действие, выполняемое при нажатии на прямоугольник
            print("USD pressed")
            isShowPairView = true
          }.fullScreenCover(isPresented: $isShowPairView) {
            PairView(selectedPair: $selectedPair, onPairSelected: { pair in
              selectedPair = pair  // Получение выбранной пары из PairView
            })
          }


        VStack {
          HStack(alignment: .center, spacing: 11) {
            Rectangle()
              .fill(Color(hex: "#333749"))

              .cornerRadius(12)

              .overlay(
                VStack(alignment: .center, spacing: 7) {
                  Text("Timer")
                    .foregroundColor(Color(hex: "#FFFFFF"))
                    .padding(.top, 5)

                  HStack(alignment: .center, spacing: 8) {
                    Image("minus")
                      .onTapGesture {
                        updateTime(-1)
                      }
                    Text(formatTime())
                    Image("plus")
                      .onTapGesture {
                        updateTime(1)
                      }
                  }
                  .padding(.bottom, 8)
                }
                  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
              )
              .frame(height: 54)
              .padding(.leading, 30)

            Rectangle()
              .fill(Color(hex: "#333749"))
              .cornerRadius(12)
              .overlay(
                VStack(alignment: .center, spacing: 7) {
                  Text("Investment")
                    .foregroundColor(Color(hex: "#FFFFFF"))
                    .padding(.top, 5)

                  HStack(alignment: .center, spacing: 8) {
                    Image("minus")
                      .onTapGesture {
                        updateAmount(-100)
                      }
                    Text(formatAmount())
                    Image("plus")
                      .onTapGesture {
                        updateAmount(100)
                      }
                  }
                  .padding(.bottom, 8)
                }
                  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
              )
              .frame(height: 54)
              .padding(.trailing, 30)

              .onTapGesture {
                // Действие, выполняемое при нажатии на прямоугольник
                print("USD pressed")
              }
          }
        }.padding(.top, 10)

        VStack {
          HStack(alignment: .center, spacing: 11) {
            Rectangle()
              .fill(Color(hex: "#FE3D43"))
              .cornerRadius(12)
              .overlay(
                VStack(alignment: .center, spacing: 7) {
                  Text("Sell")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "#FFFFFF"))
                }
              )
              .frame(height: 54)
              .padding(.leading, 30)
              .onTapGesture {
                performSellAction()
              }

            Rectangle()
              .fill(Color(hex: "#35B972"))
              .cornerRadius(12)
              .overlay(
                VStack(alignment: .center, spacing: 7) {
                  Text("Buy")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "#FFFFFF"))
                }
              )
              .frame(height: 54)
              .padding(.trailing, 30)
              .onTapGesture {
                performBuyAction()
              }
          }
        }

        .padding(.top, 10)
        .overlay(
          ZStack {
            if isShowingBanner {
              BannerView(message: bannerMessage, isShowing: $isShowingBanner)
                .frame(maxWidth: .infinity)
            }
          }
        )

        Spacer()
      }
      .padding(.top, 29)
      .padding(.horizontal, 12)
    }
  }

  private func performSellAction() {
    if balance > 0 {
      balance -= 1.0
      bannerMessage = "Successfully sold"
    } else {
      bannerMessage = "Insufficient balance"
    }
    showBanner()
  }

  private func performBuyAction() {
    if balance > 0 {
      let shouldAddProfit = Bool.random() // 50/50 chance
      if shouldAddProfit {
        balance += 0.7
        bannerMessage = "Successfully bought with profit"
      } else {
        bannerMessage = "Successfully bought without profit"
      }
    } else {
      bannerMessage = "Insufficient balance"
    }
    showBanner()
  }

  private func showBanner() {
    isShowingBanner = true
  }
  private func updateTime(_ increment: Int) {
    timeInSeconds += increment

    if timeInSeconds < 0 {
      timeInSeconds = 0
    }

    let minutes = timeInSeconds / 60
    let seconds = timeInSeconds % 60

    // Handle rollover if seconds exceed 60
    if seconds >= 60 {
      timeInSeconds = minutes * 60
    }
  }

  private func formatTime() -> String {
    let minutes = timeInSeconds / 60
    let seconds = timeInSeconds % 60

    return String(format: "%02d:%02d", minutes, seconds)
  }

  private func updateAmount(_ increment: Int) {
    amount += increment

    if amount < 0 {
      amount = 0
    }
  }

  private func formatAmount() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal

    return formatter.string(from: NSNumber(value: amount)) ?? ""
  }
}

struct TradingViewWidget: UIViewRepresentable {
  @Binding var webView: WKWebView?
  let selectedPair: CurrencyPair?

  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    self.webView = webView
    return webView
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {
    let htmlFileName = selectedPair?.htmlFileName ?? "gbp_usd"
    guard let htmlPath = Bundle.main.path(forResource: htmlFileName, ofType: "html") else {
      return
    }
    let htmlUrl = URL(fileURLWithPath: htmlPath)
    uiView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
  }
}



struct BannerView: View {
  let message: String
  @Binding var isShowing: Bool

  var body: some View {
    VStack {
      Text(message)
        .foregroundColor(.white)
        .padding()
        .background(Color.green)
        .cornerRadius(12)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowing = false
          }
        }
    }
    .padding(.top, 10)
    .animation(.easeInOut)
    .frame(maxWidth: .infinity)
    .background(Color.clear)
    .edgesIgnoringSafeArea(.top)
  }
}
