///  Created by Roman Turov on 16/04/2019.

import AlfaFoundation
import SharedProtocolsAndModels

protocol OfficeChangingPresentationLogic {
    func present(_ response: OfficeChanging.PresentCells.Response)
    func presentCitiesList(_ response: OfficeChanging.OpenCitiesList.Response)
    func presentMetroList(_ response: OfficeChanging.OpenMetroList.Response)
    func presentOfficesList(_ response: OfficeChanging.OpenOfficesList.Response)
    func presentUpdatedReissuesOffice()
    func presentError(_ error: OfficeChanging.ErrorType)
}

class OfficeChangingInteractor: OfficeChangingBusinessLogic {
    let presenter: OfficeChangingPresentationLogic
    let provider: ProvidesBankOffices
    let updateOfficeService: UpdatesReissuesOffice
    var selectedCity: City?
    var selectedMetro: Metro?
    var selectedOffice: Office?
    let configuration = Configuration()
    var cardID: String

    init(
        cardID: String,
        presenter: OfficeChangingPresentationLogic,
        provider: ProvidesBankOffices,
        updateOfficeService: UpdatesReissuesOffice = OfficeChangingUpdateService()
    ) {
        self.presenter = presenter
        self.provider = provider
        self.cardID = cardID
        self.updateOfficeService = updateOfficeService
    }

    func getCities() {
        firstly {
            provider.getCities()
        }.done { _ in
            self.presenter.present(.init(items: [self.city], isConfirmationAvailable: false))
        }.catch {
            ABLogError($0.localizedDescription)
            self.presenter.presentError(.emptyState)
        }
    }

    func openCitiesList() {
        firstly {
            provider.getCities()
        }.then(on: .global(qos: .userInitiated)) { cities -> Promise<[City]> in
            .value(self.sortCities(cities))
        }.done { cities in
            self.presenter.presentCitiesList(.init(
                itemsList: cities,
                selectedItemIndex: self.selectedCity.flatMap { cities.firstIndex(of: $0) }
            ))
        }.catch {
            ABLogError($0.localizedDescription)
            self.presenter.presentError(.defaultError)
        }
    }

    func openMetroList() {
        guard let city = selectedCity else { return }
        firstly {
            provider.getMetro(in: city)
        }.then(on: .global(qos: .userInitiated)) { metroList -> Promise<[Metro]> in
            .value(self.sortMetro(metroList))
        }.done { metroList in
            self.presenter.presentMetroList(.init(
                itemsList: metroList,
                selectedItemIndex: self.selectedMetro.flatMap { metroList.firstIndex(of: $0) }
            ))
        }.catch {
            ABLogError($0.localizedDescription)
            self.presenter.presentError(.defaultError)
        }
    }

    func selectCity(_ request: OfficeChanging.SelectCity.Request) {
        provider.invalidateCache()
        selectedOffice = nil
        selectedMetro = nil
        firstly {
            provider.getCities()
        }.then(on: .global(qos: .userInitiated)) { cities -> Promise<City?> in
            self.selectedCity = self.sortCities(cities)[safe: request.index]
            return .value(self.selectedCity)
        }.compactMap {
            $0
        }.then { city -> Promise<([Metro], City)> in
            self.provider.getMetro(in: city).map { ($0, city) }
        }.then { metroList, city -> Promise<([Metro]?, [Office]?)> in
            if metroList.isEmpty {
                return self.provider.getOffice(in: city, nearBy: nil).map { (nil, $0) }
            } else {
                return .value((metroList, nil))
            }
        }.done { metroList, offices in
            if let metroList = metroList, metroList.isNotEmpty {
                self.presenter.present(.init(items: [self.city, self.metro], isConfirmationAvailable: false))
            } else if let offices = offices, offices.isNotEmpty {
                self.presenter.present(.init(items: [self.city, self.office], isConfirmationAvailable: false))
            }
        }.catch {
            ABLogError($0.localizedDescription)
            self.presenter.presentError(.defaultError)
        }
    }

