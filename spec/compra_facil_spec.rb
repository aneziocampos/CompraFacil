require File.expand_path(File.dirname(__FILE__) + '/../lib/compra_facil')

describe CompraFacil do
  
  before(:each) do
    @compra_facil = CompraFacil.new
  end
  
  it "should have valid fields" do
    @compra_facil.origin = "www.teste.com/receive_payment"
    @compra_facil.user = "test_user"
    @compra_facil.password = "asdfghjkl"
    @compra_facil.value = 10
    @compra_facil.info = "info about this order"
    @compra_facil.name = "Jose do Teste"
    @compra_facil.address = "Elm Street 2009"
    @compra_facil.zip_code = "123456"
    @compra_facil.city = "Londrina"
    @compra_facil.nif = "123456789"
    @compra_facil.external_reference = "999"
    @compra_facil.phone = "321-456789"
    @compra_facil.email = "teste@teste.com"
    @compra_facil.user_id_back_office = -1
    @compra_facil.reference = "200-000-000"
    @compra_facil.error = "Error on name"
    @compra_facil.payment_company = "multibanco"
    
    @compra_facil.origin.should == "www.teste.com/receive_payment"
    @compra_facil.user.should == "test_user"
    @compra_facil.password.should == "asdfghjkl"
    @compra_facil.value.should == 10
    @compra_facil.info.should == "info about this order"
    @compra_facil.address.should == "Elm Street 2009"
    @compra_facil.zip_code.should == "123456"
    @compra_facil.city.should == "Londrina"
    @compra_facil.nif.should == "123456789"
    @compra_facil.external_reference.should == "999"
    @compra_facil.phone.should == "321-456789"
    @compra_facil.email.should == "teste@teste.com"
    @compra_facil.user_id_back_office.should == -1
    @compra_facil.reference.should == "200-000-000"
    @compra_facil.error.should == "Error on name"
    @compra_facil.payment_company == "multibanco"
  end
  
  it "should fill fields with a hash" do
    c = CompraFacil.new({:user => "test_user", :password => "valid_password"})
    c.user.should == "test_user"
    c.password.should == "valid_password"
  end
  
  it "should set some fields in a new object" do
    @compra_facil.user_id_back_office.should == -1
    @compra_facil.user_type.should == 10241
    @compra_facil.insert_mode.should == "SaveCompraToBDValor2"
  end
  
  it "should throw an exception if invalid payment company" do
    @compra_facil.payment_company = "multibanco"
    @compra_facil.payment_company.should == "multibanco"
    lambda {@compra_facil.payment_company = "oi"}.should raise_error("payment_company should be 'multibanco' or 'payshop'")
  end

  it "should throw an exception if invalid insert mode" do
    @compra_facil.insert_mode = "SaveCompraToBD1"
    @compra_facil.insert_mode.should == "SaveCompraToBD1"
    lambda {@compra_facil.insert_mode = "oi"}.should raise_error("insert_mode should be 'SaveCompraToBD1', 'SaveCompraToBD2', 'SaveCompraToBDValor1' or 'SaveCompraToBDValor2'")
  end
  
  it "should throw an exception if invalid user_type" do
    @compra_facil.user_type = 11249
    @compra_facil.user_type.should == 11249
    lambda {@compra_facil.user_type = 33333 }.should raise_error("user_type should be 10241 or 11249")
  end
  
  it "should set server address when select a user_type or a payment company" do
    @compra_facil.user_type = 11249
    @compra_facil.server_address.should == "https://hm.comprafacil.pt/SIBSClick2/webservice/clicksmsV4.asmx?WSDL"
    @compra_facil.user_type = 10241
    @compra_facil.server_address.should == "https://hm.comprafacil.pt/SIBSClick/webservice/clicksmsV4.asmx?WSDL"
    @compra_facil.payment_company = "payshop"
    @compra_facil.server_address.should == "https://hm.comprafacil.pt/SIBSClick/webservice/CompraFacilPS.asmx?WSDL"
    @compra_facil.user_type = 11249
    @compra_facil.server_address.should == "https://hm.comprafacil.pt/SIBSClick2/webservice/CompraFacilPS.asmx?WSDL"
  end
  
  it "should send order to compra facil server" do
    SOAP::WSDLDriverFactory.should_receive(:new).and_return(soap = "soap")
    soap.should_receive(:create_rpc_driver).and_return(soap = "soap")
    soap.should_receive(:send).and_return(result = "9999")
    result.should_receive(:referencia).and_return("1234")
    result.should_receive(:error).and_return(nil)
    @compra_facil.origin = "www.teste.com/receive_payment"
    @compra_facil.user = "test_user"
    @compra_facil.password = "asdfghjkl"
    @compra_facil.value = 10
    @compra_facil.info = "info about this order"
    @compra_facil.name = "Jose do Teste"
    @compra_facil.address = "Elm Street 2009"
    @compra_facil.zip_code = "123456"
    @compra_facil.city = "Londrina"
    @compra_facil.nif = "123456789"
    @compra_facil.external_reference = "999"
    @compra_facil.phone = "321-456789"
    @compra_facil.email = "teste@teste.com"
    @compra_facil.user_id_back_office = -1
    @compra_facil.reference = "200-000-000"
    @compra_facil.error = "Error on name"
    
    @compra_facil.send_order!.should == nil    
  end
end
