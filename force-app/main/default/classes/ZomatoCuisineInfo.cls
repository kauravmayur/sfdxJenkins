public class ZomatoCuisineInfo {
	
    public List<Cuisines> cuisines;

	public class Cuisines {
		public Cuisine cuisine;
	}
	
	public class Cuisine {
		public Integer cuisine_id;
		public String cuisine_name;
	}

	public static ZomatoCuisineInfo parse(String json) {
		return (ZomatoCuisineInfo) System.JSON.deserialize(json, ZomatoCuisineInfo.class);
	}
	/*
    
  	public List<Cuisines> cuisines;    
    public class Cuisines {
     	public CuisineInfo cuisineInfo;
  	}
    
    public class CuisineInfo{
        
        public integer cuisine_id;
      	public string cuisine_name;
  	}
  	
    public static ZomatoCuisineInfo parse(String json) {
        system.debug('***ZomatoCuisineInfo***'+json);
        return (ZomatoCuisineInfo) System.JSON.deserialize(json, ZomatoCuisineInfo.class);
    }
	*/
}