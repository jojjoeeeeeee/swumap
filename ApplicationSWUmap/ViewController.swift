//
//  ViewController.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 29/9/2563 BE.
//

import UIKit
import MapKit
import DropDown
import FirebaseAuth

class ViewController: UIViewController {
    
    var annotationSet = false
    var annotationID = ""
    
    let transparentView = UIView()
    let menu = DropDown()
    let filtermenu:DropDown = {
        let filtermenu = DropDown()
        filtermenu.dataSource = [
            "   อาคาร",
            "   สนามกีฬา",
            "   โรงอาหาร",
            "   7-11",
            "   ATM",
            "   ห้องน้ำ",
            "   ประตูทางเข้า/ออก",
            "   ทั้งหมด"
        ]
        return filtermenu
    }()
    
    var images = [String]()
    
    //    let barAppearance = UINavigationBar.appearance()
    //        barAppearance.barTintColor = UIColor.blue
    //        barAppearance.tintColor = UIColor.white
    //        barAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    @IBOutlet weak var filtermenuBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate func menu_Logged_in() {
        self.menu.dataSource = [
            "Profile",
            "Friends List",
            "Logout"
        ]
        self.images = [
            "gear",
            "gear",
            "gear"
        ]
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            menu_Logged_in()
        }
    }
    
    var ArrBuilding = [MKPointAnnotation]()
    var ArrField = [MKPointAnnotation]()
    var ArrCanteen = [MKPointAnnotation]()
    var Arr711 = [MKPointAnnotation]()
    var ArrATM = [MKPointAnnotation]()
    var ArrGate = [MKPointAnnotation]()
    var ArrToilet = [MKPointAnnotation]()
    
    func createAnnotation() {
        // อาคาร
        // 1
        let annotationBuilding1 = MKPointAnnotation()
        annotationBuilding1.coordinate = CLLocationCoordinate2D(latitude: 13.74698, longitude: 100.56474)
        annotationBuilding1.title = "คณะพลศึกษา"
        annotationBuilding1.subtitle = "อาคาร 1"
        mapView.addAnnotation(annotationBuilding1)
        ArrBuilding.append(annotationBuilding1)
        //
        // 2
        let annotationBuilding2 = MKPointAnnotation()
        annotationBuilding2.coordinate = CLLocationCoordinate2D(latitude: 13.74664, longitude: 100.56558)
        annotationBuilding2.title = "คณะมนุษยศาสตร์ (อาคารเก่า)"
        annotationBuilding2.subtitle = "อาคาร 2"
        mapView.addAnnotation(annotationBuilding2)
        ArrBuilding.append(annotationBuilding2)
        //
        // 3
        let annotationBuilding3 = MKPointAnnotation()
        annotationBuilding3.coordinate = CLLocationCoordinate2D(latitude: 13.74583, longitude: 100.56447)
        annotationBuilding3.title = "หอจดหมายเหตุ"
        annotationBuilding3.subtitle = "อาคาร 3"
        mapView.addAnnotation(annotationBuilding3)
        ArrBuilding.append(annotationBuilding3)
        //
        // 4
        let annotationBuilding4 = MKPointAnnotation()
        annotationBuilding4.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        annotationBuilding4.title = "คณะวิทยาศาสตร์"
        annotationBuilding4.subtitle = "อาคาร 6"
        mapView.addAnnotation(annotationBuilding4)
        ArrBuilding.append(annotationBuilding4)
        //
        // 5
        let annotationBuilding5 = MKPointAnnotation()
        annotationBuilding5.coordinate = CLLocationCoordinate2D(latitude: 13.74506, longitude: 100.56602)
        annotationBuilding5.title = "สำนักทดสอบทางการศึกษาและจิตวิทยา"
        annotationBuilding5.subtitle = "อาคาร 8"
        mapView.addAnnotation(annotationBuilding5)
        ArrBuilding.append(annotationBuilding5)
        //
        // 6
        let annotationBuilding6 = MKPointAnnotation()
        annotationBuilding6.coordinate = CLLocationCoordinate2D(latitude: 13.74371, longitude: 100.56443)
        annotationBuilding6.title = "สำนักอธิการบดี"
        annotationBuilding6.subtitle = "อาคาร 9"
        mapView.addAnnotation(annotationBuilding6)
        ArrBuilding.append(annotationBuilding6)
        //
        // 7
        let annotationBuilding7 = MKPointAnnotation()
        annotationBuilding7.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        annotationBuilding7.title = "คณะวิทยาศาสตร์"
        annotationBuilding7.subtitle = "อาคาร 10"
        mapView.addAnnotation(annotationBuilding7)
        ArrBuilding.append(annotationBuilding7)
        //
        // 8
        let annotationBuilding8 = MKPointAnnotation()
        annotationBuilding8.coordinate = CLLocationCoordinate2D(latitude: 13.74443, longitude: 100.56398)
        annotationBuilding8.title = "คณะสังคมศาสตร์"
        annotationBuilding8.subtitle = "อาคาร 11"
        mapView.addAnnotation(annotationBuilding8)
        ArrBuilding.append(annotationBuilding8)
        //
        // 9
        let annotationBuilding9 = MKPointAnnotation()
        annotationBuilding9.coordinate = CLLocationCoordinate2D(latitude: 13.74527, longitude: 100.56418)
        annotationBuilding9.title = "คณะศึกษาศาสตร์"
        annotationBuilding9.subtitle = "อาคาร 12"
        mapView.addAnnotation(annotationBuilding9)
        ArrBuilding.append(annotationBuilding9)
        //
        // 10
        let annotationBuilding10 = MKPointAnnotation()
        annotationBuilding10.coordinate = CLLocationCoordinate2D(latitude: 13.74618, longitude: 100.56496)
        annotationBuilding10.title = "อาคารเรียนรวมอเนกประสงค์ (ตึกไข่ดาว)"
        annotationBuilding10.subtitle = "อาคาร 14"
        mapView.addAnnotation(annotationBuilding10)
        ArrBuilding.append(annotationBuilding10)
        ArrToilet.append(annotationBuilding10)
        Arr711.append(annotationBuilding10)
        ArrATM.append(annotationBuilding10)
        //
        // 11
        let annotationBuilding11 = MKPointAnnotation()
        annotationBuilding11.coordinate = CLLocationCoordinate2D(latitude: 13.74684, longitude: 100.56606)
        annotationBuilding11.title = "คณะแพทยศาสตร์"
        annotationBuilding11.subtitle = "อาคาร 15"
        mapView.addAnnotation(annotationBuilding11)
        ArrBuilding.append(annotationBuilding11)
        //
        // 12
        let annotationBuilding12 = MKPointAnnotation()
        annotationBuilding12.coordinate = CLLocationCoordinate2D(latitude: 13.74569, longitude: 100.56616)
        annotationBuilding12.title = "คณะศิลปกรรมศาสตร์"
        annotationBuilding12.subtitle = "อาคาร 16"
        mapView.addAnnotation(annotationBuilding12)
        ArrBuilding.append(annotationBuilding12)
        //
        // 13
        let annotationBuilding13 = MKPointAnnotation()
        annotationBuilding13.coordinate = CLLocationCoordinate2D(latitude: 13.74545, longitude: 100.56636)
        annotationBuilding13.title = "คณะทันตแพทยศาสตร์"
        annotationBuilding13.subtitle = "อาคาร 17"
        mapView.addAnnotation(annotationBuilding13)
        ArrBuilding.append(annotationBuilding13)
        //
        // 14
        let annotationBuilding14 = MKPointAnnotation()
        annotationBuilding14.coordinate = CLLocationCoordinate2D(latitude: 13.74698, longitude: 100.56642)
        annotationBuilding14.title = "อาคารกายวิภาคศาสตร์"
        annotationBuilding14.subtitle = "อาคาร 18"
        mapView.addAnnotation(annotationBuilding14)
        ArrBuilding.append(annotationBuilding14)
        //
        // 15
        let annotationBuilding15 = MKPointAnnotation()
        annotationBuilding15.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        annotationBuilding15.title = "อาคารศูนย์เครื่องมือวิทยาศาสตร์"
        annotationBuilding15.subtitle = "อาคาร 19"
        mapView.addAnnotation(annotationBuilding15)
        ArrBuilding.append(annotationBuilding15)
        //
        // 16
        let annotationBuilding16 = MKPointAnnotation()
        annotationBuilding16.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        annotationBuilding16.title = "อาคารบัณฑิตวิทยาลัย"
        annotationBuilding16.subtitle = "อาคาร 20"
        mapView.addAnnotation(annotationBuilding16)
        ArrBuilding.append(annotationBuilding16)
        //
        // 17
        let annotationBuilding17 = MKPointAnnotation()
        annotationBuilding17.coordinate = CLLocationCoordinate2D(latitude: 13.74560, longitude: 100.56563)
        annotationBuilding17.title = "สำนักหอสมุดกลาง"
        annotationBuilding17.subtitle = "อาคาร 23"
        mapView.addAnnotation(annotationBuilding17)
        ArrBuilding.append(annotationBuilding17)
        //
        // 18
        let annotationBuilding18 = MKPointAnnotation()
        annotationBuilding18.coordinate = CLLocationCoordinate2D(latitude: 13.74463, longitude: 100.56592)
        annotationBuilding18.title = "อาคารวิจัยและศึกษาต่อเนื่อง"
        annotationBuilding18.subtitle = "อาคาร 24"
        mapView.addAnnotation(annotationBuilding18)
        ArrBuilding.append(annotationBuilding18)
        //
        // 19
        let annotationBuilding19 = MKPointAnnotation()
        annotationBuilding19.coordinate = CLLocationCoordinate2D(latitude: 13.74511, longitude: 100.56544)
        annotationBuilding19.title = "อาคารสถาบันวิจัยพฤติกรรมศาสตร์"
        annotationBuilding19.subtitle = "อาคาร 25"
        mapView.addAnnotation(annotationBuilding19)
        ArrBuilding.append(annotationBuilding19)
        //
        // 20
        let annotationBuilding20 = MKPointAnnotation()
        annotationBuilding20.coordinate = CLLocationCoordinate2D(latitude: 13.74429, longitude: 100.56566)
        annotationBuilding20.title = "หอประชุม"
        annotationBuilding20.subtitle = "อาคาร 27"
        mapView.addAnnotation(annotationBuilding20)
        ArrBuilding.append(annotationBuilding20)
        ArrToilet.append(annotationBuilding20)
        //
        // 21
        let annotationBuilding21 = MKPointAnnotation()
        annotationBuilding21.coordinate = CLLocationCoordinate2D(latitude: 13.74491, longitude: 100.56646)
        annotationBuilding21.title = "วิทยาลัยนานาชาติเพื่อศึกษาความยั่งยืน"
        annotationBuilding21.subtitle = "อาคาร 33"
        mapView.addAnnotation(annotationBuilding21)
        ArrBuilding.append(annotationBuilding21)
        //
        // 22
        let annotationBuilding22 = MKPointAnnotation()
        annotationBuilding22.coordinate = CLLocationCoordinate2D(latitude: 13.74522, longitude: 100.56373)
        annotationBuilding22.title = "นวัตกรรม ศาสตราจารย์ ดร. สาโรช บัวศรี (อาคาร 400 ล้าน)"
        annotationBuilding22.subtitle = "อาคาร 34"
        mapView.addAnnotation(annotationBuilding22)
        ArrBuilding.append(annotationBuilding22)
        ArrToilet.append(annotationBuilding22)
        //
        // 23
        let annotationBuilding23 = MKPointAnnotation()
        annotationBuilding23.coordinate = CLLocationCoordinate2D(latitude: 13.74610, longitude: 100.56574)
        annotationBuilding23.title = "อาคารเรียนรวม Learning Tower"
        annotationBuilding23.subtitle = "อาคาร 35"
        mapView.addAnnotation(annotationBuilding23)
        ArrBuilding.append(annotationBuilding23)
        //
        // 24
        let annotationBuilding24 = MKPointAnnotation()
        annotationBuilding24.coordinate = CLLocationCoordinate2D(latitude: 13.74469, longitude: 100.56363)
        annotationBuilding24.title = "มศว บริการ ศาสตราจารย์ หม่อมหลวงปิ่น มาลากุล (อาคาร 300 ล้าน)"
        annotationBuilding24.subtitle = "อาคาร 36"
        mapView.addAnnotation(annotationBuilding24)
        ArrBuilding.append(annotationBuilding24)
        ArrToilet.append(annotationBuilding24)
        ArrATM.append(annotationBuilding24)
        //
        // 25
        let annotationBuilding25 = MKPointAnnotation()
        annotationBuilding25.coordinate = CLLocationCoordinate2D(latitude: 13.74719, longitude: 100.56559)
        annotationBuilding25.title = "อาคารปฏิบัติการนวัตกรรมสื่อสารสังคม"
        annotationBuilding25.subtitle = "อาคาร 37"
        mapView.addAnnotation(annotationBuilding25)
        ArrBuilding.append(annotationBuilding25)
        //
        // 26
        let annotationBuilding26 = MKPointAnnotation()
        annotationBuilding26.coordinate = CLLocationCoordinate2D(latitude: 13.74689, longitude: 100.56527)
        annotationBuilding26.title = "คณะมนุษยศาสตร์ (อาคารใหม่)"
        annotationBuilding26.subtitle = "อาคาร 38"
        mapView.addAnnotation(annotationBuilding26)
        ArrBuilding.append(annotationBuilding26)
        //
        
        // สนาม
        // 1
        let annotationField1 = MKPointAnnotation()
        annotationField1.coordinate = CLLocationCoordinate2D(latitude: 13.74484, longitude: 100.56467)
        annotationField1.title = "สนามฟุตบอล (สนามกลาง)"
        annotationField1.subtitle = "สนาม 80"
        mapView.addAnnotation(annotationField1)
        ArrField.append(annotationField1)
        //
        // 2
        let annotationField2 = MKPointAnnotation()
        annotationField2.coordinate = CLLocationCoordinate2D(latitude: 13.74685, longitude: 100.56479)
        annotationField2.title = "สนามบาส"
        annotationField2.subtitle = "สนาม 81"
        mapView.addAnnotation(annotationField2)
        ArrField.append(annotationField2)
        //
        // 3
        let annotationField3 = MKPointAnnotation()
        annotationField3.coordinate = CLLocationCoordinate2D(latitude: 13.74608, longitude: 100.56529)
        annotationField3.title = "สนามบาส (กลางแจ้ง)"
        annotationField3.subtitle = "สนาม 82"
        mapView.addAnnotation(annotationField3)
        ArrField.append(annotationField3)
        //
        // 4
        let annotationField4 = MKPointAnnotation()
        annotationField4.coordinate = CLLocationCoordinate2D(latitude: 13.74624, longitude: 100.56446)
        annotationField4.title = "คอร์ดเทนนิส"
        annotationField4.subtitle = "สนาม 83"
        mapView.addAnnotation(annotationField4)
        ArrField.append(annotationField4)
        //
        
        // ประตู
        // 1
        let annotationGate1 = MKPointAnnotation()
        annotationGate1.coordinate = CLLocationCoordinate2D(latitude: 13.74507, longitude: 100.56272)
        annotationGate1.title = "ประตูหลัก"
        annotationGate1.subtitle = "ถนนอโศกมนตรี"
        mapView.addAnnotation(annotationGate1)
        ArrGate.append(annotationGate1)
        //
        // 2
        let annotationGate2 = MKPointAnnotation()
        annotationGate2.coordinate = CLLocationCoordinate2D(latitude: 13.74365, longitude: 100.56378)
        annotationGate2.title = "ประตู 1"
        annotationGate2.subtitle = "สุขุมวิท 23 (GMM)"
        mapView.addAnnotation(annotationGate2)
        ArrGate.append(annotationGate2)
        //
        // 3
        let annotationGate3 = MKPointAnnotation()
        annotationGate3.coordinate = CLLocationCoordinate2D(latitude: 13.74342, longitude: 100.56496)
        annotationGate3.title = "ประตู 2"
        annotationGate3.subtitle = "สุขุมวิท 23 (สำนักอธิการบดี)"
        mapView.addAnnotation(annotationGate3)
        ArrGate.append(annotationGate3)
        //
        // 4
        let annotationGate4 = MKPointAnnotation()
        annotationGate4.coordinate = CLLocationCoordinate2D(latitude: 13.74359, longitude: 100.56613)
        annotationGate4.title = "ประตู 3"
        annotationGate4.subtitle = "สุขุมวิท 31 (โรงเรียนสาธิตมหาวิทยาลัยศรีนครินทรวิโรฒ ประสานมิตร)"
        mapView.addAnnotation(annotationGate4)
        ArrGate.append(annotationGate4)
        //
        // 5
        let annotationGate5 = MKPointAnnotation()
        annotationGate5.coordinate = CLLocationCoordinate2D(latitude: 13.74711, longitude: 100.56570)
        annotationGate5.title = "ประตู 4"
        annotationGate5.subtitle = "ท่าเรือ มศว ประสานมิตร"
        mapView.addAnnotation(annotationGate5)
        ArrGate.append(annotationGate5)
        //
        // 6
        let annotationGate6 = MKPointAnnotation()
        annotationGate6.coordinate = CLLocationCoordinate2D(latitude: 13.74588, longitude: 100.56413)
        annotationGate6.title = "ประตู 5"
        annotationGate6.subtitle = "ถนนอโศกมนตรี (รพ.จักษุรัตนิน)"
        mapView.addAnnotation(annotationGate6)
        ArrGate.append(annotationGate6)
        //
        
        // โรงอาหาร
        // 37
        let annotationCanteen1 = MKPointAnnotation()
        annotationCanteen1.coordinate = CLLocationCoordinate2D(latitude: 13.74385, longitude: 100.56611)
        annotationCanteen1.title = "โรงอาหาร"
        annotationCanteen1.subtitle = "1 ชั้น"
        mapView.addAnnotation(annotationCanteen1)
        ArrCanteen.append(annotationCanteen1)
        ArrToilet.append(annotationCanteen1)
        Arr711.append(annotationCanteen1)
        ArrATM.append(annotationCanteen1)
        //
        // 38
        let annotationCanteen2 = MKPointAnnotation()
        annotationCanteen2.coordinate = CLLocationCoordinate2D(latitude: 13.74430, longitude: 100.56626)
        annotationCanteen2.title = "โรงอาหาร"
        annotationCanteen2.subtitle = "2 ชั้น"
        mapView.addAnnotation(annotationCanteen2)
        ArrCanteen.append(annotationCanteen2)
        ArrToilet.append(annotationCanteen2)
        //
        // 39
        let annotationCanteen3 = MKPointAnnotation()
        annotationCanteen3.coordinate = CLLocationCoordinate2D(latitude: 13.74689, longitude: 100.56557)
        annotationCanteen3.title = "โรงอาหาร"
        annotationCanteen3.subtitle = "COSCI"
        mapView.addAnnotation(annotationCanteen3)
        ArrCanteen.append(annotationCanteen3)
        ArrToilet.append(annotationCanteen3)
        //
        
    }
    
    func addAnnotation(annotation: MKAnnotation) {
        self.mapView.addAnnotation(annotation)
    }
    
    func addArrayAnnotation(annotation: [MKAnnotation]) {
        self.mapView.addAnnotations(annotation)
    }
    
    func removeAnnotation(annotation: MKAnnotation) {
        self.mapView.removeAnnotation(annotation)
    }
    
    func removeArrayAnnotation(annotation: [MKAnnotation]) {
        self.mapView.removeAnnotations(annotation)
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        menu.selectionAction = { index, title in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.transparentView.alpha = 0
            }, completion: nil)
            if FirebaseAuth.Auth.auth().currentUser == nil {
                if index == 0 {
                    let vc = LoginViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if index == 1 {
                    let vc = RegisterViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else {
                self.menu_Logged_in()
                if index == 0 {
                    let vc = ProfileViewController()
                    vc.title = "Profile"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if index == 1 {
                    let vc = ConversationViewController()
                    vc.title = "Friend List"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if index == 2 {
                    do {
                        try FirebaseAuth.Auth.auth().signOut()
                    } catch let signOutError as NSError {
                        print("SignOut Error \(signOutError)")
                    }
                    self.menu.dataSource = [
                        "Login",
                        "Register"
                    ]
                    self.images = [
                        "gear",
                        "gear"
                    ]
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "name")
                    let alert = UIAlertController(title: "Log Out",
                                                  message: "Log out successful!",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        if annotationSet == false {
            createAnnotation()
            annotationSet = true
        }
        
        let myView = UIView(frame: navigationController?.navigationBar.frame ?? .zero)
        navigationController?.navigationBar.topItem?.titleView = myView
        
//        let titleLabel : UILabel = {
//            let titleLabel = UILabel()
//            titleLabel.frame = CGRect(x: 158, y: 8, width: UIScreen.main.bounds.size.width-28, height: 30)
//            titleLabel.textColor = UIColor.black
//            titleLabel.text = "SWU map"
//            return titleLabel
//        }()
//        myView.addSubview(titleLabel)
        
        let imageButton : UIButton = {
            let imageButton = UIButton()
            imageButton.layer.frame = CGRect(x: 5, y: 8, width: 28, height: 28)
            imageButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
            imageButton.imageEdgeInsets = UIEdgeInsets(top: -40, left: -40, bottom: -40, right: -40)
            return imageButton
        }()
        myView.addSubview(imageButton)
        
        self.navigationItem.titleView = myView
        guard let topView = navigationController?.navigationBar.topItem?.titleView else { return }
        menu.anchorView = topView
        menu.bottomOffset = CGPoint(x: 0, y: 42)
        menu.width = 250
        DropDown.appearance().cellHeight = 50
        
        filtermenu.anchorView = filtermenuBtn.plainView
        filtermenu.bottomOffset = CGPoint(x: 0, y: 100)
        filtermenu.width = 250
        filtermenu.direction = .top
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        imageButton.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(didTapBottomLeftItem))
        gesture1.numberOfTapsRequired = 1
        gesture1.numberOfTouchesRequired = 1
        filtermenuBtn.addGestureRecognizer(gesture1)
        
        if FirebaseAuth.Auth.auth().currentUser == nil  {
            menu.dataSource = [
                "Login",
                "Register"
            ]
            
            images = [
                "gear",
                "gear"
            ]
        }
        else {
            menu.dataSource = [
                "Profile",
                "Friends List",
                "Logout"
            ]
            images = [
                "gear",
                "gear",
                "gear"
            ]
        }
        
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        menu.customCellConfiguration = { index, title, cell in
            guard let cell = cell as? MyCell else { return }
            cell.myImageView.image = UIImage(systemName: self.images[index])
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearchButton))
        
        // ปัก center
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 13.74486, longitude: 100.56472)
        
// default zooming range
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        // range screenBorder
        let regionBorder = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        // set default zooming range
        mapView.setRegion(region, animated: true)
        
        // show max/min zoom
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 500,
            maxCenterCoordinateDistance: 2000)
        
        // show screenBorder
        mapView.cameraBoundary = MKMapView.CameraBoundary(
            coordinateRegion: regionBorder)
        
        // check
        if UserDefaults.standard.string(forKey: "AnnotationID") != nil {
            annotationID = UserDefaults.standard.string(forKey: "AnnotationID")!
            removeArrayAnnotation(annotation: ArrBuilding)
            removeArrayAnnotation(annotation: ArrField)
            removeArrayAnnotation(annotation: Arr711)
            removeArrayAnnotation(annotation: ArrATM)
            removeArrayAnnotation(annotation: ArrGate)
            removeArrayAnnotation(annotation: ArrCanteen)
            removeArrayAnnotation(annotation: ArrToilet)
        }
        else {
            annotationID = "NONE"
        }
        
        // search
        if annotationID == "01" {

            addAnnotation(annotation: ArrBuilding[0])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "02" {
            
            addAnnotation(annotation: ArrBuilding[1])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "03" {
            
            addAnnotation(annotation: ArrBuilding[2])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "06" {
            
            addAnnotation(annotation: ArrBuilding[3])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
            
        }
        else if annotationID == "08" {
            
            addAnnotation(annotation: ArrBuilding[4])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "09" {
            
            addAnnotation(annotation: ArrBuilding[5])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "10" {
            
            addAnnotation(annotation: ArrBuilding[6])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "11" {
            
            addAnnotation(annotation: ArrBuilding[7])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "12" {
            
            addAnnotation(annotation: ArrBuilding[8])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "14" {
            
            addAnnotation(annotation: ArrBuilding[9])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "15" {
            
            addAnnotation(annotation: ArrBuilding[10])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "16" {
            
            addAnnotation(annotation: ArrBuilding[11])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "17" {
            
            addAnnotation(annotation: ArrBuilding[12])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "18" {
            
            addAnnotation(annotation: ArrBuilding[13])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "19" {
            
            addAnnotation(annotation: ArrBuilding[14])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "20" {
            
            addAnnotation(annotation: ArrBuilding[15])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "23" {
            
            addAnnotation(annotation: ArrBuilding[16])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "24" {
            
            addAnnotation(annotation: ArrBuilding[17])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "25" {
            
            addAnnotation(annotation: ArrBuilding[18])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "27" {
            
            addAnnotation(annotation: ArrBuilding[19])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "33" {
            
            addAnnotation(annotation: ArrBuilding[20])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "34" {
            
            addAnnotation(annotation: ArrBuilding[21])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "35" {
            
            addAnnotation(annotation: ArrBuilding[22])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "36" {
            
            addAnnotation(annotation: ArrBuilding[23])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "37" {
            
            addAnnotation(annotation: ArrBuilding[24])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "38" {
            
            addAnnotation(annotation: ArrBuilding[25])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "80" {
            
            addAnnotation(annotation: ArrField[0])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "81" {
            
            addAnnotation(annotation: ArrField[1])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "82" {
            
            addAnnotation(annotation: ArrField[2])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "83" {
            
            addAnnotation(annotation: ArrField[3])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "DM00" {
            
            addAnnotation(annotation: ArrGate[0])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "DR01" {
            
            addAnnotation(annotation: ArrGate[1])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "DR02" {
            
            addAnnotation(annotation: ArrGate[2])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "DR03" {
            
            addAnnotation(annotation: ArrGate[3])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "DR04" {
            
            addAnnotation(annotation: ArrGate[4])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "DR05" {
            
            addAnnotation(annotation: ArrGate[5])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "FD01" {
            
            addAnnotation(annotation: ArrCanteen[0])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "FD02" {
            
            addAnnotation(annotation: ArrCanteen[1])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        else if annotationID == "FD03" {
            
            addAnnotation(annotation: ArrCanteen[2])
            
            UserDefaults.standard.removeObject(forKey: "AnnotationID")
            annotationID = ""
            
        }
        
        // filter
        filtermenu.selectionAction = { [self] index, title in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.transparentView.alpha = 0
            }, completion: nil)
            
            removeArrayAnnotation(annotation: ArrBuilding)
            removeArrayAnnotation(annotation: ArrField)
            removeArrayAnnotation(annotation: Arr711)
            removeArrayAnnotation(annotation: ArrATM)
            removeArrayAnnotation(annotation: ArrGate)
            removeArrayAnnotation(annotation: ArrCanteen)
            removeArrayAnnotation(annotation: ArrToilet)
            
            // อาคาร
            if index == 0 {
                addArrayAnnotation(annotation: ArrBuilding)
            }
            // สนามกีฬา
            else if index == 1 {
                addArrayAnnotation(annotation: ArrField)
            }
            // โรงอาหาร
            else if index == 2 {
                addArrayAnnotation(annotation: ArrCanteen)
            }
            // โรงอาหาร
            else if index == 3 {
                addArrayAnnotation(annotation: Arr711)
            }
            // โรงอาหาร
            else if index == 4 {
                addArrayAnnotation(annotation: ArrATM)
            }
            // ห้องน้ำ
            else if index == 5 {
                addArrayAnnotation(annotation: ArrToilet)
            }
            // ประตู
            else if index == 6 {
                addArrayAnnotation(annotation: ArrGate)
            }
            // ทั้งหมด
            else if index == 7 {
                addArrayAnnotation(annotation: ArrBuilding)
                addArrayAnnotation(annotation: ArrField)
                addArrayAnnotation(annotation: ArrGate)
                addArrayAnnotation(annotation: ArrCanteen)
                addArrayAnnotation(annotation: ArrToilet)
            }
        }
    }
    
    @objc func didTapSearchButton() {
        let vc = SearchViewController()
        let navvc = UINavigationController(rootViewController: vc)
        present(navvc, animated: true, completion: nil)
    }
    
    func addtransparentView() {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        transparentView.alpha = 0
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
        }, completion: nil)
    }
    
    @objc func removetransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
        }, completion: nil)
        menu.hide()
        filtermenu.hide()
    }
    
    @objc func didTapTopItem() {
        menu.show()
        addtransparentView()
        let tapMenuViewGesture = UITapGestureRecognizer(target: self, action: #selector(removetransparentView))
        menu.dismissableView.addGestureRecognizer(tapMenuViewGesture)
    }
    
    @objc func didTapBottomLeftItem() {
        filtermenu.show()
        addtransparentView()
        let tapFilterMenuViewGesture = UITapGestureRecognizer(target: self, action: #selector(removetransparentView))
        filtermenu.dismissableView.addGestureRecognizer(tapFilterMenuViewGesture)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var lbStepperZoom: UILabel!
    @IBOutlet weak var StepperOutlet: UIStepper!
    @IBAction func btnStepper(_ sender: UIStepper) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 13.74486, longitude: 100.56472)
        
        var region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        switch sender.value {
        case 0:
            region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
            lbStepperZoom.text = "75%"
        case 1:
            region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            lbStepperZoom.text = "100%"
        case 2:
            region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            lbStepperZoom.text = "150%"
        case 3:
            region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            lbStepperZoom.text = "200%"
        default:
            StepperOutlet.value = 1
            lbStepperZoom.text = ""
        }
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription )")
    }
    
}
