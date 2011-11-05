package  
{
	import pecando.agal.AGALProxy;
	
	/**
	 * ...
	 * @author zyz
	 */
	public class Fshader extends AGALProxy 
	{
		
		public function Fshader() 
		{
			super(false);
            mov(oc, v0); //Set the output color to the value interpolated from the three triangle vertices 			
		}
		
	}

}