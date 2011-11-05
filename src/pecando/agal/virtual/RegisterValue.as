package pecando.agal.virtual 
{
	/**
	 * ...
	 * @author zyz
	 */
	public class RegisterValue 
	{
		private var _value:Number;
		public var name:String;
		
		public function RegisterValue(nm:String) 
		{
			_value = 0;
			name = nm;
		}
		public function get value():Number
		{
			return _value;
		}
		public function set value(v:Number):void
		{
			_value=v;
		}
	}

}