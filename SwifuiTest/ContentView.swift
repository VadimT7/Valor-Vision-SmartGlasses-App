import SwiftUI
import SwiftUIPolygonGeofence
import CoreLocation
import CoreLocationUI
import MapKit
import ActiveLookSDK


struct TestView: View{
    @ObservedObject var compassHeading = CompassHeading()

    var textView1: some View {
            Text("Hello, SwiftUI")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    var body: some View {
            ZStack {
                VStack(spacing: 100) {
                    textView
                }
            }
        }
    var textView: some View{
        ZStack{
            ForEach(Marker.markers(), id:\.self) {marker in
                CompassMarkerView(marker: marker, compassDegrees: self.compassHeading.degrees)
            }
        }
        .frame(width: 150, height: 150)
        .rotationEffect(Angle(degrees: self.compassHeading.degrees))
        .statusBar(hidden:true)    }
}

struct ContentView: View {
    @ObservedObject var compassHeading = CompassHeading()
    @StateObject public var viewModel = ContentViewModel()

    @SwiftUI.State var Glasses = MapScreen()
    @SwiftUI.State var locations = [Location]()

    @SwiftUI.State private var selectedPlace: Location?
    @SwiftUI.State var timer: Timer?
    @SwiftUI.State var timer1: Timer?
    
    @SwiftUI.State var zoomForMap: Double = 0.002
    //var zoomForMap = 0.002
    //let geoFence = SwiftUIPolygonGeofence
    //var activeLook: ActiveLookSDK
        
    var body: some View {
        //LaunchView()
        NavigationView{
            ZStack{
                Map(coordinateRegion: $viewModel.region,showsUserLocation: true,annotationItems:locations){
                    location in MapAnnotation(coordinate:location.coordinate){
                        ZStack{
                            Image(systemName: "mappin")
                                .resizable()
                                .padding(.bottom)
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
                    //add function call here
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Menu{
                            Button("Connect Glasses", action: connectGlasses)
                            Button("Map Only", action: sendDisplay)
                            Button("Compass Only", action: returnDegree)
                            Button("Both Map and Compass", action:both)
                            Button("Zoom In", action: plus)
                            Button("Zoom Out", action: minus)
                            Button("Street Name", action: StreetNameWCompass)
                            Button("Clear", action:Clear)
                            Button("Stop Timer", action: stopTimer)
                        }
                        label: {
                            Image(systemName: "eyeglasses")
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(width:60,height:40)
                        }
                        //.background(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image("vv-lt")
                            .resizable()
                            .scaledToFit()
                            .frame(width:60, height:70, alignment: .center)
                        
                        Menu{
                            Button("Connect Glasses", action: connectGlasses)
                            Button("Battery", action: battery)
                            Button("Disconnect", action: Disconnect)
                            Button("Turn Off", action: TurnOff)
                        }
                        label: {
                            Image(systemName: "gear")
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(width:60,height:40)
                        }
                        //.background(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Spacer()
                }
                .padding()
                    
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width:15,height:15)
                
                VStack{//compass
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
                Spacer()
                VStack{//CenterLocation & pin point buttons
                    Spacer()
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
    
    let cLoc = CLLocation()
    
    func connectGlasses(){
        Glasses.startScanning()
        
    }
    func Clear(){
        Glasses.clearMap()
    }
    func StreetNameWCompass(){
        Glasses.clearMap()
        let compassDeg = Int(-1*self.compassHeading.degrees)
        
        Glasses.getAddressFromLocation(deg: compassDeg)
    }
    func sendDisplay(){
        stopTimer()
        Glasses.clearMap()
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            print("rep")
            Glasses.threeTimer(zoom: zoomForMap)
        }
    }
    func returnDegree(){
        stopTimer()
        Glasses.clearMap()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            print("repeat")
            let compassDeg = Int(-1*self.compassHeading.degrees)
            Glasses.oneTimer(deg: compassDeg)
        }
    }
    func both(){
        stopTimer()
        Glasses.clearMap()
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            print("repBof")
            let compassDeg = Int(-1*self.compassHeading.degrees)
            Glasses.oneTimer(deg: compassDeg)
            //Glasses.bothRuns(zoom: zoomForMap, deg: compassDeg)
        }
        self.timer1 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            Glasses.threeTimer(zoom: zoomForMap)
            //Glasses.oneTimer(deg:compassDeg)
        }
    }
    func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
        self.timer1?.invalidate()
        self.timer1 = nil
    }
    func plus(){
        zoomForMap = zoomForMap - 0.001
    }
    func minus(){
        zoomForMap = zoomForMap + 0.001
    }
    func battery(){
        //Glasses.clearMap()
        Glasses.getBatteryLevel()
    }
    func Disconnect(){
        //Glasses.clearMap()
        Glasses.discon()
    }
    func TurnOff(){
        Glasses.clearMap()
        //Glasses.discon
        Glasses.turnOf()
    }
}


final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    
    //@Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:37, longitude:-121), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    //@Published var region = MKCoordinateRegion(center:locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    @Published var region: MKCoordinateRegion
        
