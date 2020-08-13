public class RandomContactFactory{
    public static List<Contact> generateRandomContacts(Integer count, String lastname){
        List<Contact> conList = new List<Contact>();
        for(integer i=0; i<count; i++){
            Contact con = new Contact();
            con.Lastname = lastname;
            con.Firstname = lastname + i;
            conList.add(con);
        }
        return conList;
    }
}