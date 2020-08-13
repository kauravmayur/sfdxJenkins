public with sharing class ActionMethods1_Controller {
  /**
    * Webkul Software.
    *
    * @category  Webkul
    * @author    Webkul
    * @copyright Copyright (c) 2010-2016 Webkul Software Private Limited (https://webkul.com)
    * @license   https://store.webkul.com/license.html
    */
   
    Account myAccount;
    integer i =0;
    //Creates an account record.
    public PageReference createAccount() {
        //Create an account using DML operation.
        if(i<5){
            myAccount = new Account(name = 'Webkul Software Pvt. Ltd.');
            insert myAccount;
            i++;
            return null;
        }  else {
            pageReference pg =page.ActionMethods_vf;
            pg.setRedirect(true);
            return pg;
        }
        
    }
     
    public PageReference updateAccount() {
       // Update the same account record  
        myAccount.Name = 'Webkul After Update';
        update myAccount; 
        return null;
    }
     
}