    func selectMetro(_ request: OfficeChanging.SelectMetro.Request) {
        provider.invalidateOfficesCache()
        selectedOffice = nil
        guard let city = selectedCity else { return }
        firstly {
            provider.getMetro(in: city)
        }.then(on: .global(qos: .userInitiated)) { metroList -> Promise<Metro?> in
            self.selectedMetro = self.sortMetro(metroList)[safe: request.index]
            return .value(self.selectedMetro)
        }.compactMap {
            $0
        }.then { metro in
            self.provider.getOffice(in: city, nearBy: metro)
        }.done { offices in
            guard offices.isNotEmpty else { return }
            self.presenter.present(.init(items: [self.city, self.metro, self.office], isConfirmationAvailable: false))
        }.catch {
            ABLogError($0.localizedDescription)
            self.presenter.presentError(.defaultError)
        }
    }

    func openOfficesList() {
        guard let city = selectedCity else { return }
        firstly {
            provider.getOffice(in: city, nearBy: selectedMetro)
        }.then(on: .global(qos: .userInitiated)) { offices -> Promise<[Office]> in
            .value(self.sortOffices(offices))
        }.done { offices in
            self.presenter.presentOfficesList(.init(
                itemsList: offices,
                selectedItemIndex: self.selectedOffice.flatMap { offices.firstIndex(of: $0) }
            ))
        }.catch {
            ABLogError($0.localizedDescription)
            self.presenter.presentError(.defaultError)
        }
    }

    func selectOffice(_ request: OfficeChanging.SelectOffice.Request) {
        guard let city = selectedCity else { return }
        firstly {
            provider.getOffice(in: city, nearBy: selectedMetro)
        }.then(on: .global(qos: .userInitiated)) { offices -> Promise<Office?> in
            self.selectedOffice = self.sortOffices(offices)[safe: request.index]
            return .value(self.selectedOffice)
        }.done { office in
            self.presenter.present(.init(
                items: self.selectedMetro != nil
                    ? [self.city, self.metro, self.office]
                    : [self.city, self.office],
                isConfirmationAvailable: office != nil
            ))
        }.catch {
            ABLogError($0.localizedDescription)
            self.presenter.presentError(.defaultError)
        }
    }

    func sortCities(_ cities: [City]) -> [City] {
        var sortedCities = cities.sorted(by: { $0.name < $1.name })
        if let moscow = sortedCities.first(where: { $0.path == configuration.moscowIdentifier }) {
            sortedCities.move(moscow, to: 0)
        }
        if let saintPetersburg = sortedCities.first(where: { $0.path == configuration.saintPetersburgIdentifier }) {
            sortedCities.move(saintPetersburg, to: 1)
        }
        return sortedCities
    }

    func updateReissuesOffice() {
        guard let selectedOffice = selectedOffice else { return }
        firstly {
            updateOfficeService.updateReissuesOffice(cardID: cardID, officeID: selectedOffice.number)
        }.done { _ in
            self.presenter.presentUpdatedReissuesOffice()
        }.catch {
            ABLogError("Update Reissues Office Error \($0.localizedDescription)")
            self.presenter.presentError(.error(message: $0.localizedDescription))
        }
    }

    func sortMetro(_ metro: [Metro]) -> [Metro] {
        metro.sorted(by: { $0.name < $1.name })
    }

    func sortOffices(_ offices: [Office]) -> [Office] {
        offices.sorted(by: { $0.address < $1.address })
    }

    private var city: OfficeChanging.PresentedCellType {
        .city(selectedCity)
    }

    private var metro: OfficeChanging.PresentedCellType {
        .metro(selectedMetro)
    }

    private var office: OfficeChanging.PresentedCellType {
        .office(selectedOffice)
    }
}

extension OfficeChangingInteractor {
    struct Configuration {
        let moscowIdentifier = "moscow"
        let saintPetersburgIdentifier = "peterburg"
    }
}
