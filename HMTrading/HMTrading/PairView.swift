//
//  PairView.swift
//  HMTrading
//
//  Created by Kirill Kubarskiy on 18.05.23.
//

import SwiftUI

struct PairView: View {
  @Environment(\.presentationMode) var presentationMode

  let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  @Binding var selectedPair: CurrencyPair?   // Переменная для хранения выбранной пары
  var onPairSelected: ((CurrencyPair) -> Void)?

  var body: some View {
    ZStack {
      Color(hex: "#1E2131").ignoresSafeArea()
      VStack(spacing: 0) {
        HStack {
          Button(action: {
            presentationMode.wrappedValue.dismiss()
          }) {
            Image(systemName: "chevron.left")
              .foregroundColor(.white)
              .onTapGesture {
                presentationMode.wrappedValue.dismiss()
              }
          }
          Spacer()
          Text("Currency pair")
            .font(.system(size: 22))
            .foregroundColor(.white)
            .padding()
          Spacer()
        }
        .padding()

        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(CurrencyPair.allCases, id: \.self) { pair in
            Rectangle()
              .fill(pair == selectedPair ? Color.green : Color(hex: "#333749"))  // Изменение цвета в зависимости от выбранной пары
              .frame(height: 54)
              .cornerRadius(12)
              .overlay(
                Text(pair.rawValue)
                  .font(.system(size: 16))
                  .foregroundColor(Color(hex: "#FFFFFF"))
              )
              .onTapGesture {
                selectedPair = pair
                                    onPairSelected?(pair)  // Вызов замыкания с выбранной парой

              }
          }
        }
        .padding(.horizontal, 30)

        Spacer()
      }
      .padding(.top, 29)
      .padding(.horizontal, 12)
    }
  }
}

enum CurrencyPair: String, CaseIterable {
  case gbpUsd = "GBP/USD"
  case eurUsd = "EUR/USD"
  case usdJpy = "USD/JPY"
  case btcUsd = "BTC/USD"

  var htmlFileName: String {
    switch self {
    case .gbpUsd:
      return "gbp_usd"
      case .eurUsd:
        return "eur_usd"
      case .usdJpy:
        return "usd_jpy"
    case .btcUsd:
      return "btc_usd"
    }
  }
}





