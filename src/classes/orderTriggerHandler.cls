public with sharing class orderTriggerHandler {
  // This should be used in conjunction with the ApexTriggerComprehensive.trigger template
  // The origin of this pattern is http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx
  private boolean m_isExecuting = false;
  private integer BatchSize = 0;

  public orderTriggerHandler(boolean isExecuting, integer size){
    m_isExecuting = isExecuting;
    BatchSize = size;
  }

  public void OnBeforeInsert(Order[] newRecords){
    /*
    //Example usage
    for(Order newRecord : newRecords){
      if(newRecord.AnnualRevenue == null){
        newRecord.AnnualRevenue.addError('Missing annual revenue');
      }
    }
    */
  }

  public void OnAfterInsert(Order[] newRecords){

  }

  @future public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    //fetch and process veracore orders if any
    List<Order> veraCoreOrders = [select Id, Name from Order where Id IN :newRecordIDs and Warehouse_Service__C = 'veracore'];
    veraCoreService.processOrders(veraCoreOrders);

  }

  public void OnBeforeUpdate(Order[] oldRecords, Order[] updatedRecords, Map<ID, Order> recordMap){
    //Example Map usage
    //Map<ID, Contact> contacts = new Map<ID, Contact>( [select Id, FirstName, LastName, Email from Contact where OrderId IN :recordMap.keySet()] );
  }

  public void OnAfterUpdate(Order[] oldRecords, Order[] updatedRecords, Map<ID, Order> recordMap){

  }

  @future public static void OnAfterUpdateAsync(Set<ID> updatedRecordIDs){
    //List<Order> updatedRecords = [select Id, Name from Order where Id IN :updatedRecordIDs];
  }

  public void OnBeforeDelete(Order[] recordsToDelete, Map<ID, Order> recordMap){

  }

  public void OnAfterDelete(Order[] deletedRecords, Map<ID, Order> recordMap){

  }

  @future public static void OnAfterDeleteAsync(Set<ID> deletedRecordIDs){

  }

  public void OnUndelete(Order[] restoredRecords){

  }

  public boolean IsTriggerContext{
    get{ return m_isExecuting;}
  }

  public boolean IsVisualforcePageContext{
    get{ return !IsTriggerContext;}
  }

  public boolean IsWebServiceContext{
    get{ return !IsTriggerContext;}
  }

  public boolean IsExecuteAnonymousContext{
    get{ return !IsTriggerContext;}
  }
}