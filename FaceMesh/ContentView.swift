//
//  ContentView.swift
//  FaceMesh
//
//  Created by jht2 on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State var analysis: String = ""
    @State private var showingList = false
    @State private var showingRecord = false
    
    var body: some View {
        VStack {
            Text(analysis).frame(height: 40)
            Button("record"){
                showingRecord = true
            }
            Button("recorded list"){
                showingList = true
            }
            BridgeView(analysis: $analysis)
        }
        .sheet(isPresented: $showingList){
            NavigationView{
                VStack{
                    sthView(isPresented: $showingList)
                    RecordingsList(audioRecorder: audioRecorder)
                }
            }
            .navigationBarTitle("Voice List")
            .navigationBarItems(trailing: EditButton())
        }
        .sheet(isPresented: $showingRecord){
            NavigationView{
                VStack{
                    Button("dismiss"){
                        showingRecord = false
                    }
                    if audioRecorder.recording == false {
                        Button(action: {self.audioRecorder.startRecording()}) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }
                    } else {
                        Button(action: {self.audioRecorder.stopRecording()}) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipped()
                                .foregroundColor(.red)
                                .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarTitle("Voice Recorder")
            .navigationBarItems(trailing: EditButton())
        }
        
        //.padding()
    }
}

struct sthView: View{
    @Binding var isPresented: Bool

    var body: some View{
        Button("dismiss"){
            isPresented = false
        }
    }
}

struct BridgeView: UIViewControllerRepresentable {
    @Binding var analysis: String

    func makeUIViewController(context: Context) -> some UIViewController {
        print("BridgeView makeUIViewController")
        
        let storyBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil);
        let viewCtl = storyBoard.instantiateViewController(withIdentifier: "main") as! ViewController;
        
        print("BridgeView viewCtl", viewCtl)

        viewCtl.reportChange = {
            // print("reportChange")
            analysis = viewCtl.analysis
        }
        return viewCtl
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // print("BridgeView updateUIViewController")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
