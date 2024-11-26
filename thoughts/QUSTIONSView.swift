import SwiftUI

struct QUSTIONSView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var textInput: String = ""
    @State private var buttonStates = Array(repeating: false, count: 7)
    let white1 = Color(red: 249, green: 249, blue: 248)

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Spacer()
                        .font(.custom("SF Pro Rounded", size: 50))
                        .foregroundColor(Color("Text-Primary"))
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                        .padding(5)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: ContentView(audioRecorder: AudioRecorder())) {
                            HStack {
                                Text(isSystemLanguageArabic() ? "انهاء" : "Done")
                                    .foregroundColor(Color(red: 0.473, green: 0.483, blue: 0.457))
                                    .accessibilityLabel("Done button")
                            }
                        }
                    }
                }

                VStack(spacing: 14) {
                    ForEach(0..<7) { index in
                        NavigationLink(destination: RecordView(audioRecorder: AudioRecorder())) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(getButtonBackground(forIndex: index))
                                    .frame(width: 360, height: 100)
                                    .cornerRadius(10)
                                    .shadow(color: Color.fontcolor.opacity(0.3), radius: 5, x: 0, y: 5)

                                Text(getButtonText(forIndex: index))
                                    .font(.custom("mishafi", size: 24))
                                    .foregroundColor(getButtonTextColor(forIndex: index))
                                    .multilineTextAlignment(getTextAlignment())
                                    .padding(.leading, 2)
                                    .accessibility(label: Text("Button \(getButtonText(forIndex: index))"))
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibility(label: Text("Button \(getButtonText(forIndex: index))"))
                    }
                }
                .padding(.horizontal)

                Color(.white1)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    func getButtonText(forIndex index: Int) -> String {
        switch index {
        case 0: return isSystemLanguageArabic() ? "ما الذي حدث ليجعلني أفكر بهذا التفكير؟" : "What        happened       to      make        me think      this      way?"
        case 1: return isSystemLanguageArabic() ? "كيف تشعر اليوم؟" : "How     do    you      feel        today?"
        case 2: return isSystemLanguageArabic() ? "ماذا كان رد فعلي؟" : "What     was    your     reaction?"
        case 3: return isSystemLanguageArabic() ? "ما الذي يجعلني اعتقد ان هذه الفكره صحيحة؟" :        "What       makes     me     believe      this          idea     is        true?"
        case 4: return isSystemLanguageArabic() ? "هل توجد أي أدلة تشير إلى أن هذه الفكرة غير صحيحة؟" : "Are      there      any       evidence            indicating      that     this        idea      is      false?"
        case 5: return isSystemLanguageArabic() ? "اذا كانت الفكره صحيحة ما الذي يدعم صحتها؟" : "If      this      idea    is     true,     what     supports     its       validity?"
        case 6: return isSystemLanguageArabic() ? "الفكرة المتوازنه" : "Balanced        idea"
        default: return ""
        }
    }

    func getButtonBackground(forIndex index: Int) -> Color {
        return buttonStates[index] ? Color.green1 : Color.white
    }

    func getButtonTextColor(forIndex index: Int) -> Color {
        return buttonStates[index] ? .white : .fontcolor
    }

    func getTextAlignment() -> TextAlignment {
        let languageCode = Locale.current.languageCode
        return languageCode == "ar" ? .trailing : .leading
    }

    func isSystemLanguageArabic() -> Bool {
        return Locale.current.languageCode == "ar"
    }

    func speakContent(_ content: String) {
        // Implement text-to-speech functionality here
        // You can use AVSpeechSynthesizer or other libraries to speak the content
        // For simplicity, we'll just print the content here
        print("Spoken Content: \(content)")
    }
}

struct QUSTIONSView_Previews: PreviewProvider {
    static var previews: some View {
        QUSTIONSView()
    }
}
