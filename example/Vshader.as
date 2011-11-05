package  
{
	import pecando.agal.AGALProxy;
	import pecando.agal.virtual.Register;
	
	/**
	 * ...
	 * @author zyz
	 */
	public class Vshader extends AGALProxy 
	{
		
		public function Vshader() 
		{
			super();
			var pos:Register = getAttribute(0);
			var color:Register = getAttribute(1);
			mov(op, pos); //copy position to output 
			mov(v0, color); //copy color to varying variable v0
		}
		
	}

}