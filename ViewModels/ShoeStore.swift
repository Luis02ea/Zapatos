import Foundation
import SwiftUI

class ShoeStore: ObservableObject {
    @Published var zapatos: [Shoe] = Shoe.catalogo
    @Published var busqueda: String = ""
    @Published var generoSeleccionado: Genero? = nil
    @Published var tipoSeleccionado: TipoCalzado? = nil
    @Published var soloDisponibles: Bool = false
    @Published var ordenPrecio: OrdenPrecio = .ninguno
    
    enum OrdenPrecio: String, CaseIterable {
        case ninguno = "Sin orden"
        case ascendente = "Menor precio"
        case descendente = "Mayor precio"
    }
    
    var zapatosFiltrados: [Shoe] {
        var resultado = zapatos
        
        // Búsqueda por nombre, SKU o marca
        if !busqueda.isEmpty {
            resultado = resultado.filter {
                $0.nombre.localizedCaseInsensitiveContains(busqueda) ||
                $0.sku.localizedCaseInsensitiveContains(busqueda) ||
                $0.marca.localizedCaseInsensitiveContains(busqueda) ||
                $0.color.localizedCaseInsensitiveContains(busqueda)
            }
        }
        
        // Filtro género
        if let genero = generoSeleccionado {
            resultado = resultado.filter { $0.genero == genero }
        }
        
        // Filtro tipo
        if let tipo = tipoSeleccionado {
            resultado = resultado.filter { $0.tipo == tipo }
        }
        
        // Solo disponibles
        if soloDisponibles {
            resultado = resultado.filter { $0.disponible }
        }
        
        // Orden por precio
        switch ordenPrecio {
        case .ascendente:
            resultado.sort { $0.precio < $1.precio }
        case .descendente:
            resultado.sort { $0.precio > $1.precio }
        case .ninguno:
            break
        }
        
        return resultado
    }
    
    var precioMinimo: Double {
        zapatos.map { $0.precio }.min() ?? 0
    }
    
    var precioMaximo: Double {
        zapatos.map { $0.precio }.max() ?? 0
    }
    
    var totalProductos: Int { zapatos.count }
    var productosDisponibles: Int { zapatos.filter { $0.disponible }.count }
    
    func limpiarFiltros() {
        busqueda = ""
        generoSeleccionado = nil
        tipoSeleccionado = nil
        soloDisponibles = false
        ordenPrecio = .ninguno
    }
}
