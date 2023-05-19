//
//  TopView.swift
//  HMTrading
//
//  Created by Kirill Kubarskiy on 17.05.23.
//

import SwiftUI

struct TopView: View {

    let traders: [Trader] = [
        Trader(id: UUID(), number: 0, country: "0", name: "0", deposit: 0, profit: 0),
        Trader(id: UUID(), number: 1, country: "bel", name: "Kirill", deposit: 25200, profit: 42000),
        Trader(id: UUID(), number: 2, country: "china", name: "Oliver", deposit: 11000, profit: 35412),
        Trader(id: UUID(), number: 3, country: "bel", name: "Mihail", deposit: 10000, profit: 23134),
        Trader(id: UUID(), number: 4, country: "italy", name: "Vasya", deposit: 9000, profit: 22500),
        Trader(id: UUID(), number: 5, country: "pol", name: "Stepan", deposit: 8000, profit: 21322),
        Trader(id: UUID(), number: 6, country: "pol", name: "Max", deposit: 7400, profit: 13500),
        Trader(id: UUID(), number: 7, country: "italy", name: "John", deposit: 6100, profit: 7100),
        Trader(id: UUID(), number: 8, country: "bel", name: "Kirill", deposit: 5300, profit: 5500),
        Trader(id: UUID(), number: 9, country: "china", name: "Valentin", deposit: 3200, profit: 4040),
        Trader(id: UUID(), number: 10, country: "pol", name: "Ilya", deposit: 2000, profit: 3010),
    ]

    var body: some View {
        ZStack {
            Color(hex: "#1E2131").ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Top 10 traders")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .padding()

                ForEach(Array(traders.enumerated()), id: \.element.id) { index, trader in
                  TraderRowView(trader: trader, isHeader: index == 0, isEven: ((index % 2) != 0))
                        .frame(height: 50)
                        .background((index % 2 != 0) ? Color(hex: "#1C1F2D") : Color(hex: "#2E303E"))
                        .cornerRadius(isCornerRow(index: index) ? 10:0, corners: setupCorners(index: index))

                }

                Spacer()
            }.padding(.top, 29)
            .padding(.horizontal, 12)
        }
    }

  private func isCornerRow(index: Int) -> Bool {
    switch index {
    case 0: return true
    case traders.count-1: return true
    default: return false
    }
  }

  private func setupCorners(index: Int) -> UIRectCorner {
    switch index {
    case 0: return [UIRectCorner.topLeft, UIRectCorner.topRight]
    case traders.count-1: return [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
    default: return []
    }
  }

}

struct TraderRowView: View {
    let trader: Trader
    let isHeader: Bool
    var isEven: Bool

    var body: some View {
        if isHeader {
            HStack(spacing: 0) {
                Spacer()
                Text("№")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#C1C2C8"))
                    .padding(.leading)
                Text("Country")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#C1C2C8"))
                    .frame(maxWidth: .infinity)
                Text("Name")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#C1C2C8"))
                    .frame(maxWidth: .infinity)
                Text("Deposit")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#C1C2C8"))
                    .frame(maxWidth: .infinity)
                Text("Profit")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#C1C2C8"))
                    .frame(maxWidth: .infinity)
            }
            .background(Color(hex: "#2E303E"))
        } else {
            HStack(spacing: 0) {
                Spacer()
                Text("\(trader.number)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#FFFFFF"))
                    .padding(.leading)
                Image(trader.country)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity)
                Text(trader.name)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#FFFFFF"))
                    .frame(maxWidth: .infinity)
                Text("$\(trader.deposit)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#FFFFFF"))
                    .frame(maxWidth: .infinity)
                Text("$\(trader.profit)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#35B972"))
                    .frame(maxWidth: .infinity)
            }
            .background(isEven ? Color(hex: "#1C1F2D") : Color(hex: "#2E303E"))
        }
    }
}









struct TopView_Previews: PreviewProvider {
  static var previews: some View {
    //      TraderRowView(trader: Trader(id: UUID(), number: 1, country: "bel", name: "Kirill", deposit: 10000, profit: 20000), isHeader: false)
    TopView()
  }
}


struct Trader: Identifiable {
  let id: UUID
  let number: Int
  let country: String
  let name: String
  let deposit: Int
  let profit: Int
}


struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
