import SwiftUI

struct FilterView: View {
    @ObservedObject var store: ShoeStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // Género
                Section("Género") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                label: "Todos",
                                isSelected: store.generoSeleccionado == nil
                            ) { store.generoSeleccionado = nil }
                            
                            ForEach(Genero.allCases, id: \.self) { genero in
                                FilterChip(
                                    label: genero.rawValue,
                                    isSelected: store.generoSeleccionado == genero
                                ) { store.generoSeleccionado = genero }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                
                // Tipo de calzado
                Section("Tipo de Calzado") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                label: "Todos",
                                isSelected: store.tipoSeleccionado == nil
                            ) { store.tipoSeleccionado = nil }
                            
                            ForEach(TipoCalzado.allCases, id: \.self) { tipo in
                                FilterChip(
                                    label: "\(tipo.icono) \(tipo.rawValue)",
                                    isSelected: store.tipoSeleccionado == tipo
                                ) { store.tipoSeleccionado = tipo }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                
                // Orden por precio
                Section("Ordenar por Precio") {
                    Picker("Orden", selection: $store.ordenPrecio) {
                        ForEach(ShoeStore.OrdenPrecio.allCases, id: \.self) { orden in
                            Text(orden.rawValue).tag(orden)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                
                // Disponibilidad
                Section("Disponibilidad") {
                    Toggle("Solo mostrar disponibles", isOn: $store.soloDisponibles)
                }
                
                // Resumen
                Section {
                    HStack {
                        Label("Resultados encontrados", systemImage: "magnifyingglass")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Spacer()
                        Text("\(store.zapatosFiltrados.count) productos")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.accentColor)
                    }
                }
            }
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Limpiar") {
                        store.limpiarFiltros()
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Aplicar") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.12))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
