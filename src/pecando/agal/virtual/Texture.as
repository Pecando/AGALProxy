package pecando.agal.virtual 
{
	/**
	 * ...
	 * @author zyz
	 */
	public class Texture 
	{
		public var name:String;
		public var index:int;
		
		
		public function Texture(nm:String, id:int) 
		{
			name = nm;
			index = id;
		}
		public function flag(...f):*
		{
			f.unshift(this);
			return f;
		}
	}

}