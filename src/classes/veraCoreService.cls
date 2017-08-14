/**
 * See https://github.com/financialforcedev/fflib-apex-common for more info
 *
 * Install library via
 *   https://githubsfdeploy.herokuapp.com/app/githubdeploy/financialforcedev/fflib-apex-common
 */

/**
 * Encapsulates all service layer logic for a given function or module in the application
 * 
 * For more guidelines and details see 
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Service_Layer
 *
 **/
public class veraCoreService
{
	public static void processOrders(List<Order> newOrders)
	{
		System.debug('here comes the new vera core orders>>'+ newOrders);

		for(Order o :  newOrders){
			omscom.Order order = new omscom.Order();
			order.Header = new omscom.OrderHeader();
			order.Header.ID = o.OrderNumber;
			order.Header.EntryDate = o.EffectiveDate;
			order.Header.PONumber = o.PoNumber;
			order.Header.Comments = o.Description;

            //ingerating shipping carrier method (hopefully)
        	order.Shipping = new omscom.OrderShipping();
            order.Shipping.FreightCarrier = new omscom.FreightCarrier();
            order.Shipping.FreightCarrier.Name = o.Shipping_Method__c;
        	order.Shipping.FreightCode = o.Freight_Code__c;

            //Integrating order by info
            // todo : order.OrderedBy.Company = 
            // info : we are mapping veracore's Ordered by address to Billing address in salesforce
        	order.OrderedBy = new omscom.OrderedBy() ;
        	order.OrderedBy.FullName = o.Billing_Name__c;
        	order.OrderedBy.CityStateZip =  o.BillingCity+o.BillingState+o.BillingPostalCode;
        	order.OrderedBy.CityStateZipCountry = o.BillingCity+o.BillingState+o.BillingPostalCode+o.BillingCountry	;
        	order.OrderedBy.CompoundAddress = o.BillingStreet;
        	
            //Intgerating Ship to info
        	order.ShipTo = new omscom.ArrayOfOrderShipTo();
        	omscom.OrderShipTo orderShipTo = new omscom.OrderShipTo(); //Order[] orders = new List<Order>();
        	//Contact shipToContact = (Contact)Utilities.getObjectbyId(o.ShipToContactId);
        	orderShipTo.Key = '0'; // ? hardcode the key ?


        	//orderShipTo.FullName = shipToContact.FirstName+' '+shipToContact.LastName;

        	// todo orderShipTo.Company
        	//orderShipTo.CompoundAddress = o.ShippingAddress.StreetAddress;
        	//orderShipTo.CityStateZip = o.ShippingCity+o.ShippingState+o.ShippingPostalCode;
        	//orderShipTo.Phone = shipToContact.MobilePhone;
        	orderShipTo.Flag = 'Other'; // question : what does Flag mean ?
        	orderShipTo.Key = '0'; //question : what does key field mean?
        	order.ShipTo.OrderShipTo = new List<omscom.OrderShipTo>();
        	order.ShipTo.OrderShipTo.Add(orderShipTo);
			
			order.BillTo = new omscom.OrderBillTo() ;
        	order.BillTo.FullName = order.OrderedBy.FullName;
        	order.BillTo.CityStateZip = order.OrderedBy.CityStateZip;
        	order.BillTo.Flag = 'Other';


            order.Offers = new omscom.ArrayOfOfferOrdered();
            //get all products attached to this order
            for(OrderItem sku : [select Quantity, Pricebookentry.Product2Id from OrderItem where orderid =: o.ID] ){
            	omscom.OfferOrdered product = new omscom.OfferOrdered();
            	Product2 prod2 = (Product2)Utilities.getObjectbyId(sku.Pricebookentry.Product2Id);
            	System.debug('fetched product is >>'+prod2);

            	product.Quantity = (Integer)sku.Quantity;
            	product.Offer = new omscom.OfferID();
            	product.Offer.Header = new omscom.OfferIDHeader();

            	product.Offer.Header.ID = prod2.ProductCode;
            	product.OrderShipTo = new omscom.OrderShipToKey();
            	product.OrderShipTo.Key = '0';
            	//finally add the product as offer
            	order.Offers.OfferOrdered = new List<omscom.OfferOrdered>();
            	order.Offers.OfferOrdered.Add(product);

            }

            omscom.OMSSoap maClass = new omscom.OMSSoap();
			maClass.endpoint_x =  Veracore__C.getInstance().endpoint_url__c;
			maClass.AuthenticationHeader = new omscom.AuthenticationHeader();
			maClass.AuthenticationHeader.Username = Veracore__C.getInstance().username__C;
			maClass.AuthenticationHeader.Password= Veracore__C.getInstance().password__c;
            
            System.debug(maClass.AddOrder(order));


       
		}//end of for loop		
	}


	public static omscom.OrderInqRecord getOrderDetails(String orderid){

		omscom.OMSSoap maClass = new omscom.OMSSoap();
		maClass.endpoint_x =  Veracore__C.getInstance().endpoint_url__c;
		maClass.AuthenticationHeader = new omscom.AuthenticationHeader();
		maClass.AuthenticationHeader.Username = Veracore__C.getInstance().username__C;
		maClass.AuthenticationHeader.Password= Veracore__C.getInstance().password__c;


		//String result =JSON.serialize(maClass.GetOrderInfo(orderid));
		//System.debug(result);
		
		return maClass.GetOrderInfo(orderid);
	}
}