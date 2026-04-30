import SwiftUI

struct ShoeDetailView: View {
    let zapato: Shoe
    @State private var tallaSeleccionada: Double?
    @State private var agregado = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // Hero image section
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(hex: zapato.colorHex).opacity(0.3),
                            Color(hex: zapato.colorHex).opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea(edges: .top)
                    
                    VStack(spacing: 16) {
                        Image(systemName: zapato.imagenSistema)
                            .font(.system(size: 100))
                            .foregroundStyle(Color(hex: zapato.colorHex))
                            .shadow(color: Color(hex: zapato.colorHex).opacity(0.4), radius: 20)
                        
                        Text(zapato.tipo.icono)
                            .font(.system(size: 40))
                    }
                    .padding(.vertical, 40)
                }
                .frame(maxWidth: .infinity)
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(zapato.marca.uppercased())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .tracking(2)
                            
                            Spacer()
                            
                            StatusBadge(disponible: zapato.disponible)
                        }
                        
                        Text(zapato.nombre)
                            .font(.largeTitle)
                            .fontWeight(.black)
                        
                        Text(zapato.precioFormateado)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentColor)
                    }
                    
                    Divider()
                    
                    // Info grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        InfoTile(titulo: "SKU", valor: zapato.sku, icono: "barcode", color: .blue)
                        InfoTile(titulo: "Tipo", valor: zapato.tipo.rawValue, icono: "tag.fill", color: .orange)
                        InfoTile(titulo: "Género", valor: zapato.genero.rawValue, icono: zapato.genero.icono, color: .purple)
                        InfoTile(titulo: "Color", valor: zapato.color, icono: "paintpalette.fill", color: Color(hex: zapato.colorHex))
                    }
                    
                    // Color visual
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: zapato.colorHex))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(zapato.color)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(zapato.colorHex.uppercased())
                                    .font(.caption)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    // Tallas
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Talla")
                                .font(.headline)
                                .fontWeight(.semibold)
                            if let talla = tallaSeleccionada {
                                Text("— Seleccionada: \(String(format: talla.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", talla)) MX")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
                            ForEach(zapato.tallas, id: \.self) { talla in
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        tallaSeleccionada = talla
                                    }
                                } label: {
                                    Text(String(format: talla.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", talla))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(tallaSeleccionada == talla
                                                    ? Color.accentColor
                                                    : Color.gray.opacity(0.1))
                                        )
                                        .foregroundStyle(tallaSeleccionada == talla ? .white : .primary)
                                }
                                .disabled(!zapato.disponible)
                            }
                        }
                    }
                    
                    // Descripción
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descripción")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(zapato.descripcion)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }
                    
                    // Botón agregar al carrito
                    Button {
                        guard tallaSeleccionada != nil else { return }
                        withAnimation(.spring(response: 0.4)) {
                            agregado = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { agregado = false }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: agregado ? "checkmark.circle.fill" : "cart.badge.plus")
                                .font(.title3)
                            Text(agregado ? "¡Agregado al carrito!" : (tallaSeleccionada == nil ? "Selecciona una talla" : "Agregar al carrito"))
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    !zapato.disponible ? Color.gray :
                                    agregado ? Color.green :
                                    tallaSeleccionada == nil ? Color.gray.opacity(0.4) :
                                    Color.accentColor
                                )
                        )
                        .foregroundStyle(.white)
                    }
                    .disabled(!zapato.disponible || tallaSeleccionada == nil)
                    
                    if !zapato.disponible {
                        Text("Este producto está agotado actualmente.")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Subcomponents

struct InfoTile: View {
    let titulo: String
    let valor: String
    let icono: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icono)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(titulo)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(valor)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.08))
        )
    }
}

struct StatusBadge: View {
    let disponible: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(disponible ? Color.green : Color.red)
                .frame(width: 6, height: 6)
            Text(disponible ? "Disponible" : "Agotado")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(disponible ? Color.green : Color.red)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill((disponible ? Color.green : Color.red).opacity(0.1))
        )
    }
}

#Preview {
    NavigationStack {
        ShoeDetailView(zapato: Shoe.catalogo[0])
    }
}
