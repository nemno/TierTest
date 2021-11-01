//
//  ScooterClusterAnnotationView.swift
//  TierTest
//

import MapKit

final class ScooterClusterAnnotationView: MKAnnotationView {
    private let markerSize: CGFloat = 40.0
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        displayPriority = .defaultLow

        if let cluster = annotation as? MKClusterAnnotation {
            let totalScooters = cluster.memberAnnotations.count
            
            for subView in self.subviews {
                subView.removeFromSuperview()
            }
            
            let numberLabel = UILabel(frame: .zero)
            numberLabel.textAlignment = .center
            numberLabel.backgroundColor = .white
            numberLabel.text = String(totalScooters)
            numberLabel.textColor = Constants.textColor
            numberLabel.layer.cornerRadius = markerSize / 2.0
            numberLabel.layer.masksToBounds = true
            numberLabel.layer.borderWidth = Constants.borderWidth
            numberLabel.layer.borderColor = Constants.borderColor.cgColor
            self.addSubview(numberLabel)
            numberLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(markerSize)
                make.height.equalTo(markerSize)
            }
        }
    }
}

private extension ScooterClusterAnnotationView {
    enum Constants {
        static let borderWidth: CGFloat = 2.0
        static let borderColor: UIColor = UIColor.DefaultTheme.mainColor
        static let textColor: UIColor = UIColor.DefaultTheme.mainColor
    }
}