    override init() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -121), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        super.init()
        initializeRegion()
    }
    
    func initializeRegion() {
        region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37, longitude: -121), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    }
    
    func ApplyState()->Location{
        let newRegion = Location(id: UUID(), name: "New Location", discription: "", latitude:region.center.latitude, longitude: region.center.longitude)
        return newRegion
        //ContentView.locations.append(newRegion)
    }
    func checkLocationAuthorization(){
        //guard let locationManager = locationManager else { return }
        //region = MKCoordinateRegion(center:locationManager.location!.coordinate,span:MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        //locationManager.startUpdatingLocation()

        switch locationManager.authorizationStatus{
        case .notDetermined:
            //locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("Allow user Location")
        case .denied:
            print("Allow user Location")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center:locationManager.location!.coordinate,span:MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
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
    
    @SwiftUI.State var capture: UIImage?
    
    var timer: Timer?

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
        //locationManager.delegate = self
        //goButton.layer.cornerRadius = goButton.frame.size.height/2
    }
    /*func updateGlassesTextDisplay() {
        print("HELLO")
        geoCoder.reverseGeocodeLocation(locationManager.location!) { placemarks, error in
            guard let placemark = placemarks?.first,
                  let street = placemark.thoroughfare,
                  let direction = self.locationManager.heading?.direction else { return }
            let text = "(direction) on (street)"
            print(text)
            self.glassesConnected?.txt(x: 102, y: 128, rotation: .topLR, font: 2, color: 15, string: text)
        }
    }*/
    
    func getAddressFromLocation(deg: Int) {
        CLGeocoder().reverseGeocodeLocation(locationManager.location!) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            let currentAddress = placemark.thoroughfare ?? ""
            let direction = self.convertDegtoDirec(deg: deg)
            let text = "\(direction)on \(currentAddress)"
            print(text)
            
            self.glassesConnected?.txt(x: 310, y: 128, rotation: .topLR, font: 2, color: 15, string: text)

            
//            if(text.count > 21){
//                if(text.count > 42){
//                    self.glassesConnected?.txt(x: 310, y: 128, rotation: .topLR, font: 2, color: 15, string: "character overload")
//                }
//                else{
//                    let firsthalf=String(text.prefix(21))
//                    self.glassesConnected?.txt(x: 310, y: 128, rotation: .topLR, font: 2, color: 15, string: firsthalf)
//                    self.glassesConnected?.txt(x: 310, y: 128, rotation: .topLR, font: 2, color: 15, string: text)
//                }
//            }
//            else{
//                self.glassesConnected?.txt(x: 310, y: 128, rotation: .topLR, font: 2, color: 15, string: text)
//            }
//            self.glassesConnected?.txt(x: 316, y: 128, rotation: .topLR, font: 2, color: 15, string: " SE on Sixth Ave12345")
            //self.glassesConnected?.txt(x: 310, y: 128, rotation: .topLR, font: 2, color: 15, string: text)
        }
    }
}


extension MapScreen: MKMapViewDelegate {
    
    
    func convertDegtoDirec(deg:Int) -> String {//Should add 2 funcs one w spaces and one w out
        let labels = [" N  ", " NE  ", " E  ", " SE ", " S  ", " SW ", " W  ", " NW "]
        let index = Int((Double(deg) / 45.0).rounded()) % 8
           
        let label = labels[index]
        return label
    }
    
    func oneTimer(deg: Int){
        //self.glassesConnected?.clear()
        let label = convertDegtoDirec(deg: deg)
        self.glassesConnected?.txt(x: 102, y: 128, rotation: .topLR, font: 2, color: 15, string: label)
    }
    
    func clearMap(){
        self.glassesConnected?.clear()
    }
    
