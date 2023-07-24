require 'prawn'
require 'prawn/table'
 
class InvoicePdf < Prawn::Document
  def initialize(order)
    super()
    @order = order
    font 'Helvetica'
    generate_invoice
  end
 
  def generate_invoice
    # Agregar el logo de la empresa al encabezado
    logo_path = Rails.root.join('app/assets/images/LSLOGO.png')
    image logo_path, width: 150, height: 80 if File.exist?(logo_path)
 
    # Encabezado de la factura
    move_down 20
    text 'Luis Shop', size: 24, style: :bold, align: :center
    move_down 20
    text "Factura ##{format_invoice_number}", size: 18, style: :bold
    move_down 20
 
    # Datos del comprador
 
   
    text 'Información del comprador:', size: 14, style: :bold
    move_down 10
    text "Nombre: #{buyer_name}"
    text "Dirección: #{buyer_address}"
    text "Correo electrónico: #{buyer_email}"
    move_down 20
 
    # Detalles de la orden
    text 'Detalles de la orden:', size: 14, style: :bold
    move_down 10
 
    table order_items_table_data do
      row(0).font_style = :bold
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.header = true
    end
 
    move_down 20
    text "Total: $#{'%.2f' % @order.total}", size: 16, style: :bold
  end
 
  def format_invoice_number
    "FACT-#{@order&.number}"
  end
 
  def order_items_table_data
    [['Producto', 'Precio', 'Cantidad', 'Subtotal']] +
      @order.line_items.map do |item|
        [item.product.name, item.price, item.quantity, item.total]
      end
  end
 
  # Datos del comprador
def buyer_name
  if @order.bill_address.respond_to?(:full_name)
    @order.bill_address.full_name
  elsif @order.bill_address.respond_to?(:name)
    @order.bill_address.name
  else
    'Nombre del comprador no disponible'
  end
end

 
  def buyer_address
    @order.bill_address.to_s
  end
 
  def buyer_email
    @order.email
  end
end
