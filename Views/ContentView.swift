import SwiftUI

struct ContentView: View {
    @StateObject private var store = ShoeStore()
    @State private var mostrarFiltros = false
    @State private var vistaLista = false
    
    private let columnas = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var hayFiltrosActivos: Bool {
        store.generoSeleccionado != nil ||
        store.tipoSeleccionado != nil ||
        store.soloDisponibles ||
        store.ordenPrecio != .ninguno
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Stats banner
                StatsBanner(store: store)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                
                // Search bar
                HStack(spacing: 10) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Buscar por nombre, SKU, marca...", text: $store.busqueda)
                            .autocorrectionDisabled()
                        if !store.busqueda.isEmpty {
                            Button {
                                store.busqueda = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    
                    // Filtros button
                    Button {
                        mostrarFiltros = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title3)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(hayFiltrosActivos ? Color.accentColor : Color(.systemGray6))
                                )
                                .foregroundStyle(hayFiltrosActivos ? .white : .primary)
                            
                            if hayFiltrosActivos {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                    
                    // Vista toggle
                    Button {
                        withAnimation(.easeInOut) {
                            vistaLista.toggle()
                        }
                    } label: {
                        Image(systemName: vistaLista ? "square.grid.2x2.fill" : "list.bullet")
                            .font(.title3)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                
                // Active filters summary
                if hayFiltrosActivos {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            if let genero = store.generoSeleccionado {
                                ActiveFilterTag(label: genero.rawValue) {
                                    store.generoSeleccionado = nil
                                }
                            }
                            if let tipo = store.tipoSeleccionado {
                                ActiveFilterTag(label: tipo.rawValue) {
                                    store.tipoSeleccionado = nil
                                }
                            }
                            if store.soloDisponibles {
                                ActiveFilterTag(label: "Solo disponibles") {
                                    store.soloDisponibles = false
                                }
                            }
                            if store.ordenPrecio != .ninguno {
                                ActiveFilterTag(label: store.ordenPrecio.rawValue) {
                                    store.ordenPrecio = .ninguno
                                }
                            }
                            Button("Limpiar todo") {
                                store.limpiarFiltros()
                            }
                            .font(.caption)
                            .foregroundStyle(.red)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 6)
                }
                
                // Catalogue
                if store.zapatosFiltrados.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        if vistaLista {
                            LazyVStack(spacing: 12) {
                                ForEach(store.zapatosFiltrados) { zapato in
                                    NavigationLink(destination: ShoeDetailView(zapato: zapato)) {
                                        ShoeListRowView(zapato: zapato)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        } else {
                            LazyVGrid(columns: columnas, spacing: 12) {
                                ForEach(store.zapatosFiltrados) { zapato in
                                    NavigationLink(destination: ShoeDetailView(zapato: zapato)) {
                                        ShoeCardView(zapato: zapato)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("👟 Zapatería Veloz")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $mostrarFiltros) {
                FilterView(store: store)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

// MARK: - Stats Banner
struct StatsBanner: View {
    @ObservedObject var store: ShoeStore
    
    var body: some View {
        HStack(spacing: 0) {
            StatItem(valor: "\(store.totalProductos)", label: "Productos", color: .blue)
            Divider().frame(height: 30)
            StatItem(valor: "\(store.productosDisponibles)", label: "Disponibles", color: .green)
            Divider().frame(height: 30)
            StatItem(valor: store.zapatosFiltrados.count < store.totalProductos ? "\(store.zapatosFiltrados.count)" : "—", label: "Resultados", color: .orange)
        }
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color(.systemGray6)))
    }
}

struct StatItem: View {
    let valor: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(valor)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - List Row View
struct ShoeListRowView: View {
    let zapato: Shoe
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: zapato.colorHex).opacity(0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: zapato.imagenSistema)
                    .font(.title)
                    .foregroundStyle(Color(hex: zapato.colorHex))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(zapato.nombre)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Spacer()
                    Text(zapato.precioFormateado)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundStyle(.accentColor)
                }
                
                HStack(spacing: 6) {
                    Label(zapato.tipo.rawValue, systemImage: "tag.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.secondary)
                    HStack(spacing: 3) {
                        Circle()
                            .fill(Color(hex: zapato.colorHex))
                            .frame(width: 8, height: 8)
                        Text(zapato.color)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                HStack {
                    Text("SKU: \(zapato.sku)")
                        .font(.caption2)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.tertiary)
                    Spacer()
                    StatusBadge(disponible: zapato.disponible)
                        .scaleEffect(0.85)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
    }
}

// MARK: - Active Filter Tag
struct ActiveFilterTag: View {
    let label: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption2)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(Color.accentColor.opacity(0.15)))
        .foregroundStyle(Color.accentColor)
    }
}

// MARK: - Empty State
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.quaternary)
            Text("Sin resultados")
                .font(.title2)
                .fontWeight(.bold)
            Text("Intenta con otros filtros o términos de búsqueda.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