    func threeTimer(zoom: Double){
        generateImageFromMap(zoom: zoom)
    }
    func bothRuns(zoom: Double, deg: Int){
        generateImageFromMap(zoom: zoom)
        oneTimer(deg: deg)
    }
    func discon(){
        
    }
    func turnOf(){
        self.glassesConnected?.power(on:false)
    }
    func getBatteryLevel() {
        self.glassesConnected?.battery { batteryLevel in
                let alert = UIAlertController(title: "Battery level", message: "(batteryLevel) %", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    
    func generateImageFromMap(zoom: Double) {
        
        var imageWithMarker: UIImage?
        
        let mapSnapshotterOptions = MKMapSnapshotter.Options()
        mapSnapshotterOptions.size = CGSize(width: 140, height: 140)
        mapSnapshotterOptions.region = MKCoordinateRegion(center:locationManager.location!.coordinate,span:MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        mapSnapshotterOptions.mapType = .mutedStandard
        mapSnapshotterOptions.showsBuildings = true

        //mapSnapshotterOptions.showP = false
        
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotterOptions)
        
        snapShotter.start() { [self] snapshot, error in
            if let image = snapshot?.image{
                print("took screenshot")
                
                
                let markerImage = UIImage(systemName: "dot.circle") // Replace with your marker image
                let markerPoint = snapshot?.point(for: locationManager.location!.coordinate)
                imageWithMarker = addMarkerImage(markerImage, to: image, at: markerPoint!)
                                
                //Here we add directiom
                /*
                 // Create a new snapshot options object
                 let options = MKMapSnapshotter.Options()

                 // Set the region to the desired address
                 let address = "1600 Amphitheatre Parkway, Mountain View, CA"
                 let geocoder = CLGeocoder()
                 geocoder.geocodeAddressString(address) { placemarks, error in
                     guard let placemark = placemarks?.first else { return }
                     let region = MKCoordinateRegion(center: placemark.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                     options.region = region

                     // Set the size of the snapshot image
                     let size = CGSize(width: 200, height: 200)
                     options.size = size

                     // Create a new snapshotter object with the options
                     let snapshotter = MKMapSnapshotter(options: options)

                     // Start the snapshot request
                     snapshotter.start() { snapshot, error in
                         guard let snapshot = snapshot else { return }

                         // Create a new image context with the same size as the snapshot image
                         UIGraphicsBeginImageContextWithOptions(snapshotImage.size, false, 0.0)

                         // Draw the snapshot image onto the context
                         snapshot.image.draw(at: CGPoint.zero)

                         // Get the starting point and destination coordinates
                         let startPoint = CLLocationCoordinate2D(latitude: 37.331789, longitude: -122.029620)
                         let endPoint = placemark.location!.coordinate

                         // Create a MKDirectionsRequest with the starting and destination coordinates
                         let request = MKDirections.Request()
                         request.source = MKMapItem(placemark: MKPlacemark(coordinate: startPoint))
                         request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endPoint))
                         request.transportType = .walking

                         // Create a MKDirections object and calculate the route
                         let directions = MKDirections(request: request)
                         directions.calculate { response, error in
                             guard let route = response?.routes.first else { return }

                             // Draw the route onto the image context
                             let routePath = UIBezierPath()
                             routePath.lineWidth = 5.0
                             routePath.lineCapStyle = .round
                             routePath.lineJoinStyle = .round

                             // Loop through the route's steps and add the path for each step
                             for step in route.steps {
                                 let stepPath = UIBezierPath()
                                 stepPath.move(to: snapshot.point(for: step.polyline.points()[0]))
                                 for i in 1..<step.polyline.pointCount {
                                     stepPath.addLine(to: snapshot.point(for: step.polyline.points()[i]))
                                 }
                                 routePath.append(stepPath)
                             }

                             // Set the stroke color and draw the route path
                             UIColor.blue.setStroke()
                             routePath.stroke()

                             // Get the new image from the context
                             let newImage = UIGraphicsGetImageFromCurrentImageContext()

                             // End the image context
                             UIGraphicsEndImageContext()

                             // Use the new image with the highlighted route
                             // ...
                         }
                     }
                 }
                 
                 */
                
                self.glassesConnected?.imgStream(image: imageWithMarker!, x: 0, y: 0, imgStreamFmt: .MONO_4BPP_HEATSHRINK)
                self.glassesConnected?.luma(level: 15)
                
            }else{
                print("Missing snapshot")
            }
        }
    }
    

    func addMarkerImage(_ markerImage: UIImage?, to image: UIImage, at point: CGPoint) -> UIImage? {
        guard let markerImage = markerImage else {
            print("markerImage is nil")
            return nil
        }
        guard let cgImage = image.cgImage else {
            print("Failed to get cgImage from image")
            return nil
        }

        let imageSize = CGSize(width: 140, height: 140)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to get image context")
            return nil
        }
        // Adjust the coordinate system to match UIKit's coordinate system
        context.translateBy(x: 0, y: imageSize.height)
        context.scaleBy(x: 1, y: -1)

        context.draw(cgImage, in: CGRect(origin: .zero, size: imageSize))
        
        let markerSize = CGSize(width: 10, height: 10)
        //let markerOrigin = CGPoint(x: point.x - markerSize.width / 2, y: point.y - markerSize.height / 2)
        let markerOrigin = CGPoint(x: (140/2)-5 , y: (140/2)-5 )
        let markerRect = CGRect(origin: markerOrigin, size: markerSize)

        markerImage.draw(in: markerRect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
extension CLHeading {
    var direction: String? {
        switch true {
        case 0..<22.5 ~= magneticHeading,
             337.5..<360 ~= magneticHeading:
            return "N"
        case 22.5..<67.5 ~= magneticHeading:
            return "NE"
        case 67.5..<112.5 ~= magneticHeading:
            return "E"
        case 112.5..<157.5 ~= magneticHeading:
            return "SE"
        case 157.5..<202.5 ~= magneticHeading:
            return "S"
        case 202.5..<247.5 ~= magneticHeading:
            return "SW"
        case 247.5..<292.5 ~= magneticHeading:
            return "W"
        case 292.5..<337.5 ~= magneticHeading:
            return "NW"
        default:
            return nil
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
    
    public func getDegree() -> Double{
        return self.degrees
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


