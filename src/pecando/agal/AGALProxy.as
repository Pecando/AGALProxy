package pecando.agal
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import pecando.agal.virtual.Register;
	import pecando.agal.virtual.Texture;
	
	/**
	 * ...
	 * @author zyz
	 */
	public class AGALProxy
	{
		public static const D2:String = "2d";
        public static const D3:String = "3d";
        public static const cube:String = "cube";
        public static const mipnearest:String = "mipnearest";
        public static const miplinear:String = "miplinear";
        public static const mipnone:String = "mipnone";
        public static const nomip:String = "nomip";
        public static const nearest:String = "nearest";
        public static const linear:String = "linear";
        public static const centroid:String = "centroid";
        public static const single:String = "single";
        public static const depth:String = "depth";
        public static const repeat:String = "repeat";
        public static const wrap:String = "wrap";
        public static const clamp:String = "clamp";
		
		public var attribute:Dictionary;
		public var constant:Dictionary;
		
		public var v0:Register;
		public var v1:Register;
		public var v2:Register;
		public var v3:Register;
		public var v4:Register;
		public var v5:Register;
		public var v6:Register;
		public var v7:Register;
		
		public var vt0:Register;
		public var vt1:Register;
		public var vt2:Register;
		public var vt3:Register;
		public var vt4:Register;
		public var vt5:Register;
		public var vt6:Register;
		public var vt7:Register;
		
		public var op:Register;
		public var vo:Register;
		
		public var ft0:Register;
		public var ft1:Register;
		public var ft2:Register;
		public var ft3:Register;
		public var ft4:Register;
		public var ft5:Register;
		public var ft6:Register;
		public var ft7:Register;
		
		public var fs0:Texture;
		public var fs1:Texture;
		public var fs2:Texture;
		public var fs3:Texture;
		public var fs4:Texture;
		public var fs5:Texture;
		public var fs6:Texture;
		public var fs7:Texture;
		
		public var oc:Register;
		public var fo:Register;
		
		public var texture:Dictionary;

		private var codes:Array;
		
		private var prefix:String;
		
		public function AGALProxy(isVertex:Boolean = true)
		{
			prefix = isVertex?'v':'f';
			
			v0 = new Register('v', 0);
			v1 = new Register('v', 1);
			v2 = new Register('v', 2);
			v3 = new Register('v', 3);
			v4 = new Register('v', 4);
			v5 = new Register('v', 5);
			v6 = new Register('v', 6);
			v7 = new Register('v', 7);

			constant = new Dictionary();
			
			codes = new Array();
			
			if (isVertex)
			{
				attribute = new Dictionary();
				vt0 = new Register('vt', 0);
				vt1 = new Register('vt', 1);
				vt2 = new Register('vt', 2);
				vt3 = new Register('vt', 3);
				vt4 = new Register('vt', 4);
				vt5 = new Register('vt', 5);
				vt6 = new Register('vt', 6);
				vt7 = new Register('vt', 7);
				op = new Register('op', -1);
				vo = op;
			}
			else
			{
				texture = new Dictionary();
				ft0 = new Register('ft', 0);
				ft1 = new Register('ft', 1);
				ft2 = new Register('ft', 2);
				ft3 = new Register('ft', 3);
				ft4 = new Register('ft', 4);
				ft5 = new Register('ft', 5);
				ft6 = new Register('ft', 6);
				ft7 = new Register('ft', 7);
				oc = new Register('oc', -1);
				fo = oc;
			}		
		}
		
		public function getConstants(index:int):Register
		{
			var c:Register = constant[index];
			if (c == null)
			{
				c = new Register(prefix+'c', index);
				constant[index] = c;
			}
			return c;
		}
		
		public function getAttribute(index:int):Register
		{
			var a:Register = attribute[index];
			if (a == null)
			{
				a = new Register('va', index);
				attribute[index] = a;
			}
			return a;
		}
		
		public function getTexture(index:int):Texture
		{
			var t:Texture = texture[index];
			if (t == null)
			{
				t = new Texture('fs', index);
				texture[index] = t;
			}
			return t;
		}
		
		public function setProgramConstantsFromMatrix(programType:String, firstRegister:int, matrix:Matrix3D, transposedMatrix:Boolean = false):void
		{
			var m:Matrix3D = matrix.clone();
			
			if (transposedMatrix)
				m.transpose();
			
			setProgramConstantsFromVector('', firstRegister, m.rawData, 4);
		}
		
		public function setProgramConstantsFromVector(programType:String, firstRegister:int, data:Vector.<Number>, numRegisters:int = -1):void
		{
			if (data.length < numRegisters * 4)
				throw 'Not enough data for program constants.';
			var vpos:Number = 0;
			for (var i:int = 0; i < numRegisters; i++)
			{
				var c:Register;
				if (constant[firstRegister + i] == null)
				{
					c = new Register(prefix+'c', firstRegister + i);
					constant[firstRegister + i] = c;
				}
				else
				{
					c = constant[firstRegister + i];
					trace('Constant Register ' + (firstRegister + i) + ' overriden.');
				}
				c.setValue(data[vpos + 0], data[vpos + 1], data[vpos + 2], data[vpos + 3]);
				vpos += 4;
			}
		}
		
		//public function setTextureAt(sampler:int, texture:TextureBase):void
		//{
		//}
		
		public function setVertexBufferAt(index:int, buffer:Vector.<Number>, bufferOffset:int = 0, format:String = "float4"):void
		{
			var a:Register;
			if (attribute[index] == null)
			{
				a = new Register('va', index);
				attribute[index] = a;
			}
			else
			{
				a = attribute[index];
				trace('Attribute Register ' + index + ' overriden.');
			}
			switch (format)
			{
				case Context3DVertexBufferFormat.BYTES_4: 
					var value:Number = buffer[bufferOffset];
					a.setValue(value >>> 24, (value & 0xff0000) >>> 16, (value & 0xff00) >>> 8, value & 0xff);
					break;
				case Context3DVertexBufferFormat.FLOAT_1: 
					a.setValue(buffer[bufferOffset], 0, 0, 0);
					break;
				case Context3DVertexBufferFormat.FLOAT_2: 
					a.setValue(buffer[bufferOffset], buffer[bufferOffset + 1], 0, 0);
					break;
				case Context3DVertexBufferFormat.FLOAT_3: 
					a.setValue(buffer[bufferOffset], buffer[bufferOffset + 1], buffer[bufferOffset + 2], 0);
					break;
				case Context3DVertexBufferFormat.FLOAT_4: 
					a.setValue(buffer[bufferOffset], buffer[bufferOffset + 1], buffer[bufferOffset + 2], buffer[bufferOffset + 3]);
					break;
			}
		}
		public function setTextureAt(sampler:int, tex:TextureBase):void
		{
			texture[sampler] = new Texture('fs', sampler);
		}
		
		public function mov(des:*, src:*):void
		{
			codes.push('mov', [formatDest(des), formatSrc(src)]);
		}
		
		public function add(des:*, src1:*, src2:*):void
		{
			codes.push('add', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function sub(des:*, src1:*, src2:*):void
		{
			codes.push('sub', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function mul(des:*, src1:*, src2:*):void
		{
			codes.push('mul', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function div(des:*, src1:*, src2:*):void
		{
			codes.push('div', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function rcp(des:*, src:*):void
		{
			codes.push('rcp', [formatDest(des), formatSrc(src)]);
		}
		
		public function min(des:*, src1:*, src2:*):void
		{
			codes.push('min', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function max(des:*, src1:*, src2:*):void
		{
			codes.push('max', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function frc(des:*, src:*):void
		{
			codes.push('frc', [formatDest(des), formatSrc(src)]);
		}
		
		public function sqt(des:*, src:*):void
		{
			codes.push('sqt', [formatDest(des), formatSrc(src)]);
		}
		
		public function rsq(des:*, src:*):void
		{
			codes.push('rsq', [formatDest(des), formatSrc(src)]);
		}
		
		public function pow(des:*, src1:*, src2:*):void
		{
			codes.push('pow', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function log(des:*, src:*):void
		{
			codes.push('log', [formatDest(des), formatSrc(src)]);
		}
		
		public function exp(des:*, src:*):void
		{
			codes.push('exp', [formatDest(des), formatSrc(src)]);
		}
		
		public function nrm(des:*, src:*):void
		{
			codes.push('nrm', [formatDest(des), formatSrc(src)]);
		}
		
		public function sin(des:*, src:*):void
		{
			codes.push('sin', [formatDest(des), formatSrc(src)]);
		}
		
		public function cos(des:*, src:*):void
		{
			codes.push('cos', [formatDest(des), formatSrc(src)]);
		}
		
		public function crs(des:*, src1:*, src2:*):void
		{
			codes.push('crs', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function dp3(des:*, src1:*, src2:*):void
		{
			codes.push('dp3', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function dp4(des:*, src1:*, src2:*):void
		{
			codes.push('dp4', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function abs(des:*, src:*):void
		{
			codes.push('abs', [formatDest(des), formatSrc(src)]);
		}
		
		public function neg(des:*, src:*):void
		{
			codes.push('neg', [formatDest(des), formatSrc(src)]);
		}
		
		public function sat(des:*, src:*):void
		{
			codes.push('sat', [formatDest(des), formatSrc(src)]);
		}
		
		public function m33(des:*, src1:*, src2:*):void
		{
			codes.push('m33', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function m44(des:*, src1:*, src2:*):void
		{
			codes.push('m44', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function rm34(des:*, src1:*, src2:*):void
		{
			codes.push('m34', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function kil(src:*):void
		{
			codes.push('kil', [formatSrc(src)]);
		}
		
		public function tex(des:*, src:*, tex:*):void
		{
			codes.push('tex', [formatDest(des), formatSrc(src), formatSam(tex)]);
		}
		
		public function sge(des:*, src1:*, src2:*):void
		{
			codes.push('sge', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function slt(des:*, src1:*, src2:*):void
		{
			codes.push('slt', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function seq(des:*, src1:*, src2:*):void
		{
			codes.push('seq', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		public function sne(des:*, src1:*, src2:*):void
		{
			codes.push('sne', [formatDest(des), formatSrc(src1), formatSrc(src2)]);
		}
		
		private function formatDest(value:*):destination
		{
			var dest:destination = new destination();
			if (value is Array)
			{
				dest.reg = value[0];
				dest.value = new Array();
				for (var i:int = 1; i < value.length; i++)
				{
					dest.value.push(value[i]);
				}
			}
			else if (value is Register)
			{
				dest.reg = value;
				dest.value = [value.v0, value.v1, value.v2, value.v3];
			}
			else
			{
				dest = null;
			}
			return dest;
		}
		
		private function formatSrc(value:*):source
		{
			var src:source = new source();
			if (value is Array)
			{
				src.reg = value[0];
				src.value = new Array();
				for (var i:int = 1; i < value.length; i++)
				{
					src.value.push(value[i]);
				}
				while (src.value.length != 4)
				{
					src.value.push(value[i - 1]);
				}
			}
			else if (value is Register)
			{
				src.reg = value;
				src.value = [value.v0, value.v1, value.v2, value.v3];
			}
			else
			{
				src = null;
			}
			return src
		}
		
		private function formatSam(value:*):sample
		{
			var sam:sample = new sample();
			if (value is Array)
			{
				sam.tex = value[0];
				sam.flag = new Array();
				for (var i:int = 1; i < value.length; i++)
				{
					sam.flag.push(value[i]);
				}
			}
			else if (value is Texture)
			{
				sam.tex = value;
				sam.flag = new Array();
			}
			else
			{
				sam = null;
			}
			return sam;
		}
		
		public function toString(useInCode:Boolean = false):String
		{
			var code:String = '';
			if (!useInCode)
			{
				for (var i:int = 0; i < codes.length; i += 2)
				{
					var operand:Array = codes[i + 1];
					code += codes[i];
					code += ' ';
					for (var j:int = 0; j < operand.length; j++)
					{
						if (j != 0)
							code += ',';
						code += operand[j].toString();
					}
					code += '\n';
				}
			}
			else
			{
				
			}
			return code;
		}
		
		public function disassemble(bytes:ByteArray):void
		{
			throw 'Not implemented yet';
		}
		
		public function simulate():void
		{
			throw 'Not implemented yet';
		}
	}
}
import pecando.agal.virtual.Register;
import pecando.agal.virtual.Texture;

class source
{
	public var reg:Register;
	public var value:Array;
	
	public function toString():String
	{
		var str:String = '';
		str += reg.name;
		str += reg.index < 0 ? '' : reg.index.toString();
		str += '.';
		for (var i:int = 0; i < value.length; i++)
		{
			str += value[i].name;
		}
		return str;
	}
}

class destination
{
	public var reg:Register;
	public var value:Array;
	
	public function toString():String
	{
		var str:String = '';
		str += reg.name;
		str += reg.index < 0 ? '' : reg.index.toString();
		str += '.';
		for (var i:int = 0; i < value.length; i++)
		{
			str += value[i].name;
		}
		return str;
	}
}

class sample
{
	public var tex:Texture;
	public var flag:Array;
	public function toString():String
	{
		var str:String = '';
		str += tex.name + tex.index.toString();
		str += ' < ';
		str += flag.join(',');
		str += ' >';
		return str;
	}
}