public class ZomatoFindLocation {
   @InvocableMethod(label='Zomato Find Location')
    public static List<String> locate( List<String> location ){
        System.debug('***ZomatoFindLocation***'+location);
        return ZomatoAPI.locate(location[0]);
    }
}