//
//  ScooterDetailView.swift
//  TierTest
//
import UIKit

final class ScooterDetailView: UIView {
    private var scooterImageView: UIImageView = UIImageView(frame: .zero)
    private var modelLabel: UILabel = UILabel(frame: .zero)
    private var batteryImageView: UIImageView = UIImageView(frame: .zero)
    private var batteryLabel: UILabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupBackground()
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Helper methods
    
    private func setupBackground() {
        self.backgroundColor = .clear
        
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = Constants.backgroundCornerRadius
        self.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialLight)
        let blurredBackgroundView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(blurredBackgroundView)
        blurredBackgroundView.snp.makeConstraints { make in
            make.leading.equalTo(0.0)
            make.top.equalTo(0.0)
            make.trailing.equalTo(0.0)
            make.bottom.equalTo(0.0)
        }
    }
    
    private func setupSubViews() {
        self.addSubview(scooterImageView)
        self.addSubview(modelLabel)
        self.addSubview(batteryImageView)
        self.addSubview(batteryLabel)
        
        setupScooterImageView()
        setupModelLabel()
        setupBatteryImage()
        setupBatteryLabel()
    }
    
    private func setupScooterImageView() {
        scooterImageView.image = #imageLiteral(resourceName: "scooterImage")
        scooterImageView.layer.cornerRadius = Constants.scooterImageCornerRadius
        scooterImageView.layer.masksToBounds = true
        scooterImageView.layer.borderWidth = Constants.scooterImageBorderWidth
        scooterImageView.layer.borderColor = UIColor.DefaultTheme.mainColor.cgColor
        scooterImageView.snp.makeConstraints { make in
            make.top.equalTo(Constants.padding)
            make.leading.equalTo(Constants.padding)
            make.width.equalTo(Constants.scooterImageSize)
            make.height.equalTo(Constants.scooterImageSize)
        }
    }
    
    private func setupModelLabel() {
        modelLabel.textAlignment = .center
        modelLabel.font = .boldSystemFont(ofSize: 16.0)
        modelLabel.textColor = UIColor.DefaultTheme.textColor
        modelLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.leading.equalTo(self.scooterImageView.snp.trailing).offset(Constants.padding)
            make.top.equalTo(self.scooterImageView.snp.top)
            make.trailing.equalTo(-1.0 * Constants.padding)
        }
    }
    
    private func setupBatteryImage() {
        let batteryImage = #imageLiteral(resourceName: "batteryIcon")
        batteryImageView.image = batteryImage.withRenderingMode(.alwaysTemplate)
        batteryImageView.tintColor = UIColor.DefaultTheme.mainColor
        batteryImageView.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.leading.equalTo(self.modelLabel.snp.leading)
            make.top.equalTo(self.modelLabel.snp.bottom).offset(Constants.spacing)
            make.width.equalTo(Constants.batteryImageSize)
            make.height.equalTo(Constants.batteryImageSize)
        }
    }
    
    private func setupBatteryLabel() {
        batteryLabel.textAlignment = .left
        batteryLabel.font = .boldSystemFont(ofSize: 14.0)
        batteryLabel.textColor = UIColor.DefaultTheme.textColor
        batteryLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.leading.equalTo(self.batteryImageView.snp.trailing).offset(Constants.spacing)
            make.top.equalTo(self.batteryImageView.snp.top)
            make.trailing.equalTo(-1.0 * Constants.padding)
            make.height.equalTo(self.batteryImageView.snp.height)
        }
    }
    
    // MARK: - Public methods
    
    func setup(with scooter: ScooterViewModel) {
        self.modelLabel.text = scooter.model
        self.batteryLabel.text = scooter.batteryStatus
    }
}

// MARK: - Constants
private extension ScooterDetailView {
    enum Constants {
        static let padding: CGFloat = 32.0
        static let spacing: CGFloat = 16.0
        static let backgroundCornerRadius: CGFloat = 20.0
        static let scooterImageSize: CGFloat = 100.0
        static let scooterImageCornerRadius: CGFloat = 30.0
        static let scooterImageBorderWidth: CGFloat = 2.0
        static let batteryImageSize: CGFloat = 32.0
    }
}
