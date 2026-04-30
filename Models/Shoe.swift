import Foundation

// MARK: - Enums
enum Genero: String, CaseIterable, Codable {
    case hombre = "Hombre"
    case mujer = "Mujer"
    case unisex = "Unisex"
    case nino = "Niño"
    
    var icono: String {
        switch self {
        case .hombre: return "person.fill"
        case .mujer: return "person.fill"
        case .unisex: return "person.2.fill"
        case .nino: return "figure.child"
        }
    }
}

enum TipoCalzado: String, CaseIterable, Codable {
    case tenis = "Tenis"
    case bota = "Bota"
    case sandalia = "Sandalia"
    case mocasin = "Mocasín"
    case oxford = "Oxford"
    case deportivo = "Deportivo"
    case tacón = "Tacón"
    case loafer = "Loafer"
    
    var icono: String {
        switch self {
        case .tenis: return "🥾"
        case .bota: return "🥾"
        case .sandalia: return "👡"
        case .mocasin: return "🥿"
        case .oxford: return "👞"
        case .deportivo: return "👟"
        case .tacón: return "👠"
        case .loafer: return "🥿"
        }
    }
}

// MARK: - Shoe Model
struct Shoe: Identifiable, Codable {
    let id: UUID
    let sku: String
    let nombre: String
    let marca: String
    let tipo: TipoCalzado
    let genero: Genero
    let color: String
    let colorHex: String
    let tallas: [Double]
    let precio: Double
    let descripcion: String
    let imagenSistema: String
    var disponible: Bool
    
    var precioFormateado: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "MXN"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: precio)) ?? "$\(precio)"
    }
}

