package pecando.agal.virtual
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * ...
	 * @author zyz
	 */
	dynamic public class Register extends Proxy
	{
		public var v0:RegisterValue;
		public var v1:RegisterValue;
		public var v2:RegisterValue;
		public var v3:RegisterValue;
		
		public var name:String;
		public var index:int;
		
		public function Register(nm:String, id:int)
		{
			v0 = new RegisterValue('x');
			v1 = new RegisterValue('y');
			v2 = new RegisterValue('z');
			v3 = new RegisterValue('w');
			
			name = nm;
			index = id;
		}
		
		public function setValue(vx:Number, vy:Number, vz:Number, vw:Number):void
		{
			v0.value = vx;
			v1.value = vy;
			v2.value = vz;
			v3.value = vw;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			var realname:String = QName(name).localName;
			if (realname.length > 4)
				realname = realname.substr(0, 4);
			var list:Array = [this];
			for (var i:int = 0; i < realname.length; i++)
			{
				switch (realname.charAt(i))
				{
					case 'x': 
						list.push(v0);
						break;
					case 'y': 
						list.push(v1);
						break;
					case 'z': 
						list.push(v2);
						break;
					case 'w': 
						list.push(v3);
						break;
				}
			}
			return list;
		}	
	}
}