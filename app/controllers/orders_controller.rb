# frozen_string_literal: true
 
class OrdersController < StoreController
  helper 'spree/products', 'orders'
 
  respond_to :html
 
  before_action :store_guest_token
 
  def show
    @order = Spree::Order.find_by!(number: params[:id])
    authorize! :show, @order, cookies.signed[:guest_token]
    # Genera la factura y envíala por correo electrónico
    generate_invoice(@order)
    send_invoice(@order)
  end
 
  private
 
  def accurate_title
    t('spree.order_number', number: @order.number)
  end
 
  def store_guest_token
    cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
  end
 
  def generate_invoice(order)
    pdf = InvoicePdf.new(order)
    pdf.render_file("public/invoices/invoice_#{order.number}.pdf")
  end
 
  def send_invoice(order)
    invoice_pdf = InvoicePdf.new(order).render
    mail = Mail.new do
      from     'andregonza46@hotmail.com'  
      to       order.email
      subject  'Factura de tu orden LUIS SHOP '
      body     'Gracias por comprar en Luis Shop, Adjuntamos la factura de tu orden.'
    end
    mail.add_file(filename: "invoice_#{order.number}.pdf", content: invoice_pdf)
    mail.delivery_method :smtp, address: 'smtp.sendgrid.net', port: 587, user_name: 'apikey', password: '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'  # Configura los detalles del servidor SMTP
    mail.deliver
  end
end