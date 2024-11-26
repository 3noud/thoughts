import SwiftUI

struct RecordView: View {
    @State public var textInput: String = ""
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var recordingTimer: Timer?
    @State private var recordingCounter: Int = 0
    @State private var isVisualizing = false
    let userDefaultsKey = "SavedTextInput"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            .padding(.top, 50)
            
            HStack {
                Spacer()
                if isSystemLanguageArabic() {
                    Text(LocalizedStringKey("question_1"))
                        .foregroundColor(Color(UIColor(hex: "#514F48")))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 13)
                        .padding(.bottom, 13)
                        .font(.custom("mishafi", size: 40))
                        .accessibilityLabel("سؤال: ما الذي حدث ليجعلني أفكر بهذا التفكير؟")
                } else {
                    Text("Question: What happened to make me think this way?")
                        .foregroundColor(Color(UIColor(hex: "#514F48")))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 13)
                        .padding(.bottom, 13)
                        .font(.custom("Times", size: 25))
                        .accessibilityLabel("Question: What happened to make me think this way?")
                }
            }
            
            TextField(isSystemLanguageArabic() ? "صف ما تشعر به" : "Describe how you feel", text: $textInput)

                .multilineTextAlignment(.center)
                .padding(.bottom, 122.0)
                .padding(.trailing, 8.0)
                .frame(maxWidth: .infinity, maxHeight: 400)
                .frame(width: 350)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding()
            
                .onChange(of: textInput, perform: { value in
                    saveTextToUserDefaults()
                })
                .onAppear {
                    loadTextFromUserDefaults()
                }
                .accessibilityLabel(isSystemLanguageArabic() ? "اجابه طويلة" : "Long answer")

                
                RecordingsList(audioRecorder: audioRecorder)
                
                Text(formattedTime(recordingCounter))
                    .font(.system(size: 33))
                    .fontWeight(.thin)
                
                if audioRecorder.recording == false {
                    Button(action: {
                        self.audioRecorder.startRecording()
                        self.startTimer()
                    }) {
                        Text(isSystemLanguageArabic() ? "سجل" : "Record")
                            .offset(y:9)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.custom("mishafi", size: 40))
                            .padding(.vertical, -15)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor(hex: "#5D5D5D")))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .frame(width: 200)
                            .accessibilityLabel(isSystemLanguageArabic() ? "زر ابدا التسجيل" : "Record button")
                    }
                } else {
                    Button(action: {
                        self.audioRecorder.stopRecording()
                        self.stopTimer()
                    }) {
                        Text(isSystemLanguageArabic() ? "ايقاف" : "Stop")
                            .offset(y:9)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.custom("mishafi", size: 40))
                            .padding(.vertical, -7.48)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor(hex: "#5D5D5D")))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .frame(width: 150)
                            .accessibilityLabel(isSystemLanguageArabic() ? "زر ايقاف التسجيل" : "Stop recording button")
                    }
                }
            }
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: QUSTIONSView()) {
                        HStack {
                            Text(isSystemLanguageArabic() ? "الخلف" : "Back")
                                .foregroundColor(Color(red: 0.473, green: 0.483, blue: 0.457))
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(red: 0.473, green: 0.483, blue: 0.457))
                                .accessibilityLabel("زر")
                        }
                    }
                }
            }
            .padding(.vertical, 40.0)
            .background(Color(UIColor(hex: "#F9F9F8")))
            .edgesIgnoringSafeArea(.all)
        
    }
    func isSystemLanguageArabic() -> Bool {
            return Locale.current.languageCode == "ar"
        }
    
    private func startTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.recordingCounter += 1
        }
    }
    
    private func stopTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        recordingCounter = 0
    }
    
    private func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    private func loadTextFromUserDefaults() {
        if let savedText = UserDefaults.standard.string(forKey: userDefaultsKey) {
            textInput = savedText
            print("Text loaded from UserDefaults: \(savedText)")
        }
    }
    private func saveTextToUserDefaults() {
          UserDefaults.standard.set(textInput, forKey: userDefaultsKey)
          print("Text saved to UserDefaults: \(textInput)")
      }
    func getTextFont() -> Font {
           let size: CGFloat = Locale.current.languageCode == "ar" ? 25 : 20
           let fontName: String = Locale.current.languageCode == "ar" ? "mishafi" : "AppleSDGothicNeo-Regular"
           return Font.custom(fontName, size: 20)
       }
    func getTextAlignment() -> TextAlignment {
        let languageCode = Locale.current.languageCode
        return languageCode == "ar" ? .trailing : .leading
    }

}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(audioRecorder: AudioRecorder())
    }
}


let questions = [
    "سؤال: ما الذي حدث ليجعلني أفكر بهذا التفكير؟",
    "كيف تشعر اليوم؟",
    "ماذا كان ردت فعلي؟",
    "ما الذي يجعلني أعتقد أن هذا الفكر صحيح؟",
    "هل توجد أي أدلة تشير إلى أن هذه الفكرة غير صحيحة؟",
   "اذا كانت هذه الفكره صحيحه ما الذي يدعم صحه هذا الفكرة؟",
   "الفكرة المتوازنه",
]