// MARK: - Sample Data
extension Shoe {
    static let catalogo: [Shoe] = [
        Shoe(
            id: UUID(),
            sku: "TEN-001-BLK",
            nombre: "AirMax Clásico",
            marca: "RunFast",
            tipo: .deportivo,
            genero: .hombre,
            color: "Negro",
            colorHex: "#1A1A2E",
            tallas: [25.0, 26.0, 27.0, 28.0, 29.0],
            precio: 1899.00,
            descripcion: "Tenis deportivo con amortiguación de aire, suela de caucho y material transpirable. Ideal para correr y entrenar.",
            imagenSistema: "figure.run",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "BOT-002-MAR",
            nombre: "Bota Montana",
            marca: "TrailKing",
            tipo: .bota,
            genero: .hombre,
            color: "Café",
            colorHex: "#8B4513",
            tallas: [26.0, 27.0, 28.0, 29.0, 30.0],
            precio: 2450.00,
            descripcion: "Bota de cuero genuino con forro térmico, suela antideslizante y punta reforzada. Perfecta para terrenos irregulares.",
            imagenSistema: "mountain.2.fill",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "TAC-003-ROJ",
            nombre: "Stiletto Elegance",
            marca: "ModaLux",
            tipo: .tacón,
            genero: .mujer,
            color: "Rojo",
            colorHex: "#C0392B",
            tallas: [22.0, 23.0, 24.0, 25.0, 26.0],
            precio: 1650.00,
            descripcion: "Tacón de aguja en cuero genuino con punta fina. Diseño sofisticado para ocasiones especiales y eventos formales.",
            imagenSistema: "sparkles",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "SAN-004-BEI",
            nombre: "Sandalia Brisa",
            marca: "SummerStep",
            tipo: .sandalia,
            genero: .mujer,
            color: "Beige",
            colorHex: "#D4B896",
            tallas: [22.0, 23.0, 24.0, 25.0, 26.0, 27.0],
            precio: 899.00,
            descripcion: "Sandalia ligera con plantilla de memory foam y correas ajustables. Comodidad todo el día para el uso casual.",
            imagenSistema: "sun.max.fill",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "OXF-005-NEG",
            nombre: "Oxford Premier",
            marca: "ClassicMen",
            tipo: .oxford,
            genero: .hombre,
            color: "Negro",
            colorHex: "#2C3E50",
            tallas: [25.0, 26.0, 27.0, 28.0, 29.0, 30.0],
            precio: 3200.00,
            descripcion: "Oxford de cuero italiano con costura Blake, suela de cuero y forro de piel. Elegancia clásica para uso formal y de negocios.",
            imagenSistema: "briefcase.fill",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "TEN-006-BLN",
            nombre: "Urban Retro",
            marca: "StreetWear",
            tipo: .tenis,
            genero: .unisex,
            color: "Blanco",
            colorHex: "#ECF0F1",
            tallas: [23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0],
            precio: 1350.00,
            descripcion: "Tenis retro de cuero sintético con suela de goma vulcanizada. Estilo urbano atemporal para hombre y mujer.",
            imagenSistema: "star.fill",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "MOC-007-GRI",
            nombre: "Mocasín Comfort",
            marca: "EasyFoot",
            tipo: .mocasin,
            genero: .hombre,
            color: "Gris",
            colorHex: "#7F8C8D",
            tallas: [25.0, 26.0, 27.0, 28.0, 29.0],
            precio: 1100.00,
            descripcion: "Mocasín sin cordones con suela flexible y plantilla ergonómica. Calzado casual perfecto para el uso diario en oficina.",
            imagenSistema: "building.2.fill",
            disponible: false
        ),
        Shoe(
            id: UUID(),
            sku: "BOT-008-CAF",
            nombre: "Bota Chelsea Slim",
            marca: "UrbanBoot",
            tipo: .bota,
            genero: .mujer,
            color: "Café Oscuro",
            colorHex: "#5D4037",
            tallas: [22.0, 23.0, 24.0, 25.0, 26.0],
            precio: 1980.00,
            descripcion: "Bota Chelsea de caña media en cuero con elásticos laterales y suela apilada. Tendencia urban chic para temporada fría.",
            imagenSistema: "wind.snow",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "DEP-009-AZL",
            nombre: "SpeedRun Pro",
            marca: "AthleteX",
            tipo: .deportivo,
            genero: .hombre,
            color: "Azul",
            colorHex: "#2980B9",
            tallas: [25.0, 26.0, 27.0, 28.0, 29.0, 30.0],
            precio: 2200.00,
            descripcion: "Zapatilla de alto rendimiento con tecnología de amortiguación reactiva, suela de carbono y tejido Flyknit. Para atletas exigentes.",
            imagenSistema: "bolt.fill",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "LOA-010-VRD",
            nombre: "Loafer Garden",
            marca: "GreenStep",
            tipo: .loafer,
            genero: .mujer,
            color: "Verde Olivo",
            colorHex: "#556B2F",
            tallas: [22.0, 23.0, 24.0, 25.0, 26.0],
            precio: 1450.00,
            descripcion: "Loafer de cuero vegano con adorno de cadena dorada. Diseño contemporáneo y cómodo para looks casuales sofisticados.",
            imagenSistema: "leaf.fill",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "TEN-011-ROS",
            nombre: "Pinky Runner",
            marca: "GirlRun",
            tipo: .deportivo,
            genero: .mujer,
            color: "Rosa",
            colorHex: "#E91E8C",
            tallas: [22.0, 23.0, 24.0, 25.0],
            precio: 1599.00,
            descripcion: "Tenis deportivo femenino con tecnología de soporte de arco, suela ligera y diseño moderno en tonos rosas vibrantes.",
            imagenSistema: "heart.fill",
            disponible: true
        ),
        Shoe(
            id: UUID(),
            sku: "SAN-012-NAR",
            nombre: "Sandalia Verano",
            marca: "TropicStep",
            tipo: .sandalia,
            genero: .nino,
            color: "Naranja",
            colorHex: "#E67E22",
            tallas: [16.0, 17.0, 18.0, 19.0, 20.0],
            precio: 450.00,
            descripcion: "Sandalia infantil resistente al agua con cierre de velcro, suela antideslizante y diseño divertido para niños activos.",
            imagenSistema: "figure.child",
            disponible: true
        )
    ]
}
