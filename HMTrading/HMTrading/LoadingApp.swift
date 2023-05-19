//
//  LoadingApp.swift
//  HMTrading
//
//  Created by Kirill Kubarskiy on 17.05.23.
//

import SwiftUI


struct LoadingApp: View {
    @State private var progress: CGFloat = 0.0 // Значение прогресса (от 0 до 1)
    @State private var currentStep: Int = 0 // Текущий шаг
    @State private var isLoadingComplete = false // Флаг завершения загрузки

    let stepDuration: Double = 1.0 // Длительность одного шага (в секундах)
    let totalSteps: Int = 5 // Общее количество шагов

    var body: some View {
        Group {
            if isLoadingComplete {
                ActivateView()
            } else {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 300, height: 24)
                        .foregroundColor(.gray)
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 300 * progress, height: 24)
                        .foregroundColor(.green)
                    Text("\(currentStep * 20)%")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 24)
                        .font(.system(size: 14))
                }.background(Image("bg"))
                .onAppear {
                    startProgressBar()
                }
            }
        }
    }

    func startProgressBar() {
        let stepProgress: CGFloat = 0.2 // Прогресс за каждый шаг

        for step in 1...totalSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (stepDuration * Double(step))) {
                withAnimation(.linear(duration: stepDuration)) {
                    progress = CGFloat(step) * stepProgress
                    currentStep = step
                }

                if step == totalSteps {
                    isLoadingComplete = true // Помечаем загрузку как завершенную
                }
            }
        }
    }
}







struct LoadingApp_Previews: PreviewProvider {
    static var previews: some View {
        LoadingApp()
    }
}
