@isTest
public class TestRestrictContactByName{
    @isTest static void testUpdateContact(){
        Contact con = new Contact();
        con.LastName = 'test Contact';
        insert con;
        
        Test.StartTest();
            con.LastName = 'INVALIDNAME';
            Database.SaveResult ur = database.Update(con, False);
			System.assert(!ur.isSuccess());
        	System.assert(ur.getErrors().Size() > 0);
        Test.Stoptest();
    }
    
    @isTest static void testInsertContact(){
        Contact con = new Contact();
        con.LastName = 'INVALIDNAME';
        
        Test.StartTest();
            Database.SaveResult ur = database.Insert(con, False);
       		System.assert(!ur.isSuccess());
        	System.assert(ur.getErrors().Size() > 0);
		Test.Stoptest();
    }
}