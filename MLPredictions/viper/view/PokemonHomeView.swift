//
//  PokemonHomeView.swift
//  MLPredictions
//
//  Created by Lorena on 26/12/21.
//
   

import SwiftUI
import AVFoundation

struct PokemonHomeView: View {
    
//    @State var localVersion = false
    var presenter: PokemonHomePresenter
    
    var body: some View {
        CameraView(presenter: presenter)
    }
}

struct PokemonHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonHomeView(presenter: PokemonHomePresenter())
    }
}


struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    var presenter: PokemonHomePresenter
    
    @State var pictureResponse: PictureResponse?
    
    var body: some View{
        
        ZStack{
            
            // Going to Be Camera preview...
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            Text(self.pictureResponse?.prediction ?? "")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 20)
        }
        .onAppear(perform: {
            
            camera.Check()
        })
        .alert(isPresented: $camera.alert) {
            Alert(title: Text("Please Enable Camera Access"))
        }
        .onReceive(timer) { time in
            camera.takePic() { image in
                guard let image = image else { return }
                print("image capture")
                DispatchQueue.main.async {
                    presenter.sendPicture(the: image) { model in
                        self.pictureResponse = model
                    }
                }
            }
        }
        .onDisappear(perform: {
            self.timer.upstream.connect().cancel()
        })
    }
}

// Camera Model...

class CameraModel: NSObject,ObservableObject,AVCapturePhotoCaptureDelegate{
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    // since were going to read pic data....
    @Published var output = AVCapturePhotoOutput()
    
    // preview....
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    // Pic Data...
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    
    func Check(){
        
        // first checking camerahas got permission...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            // Setting Up Session
        case .notDetermined:
            // retusting for permission....
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    func setUp(){
        
        // setting up camera...
        
        do{
            
            // setting configs...
            self.session.beginConfiguration()
            
            // change for your own...
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            // checking and adding to session...
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            // same for output....
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    // take and retake functions...
    
    func takePic(completion: @escaping(UIImage?) -> Void){
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        self.savePic() { image in
            completion(image)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil{
            return
        }
        print("pic taken...")
        guard let imageData = photo.fileDataRepresentation() else{return}
        self.picData = imageData
    }
    
    func savePic(completion: @escaping(UIImage?) -> Void){
        guard let image = UIImage(data: self.picData) else{ return }
        completion(image)
    }
    
}

// setting view for preview...

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) ->  UIView {
     
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Your Own Properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
