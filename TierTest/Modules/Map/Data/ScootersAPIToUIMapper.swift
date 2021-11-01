//
//  ScootersAPIToUIMapper.swift
//  TierTest
//

import CoreLocation

final class ScootersAPIToUIMapper {
    func map(apiModels: [SccoterAPIModel]) -> [ScooterViewModel] {
        return apiModels.map { apiModel -> ScooterViewModel in
            let annotation = ScooterAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: apiModel.latitude, longitude: apiModel.longitude)
            return ScooterViewModel(model: apiModel.model, annotation: annotation, batteryStatus: String(apiModel.battery) + "%")
        }
    }
}
