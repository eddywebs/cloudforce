//omscom.OMSSoap.AuthenticationHeader auth2 = new omscom.OMSSoap.AuthenticationHeader('retro', 'Cru$h37')
omscom.OMSSoap maClass = new omscom.OMSSoap();
maClass.AuthenticationHeader = new omscom.AuthenticationHeader();
maClass.AuthenticationHeader.Username ='retro';
maClass.AuthenticationHeader.Password='';
String result = JSON.serialize(maClass.GetOrderInfo('1038'));
System.debug(result);


