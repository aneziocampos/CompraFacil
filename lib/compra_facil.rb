class CompraFacil
  
  attr_accessor :origin, 
                :user, 
                :password, 
                :value, 
                :info, 
                :name, 
                :address, 
                :zip_code, 
                :city, 
                :nif, 
                :external_reference, 
                :phone, 
                :email, 
                :user_id_back_office, 
                :reference, 
                :error,
                :payment_company
  
  attr_reader   :user_type, :server_address, :insert_mode
  
  def initialize
    @user_id_back_office = -1
    self.payment_company = "multibanco"
    self.user_type = 10241
    self.insert_mode = "SaveCompraToBDValor2"
  end
  
  def payment_company=(payment_company_text)
    if payment_company_text == "multibanco" or payment_company_text == "payshop"
      @payment_company = payment_company_text
      update_server_address
    else
      raise "payment_company should be 'multibanco' or 'payshop'"
    end
  end

  def insert_mode=(insert_mode_text)
    if insert_mode_text == "SaveCompraToBD1" or insert_mode_text == "SaveCompraToBD2" or insert_mode_text == "SaveCompraToBDValor1" or insert_mode_text == "SaveCompraToBDValor2"
      @insert_mode = insert_mode_text
    else
      raise "insert_mode should be 'SaveCompraToBD1', 'SaveCompraToBD2', 'SaveCompraToBDValor1' or 'SaveCompraToBDValor2'"
    end
  end

  def user_type=(user_type_number)
    if user_type_number == 11249 || user_type_number == 10241
      @user_type = user_type_number
      update_server_address
    else
      raise "user_type should be 10241 or 11249"
    end
  end
  
  def send_order!
    soap = SOAP::WSDLDriverFactory.new(self.server_address).create_rpc_driver
    response = soap.send(self.insert_mode, :IDCliente => self.user,
                                           :password => self.password,
                                           :valor => self.value,
                                           :informacao => self.info,
                                           :nome => self.name,
                                           :morada => self.address,
                                           :codPostal => self.zip_code,
                                           :localidade => self.city,
                                           :NIF => self.nif,
                                           :RefExterna => self.external_reference,
                                           :telefoneContacto => self.phone,
                                           :email => self.email,
                                           :IDUserBackoffice => self.user_id_back_office.to_s,
                                           :origem => self.origin)
    @reference = response.referencia
    @error = response.error
  end
  
  private
  
  def update_server_address
    if @payment_company == "multibanco"
      @server_address = "https://hm.comprafacil.pt/SIBSClick2/webservice/clicksmsV4.asmx?WSDL" if @user_type == 11249
      @server_address = "https://hm.comprafacil.pt/SIBSClick/webservice/clicksmsV4.asmx?WSDL" if @user_type == 10241
    else
      @server_address = "https://hm.comprafacil.pt/SIBSClick2/webservice/CompraFacilPS.asmx?WSDL" if @user_type == 11249
      @server_address = "https://hm.comprafacil.pt/SIBSClick/webservice/CompraFacilPS.asmx?WSDL" if @user_type == 10241
    end
  end
end
