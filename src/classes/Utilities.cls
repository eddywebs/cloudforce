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
public class Utilities
{
	public static list<String> queryReadbleFields(SObjectType objType){
	//field query tool with FLS check built in :)
	List<String> fields = new List<String>();
	for(String field: new List<String>(objType.getDescribe().fields.getMap().keySet())  ){
        System.debug('checking the field>>'+ field);
        schema.SObjectField sObjectField = objType.getDescribe().fields.getMap().get(field);
        
        if(sObjectField.getDescribe().isAccessible()){
             fields.add(field.trim()); 
        }else
        	{
        		System.debug('Cannot read the field>> '+field+ ' on the object '+objType);
        	}
    }//end of for loop here

   		return fields;
	} 

	// returns the the entire object of the requested id
    // Author: Aditya Rawat
    // @params: recordId
    public static sObject getObjectbyId(Id recordId)
    {
    	SObjectType sObjType = recordId.getSObjectType();
        String fields = String.join(queryReadbleFields(sObjType), ', ');//getSelectFieldsFor(recordId);
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        String soql = 'SELECT ' + fields + ' from ' + sObjName + ' WHERE Id = :recordId';
        return Database.query(soql);
    }
}