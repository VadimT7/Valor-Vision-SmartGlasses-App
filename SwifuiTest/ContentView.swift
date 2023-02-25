import SwiftUI
import SwiftUIPolygonGeofence
import CoreLocation
import CoreLocationUI
import MapKit
import ActiveLookSDK

struct ContentView: View {
    @ObservedObject var compassHeading = CompassHeading()
    @StateObject public var viewModel = ContentViewModel()

    @SwiftUI.State var Glasses = MapScreen()
    @SwiftUI.State var locations = [Location]()

    @SwiftUI.State private var selectedPlace: Location?
    //let geoFence = SwiftUIPolygonGeofence
    //var activeLook: ActiveLookSDK
        
    var body: some View {
        NavigationView{
            ZStack{
                Map(coordinateRegion: $viewModel.region,showsUserLocation: true,annotationItems:locations){
                    location in MapAnnotation(coordinate:location.coordinate){
                        ZStack{
                            Image(systemName: "mappin")
                                .resizable()
                                .padding(.bottom)
                            //.foregroundColor(.red)
                                .frame(width: 20, height: 60)
                                .scaledToFit()
                                .padding(.bottom)
                                .foregroundColor(.red)
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                .accentColor(Color(.systemPink))
                .onAppear{
                    viewModel.checkLocationAuthorization()
                }
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width:15,height:15)
                VStack{
                    Spacer()
                    Capsule()
                        .frame(width:5, height:50)
                    ZStack{
                        ForEach(Marker.markers(), id:\.self) {marker in
                            CompassMarkerView(marker: marker, compassDegrees: self.compassHeading.degrees)
                        }
                    }
                    .frame(width: 150, height: 150)
                    .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                    .statusBar(hidden:true)
                }
                
                //}
                Spacer()
                VStack{
                    Button(action: connectGlasses) {
                        Image(systemName: "eyeglasses")
                        .frame(width: 50, height:30)
                    }
                    .foregroundColor(.white)
                    .background(.black.opacity(0.5))
                    Button(action: sendDisplay) {
                        Image(systemName: "display")
                        .frame(width: 50, height:30)
                    }
                    Spacer(minLength: -300)
                    HStack{
                        LocationButton(.currentLocation){
                            viewModel.checkLocationAuthorization()
                        }
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .labelStyle(.iconOnly)
                        .symbolVariant(.fill)
                        .padding(.leading)
                        
                        Spacer()
                        Button{
                            let getLocation = viewModel.ApplyState()
                            locations.append(getLocation)
                            //create new location
                        } label: {
                            Image(systemName:"plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
            }
            .sheet(item: $selectedPlace){ place in
                EditView(location: place){ newLocation in
                    if let index = locations.firstIndex(of: place){
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
    func connectGlasses(){
        Glasses.startScanning()
    }
    func sendDisplay(){
        Glasses.generateImageFromMap()
    }/*
    func stopTry(){
        Glasses.stopScanning()
    }*/
}


final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:37, longitude:-121), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    
    
    func ApplyState()->Location{
        let newRegion = Location(id: UUID(), name: "New Location", discription: "", latitude:region.center.latitude, longitude: region.center.longitude)
        return newRegion
        //ContentView.locations.append(newRegion)
    }
    func checkLocationAuthorization(){
        //guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Allow user Location")
        case .denied:
            print("Allow user Location")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center:locationManager.location!.coordinate,span:MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func getCenterLocation(for mapview: MKMapView) -> CLLocation {
        let latitude = region.center.latitude
        let longitude = region.center.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


class MapScreen: UIViewController {
    
    var viewModel = CLLocationManager()

    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    
    // MARK: - Activelook init
    private let glassesName: String = "ENGO 2 090756"
    private var glassesConnected: Glasses?
    private let scanDuration: TimeInterval = 10.0
    private let connectionTimeoutDuration: TimeInterval = 5.0
    
    private var scanTimer: Timer?
    private var connectionTimer: Timer?
    
    private lazy var alookSDKToken: String = {
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { return "" }
        guard let activelookSDKToken: String = infoDictionary["ACTIVELOOK_SDK_TOKEN"] as? String else { return "" }
        return activelookSDKToken
    }()
    
    private lazy var activeLook: ActiveLookSDK = {
        try! ActiveLookSDK.shared(
            token: alookSDKToken,
            onUpdateStartCallback: { SdkGlassesUpdate in
                print("onUpdateStartCallback")
            }, onUpdateAvailableCallback: { (SdkGlassesUpdate, _: () -> Void) in
                print("onUpdateAvailableCallback")
            }, onUpdateProgressCallback: { SdkGlassesUpdate in
                print("onUpdateProgressCallback")
            }, onUpdateSuccessCallback: { SdkGlassesUpdate in
                print("onUpdateSuccessCallback")
            }, onUpdateFailureCallback: { SdkGlassesUpdate in
                print("onUpdateFailureCallback")
            })
    }()
    
    
    func startScanning() {
        activeLook.startScanning(
            onGlassesDiscovered: { [weak self] (discoveredGlasses: DiscoveredGlasses) in
                if discoveredGlasses.name == self!.glassesName{
                    discoveredGlasses.connect(
                        onGlassesConnected: { [weak self] (glasses: Glasses) in
                            guard let self = self else { return }
                            self.connectionTimer?.invalidate()
                            self.stopScanning()
                            self.glassesConnected = glasses
                            self.glassesConnected?.clear()
                            //try to display to glasses from here?
                            //glasses.line(x0: 102, x1: 202, y0: 128, y1: 128)
                        }, onGlassesDisconnected: { [weak self] in
                            guard let self = self else { return }
                            
                            let alert = UIAlertController(title: "Glasses disconnected", message: "Connection to glasses lost", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                self.navigationController?.popToRootViewController(animated: true)
                            }))
                            
                            self.navigationController?.present(alert, animated: true)
                            
                        }, onConnectionError: { [weak self] (error: Error) in
                            guard let self = self else { return }
                            self.connectionTimer?.invalidate()
                            
                            let alert = UIAlertController(title: "Error", message: "Connection to glasses failed: \(error.localizedDescription)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        })
                }
            }, onScanError: { [weak self] (error: Error) in
                self?.stopScanning()
            }
        )
        
        scanTimer = Timer.scheduledTimer(withTimeInterval: scanDuration, repeats: false) { timer in
            self.stopScanning()
        }
    }
    
    private func stopScanning() {
        activeLook.stopScanning()
        scanTimer?.invalidate()
    }
    
    //Mark: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startScanning()
        //goButton.layer.cornerRadius = goButton.frame.size.height/2
    }
    
    
  
    
}


extension MapScreen: MKMapViewDelegate {
    
    
    // Start the interrupter loop
    /*func startInterrupterLoop(isRunning: Bool) {
        // Create a timer that will fire every 1 second
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            if isRunning == true {
                // Call the function
                self.generateImageFromMap()
            } else {
                // Stop the timer if the interrupter loop is no longer running
                timer.invalidate()
            }
        }

        // Add the timer to the run loop
        RunLoop.current.add(timer, forMode: .common)
    }*/
    
    func generateImageFromMap() {
        let mapSnapshotterOptions = MKMapSnapshotter.Options()
        //mapSnapshotterOptions.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:37, longitude:-121), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapSnapshotterOptions.region = MKCoordinateRegion(center:locationManager.location!.coordinate,span:MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapSnapshotterOptions.size = CGSize(width: 304, height: 256)
        mapSnapshotterOptions.mapType = MKMapType.standard
        mapSnapshotterOptions.showsBuildings = false
        //mapSnapshotterOptions.showP = false


        let snapShotter = MKMapSnapshotter(options: mapSnapshotterOptions)
        
        
        snapShotter.start() { snapshot, error in
            if let image = snapshot?.image{
                self.glassesConnected?.imgStream(image: image, x: 0, y: 0, imgStreamFmt: .MONO_4BPP_HEATSHRINK)
            }else{
                print("Missing snapshot")
            }
        }
    
    }
}




struct Marker : Hashable{
    let degrees: Double
    let label: String
    
    init(degrees: Double, label: String="") {
        self.degrees = degrees
        self.label = label
    }
    
    func degreeText() -> String{
        return String(format: "%.0f", self.degrees)
    }
    
    static func markers()-> [Marker]{
        return [
            Marker(degrees: 0, label: "S"),
            Marker(degrees: 30),
            Marker(degrees: 60),
            Marker(degrees: 90, label: "W"),
            Marker(degrees: 120),
            Marker(degrees: 150),
            Marker(degrees: 180, label: "N"),
            Marker(degrees: 210),
            Marker(degrees: 240),
            Marker(degrees: 270, label: "E"),
            Marker(degrees: 300),
            Marker(degrees: 330)
        ]
    }
}

struct CompassMarkerView : View{
    let marker: Marker
    let compassDegrees: Double
    
    var body: some View{
        VStack{
            Text(marker.degreeText())
                .fontWeight(.light)
                .rotationEffect(self.textAngle())
            Capsule()
                .frame(width:1,height:10)
                //.frame(width: self.capsuleWidth(),height: self.capsuleHeight())
                .padding(.bottom,50)
            Text(marker.label)
                .fontWeight(.bold)
                .rotationEffect(self.textAngle())
                .padding(.bottom,50)
        }
        .fixedSize()
        .rotationEffect(Angle(degrees: marker.degrees))
    }
    private func capsuleWidth() -> CGFloat{
        return self.marker.degrees == 0 ? 7 : 3
    }
    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 0 ? 45 : 30
    }
    private func capsuleColor() -> Color{
        return self.marker.degrees == 0 ? .red : .gray
    }
    private func textAngle() -> Angle{
        return Angle(degrees: -self.compassDegrees - self.marker.degrees)
    }
}
